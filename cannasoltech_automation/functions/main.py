# Welcome to Cloud Functions for Firebase for Python!
# To get started, simply uncomment the below code or create your own.
# Deploy with firebase deploy
from functions_framework import http

from dataclasses import asdict, dataclass
from datetime import datetime, timezone, timedelta
from io import BytesIO
from typing import List
from firebase_functions import https_fn, db_fn
import firebase_admin as admin
from firebase_admin import auth, db, messaging, exceptions
import smtplib
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart
import json
from constants import *
from simulation import *
from openpyxl import Workbook
from google.cloud import storage
from functions_framework import http
from firebase_admin import credentials

cred = credentials.Certificate("serviceAccountKey.json")
admin.initialize_app()

import os
from common import *


serviceAccount = "serviceAccountKey.json"


def get_state_value(device_ref, param):
    return device_ref.child('State').get().get(param)

def get_system_run_logs(deviceId):
    log_config = {
        'batch_size', 
        'cool_down_temp', 
        'enable_cooldown', 
        'flow_thresh', 
        'pressure_thresh', 
        'set_hours', 
        'set_minutes', 
        'set_temp'
    }
    device_ref = db.reference(f'Devices/{deviceId}')
    start_time: str = device_ref.child('CurrentRun').child('start_time').get()
    end_time: str = device_ref.child('CurrentRun').child('end_time').get()
    start_user: str = device_ref.child('CurrentRun').child('start_user').get()
    run_hours: int = get_state_value(device_ref, "run_hours")
    run_minutes: int = get_state_value(device_ref, "run_minutes")
    run_seconds: int = get_state_value(device_ref, "run_seconds")
    avg_flow_rate: float = get_state_value(device_ref, "avg_flow_rate")
    avg_temp: float = get_state_value(device_ref, "avg_temp")
    num_passes: float = get_state_value(device_ref, "num_passes")
    device_config = device_ref.child('Config').get()    
    alarm_logs = device_ref.child('AlarmLogs').get()
    system_config = {key: device_config.get(key) for key in device_config if key in log_config}
    return SystemRunLog(
        start_time=start_time,
        end_time=end_time,
        start_user=start_user,
        system_config=system_config,
        alarm_logs=alarm_logs,
        run_hours=run_hours, 
        run_minutes=run_minutes, 
        run_seconds=run_seconds, 
        avg_flow_rate=avg_flow_rate, 
        avg_temp=avg_temp, 
        num_passes=num_passes
    )
    
def clear_previous_run_logs(device_id):
    alarmLogsRef = db.reference(f"Devices/{device_id}/AlarmLogs")
    try:
        alarmLogsRef.delete()
        print('List deleted successfully.')
    except Exception as e:
        print(f'Error while deleting the AlarmLogs: {e}')
    currentRunRef = db.reference(f"Devices/{device_id}/CurrentRun")
    try:
        currentRunRef.delete()
    except Exception as e:
        print(f'Error while deleting the CurrentRun logs: {e}')
    
def save_system_start_time(device_id):
    device_ref = db.reference(f'Devices/{device_id}')
    device_ref.child('CurrentRun').update(
        {
            "start_time": int(time.time()),
            "end_time": "N/A",
            "start_user": "None"
        }
    )

def save_system_end_time(device_id):
    device_ref = db.reference(f'Devices/{device_id}')
    device_ref.child('CurrentRun').update(
        {
            "end_time": int(time.time())
        }
    )
    
@db_fn.on_value_updated(reference=r"Devices/{deviceId}/Config/start")
def handle_device_start(event: db_fn.Event[db_fn.Change]) -> None:
    if event.data.after == 1 and event.data.before == 0:
        device_id = event.params["deviceId"]
        save_system_start_time(device_id)

@db_fn.on_value_updated(reference=r"Devices/{deviceId}/State/state")
def handle_state_change(event: db_fn.Event[db_fn.Change]) -> None:
    device_id = event.params["deviceId"]
    if  event.data.after == END_STATE and event.data.before != END_STATE:
        save_system_end_time(device_id)
        system_run_log = get_system_run_logs(device_id)
        print(f"DEBUG -> Pushing system_run_log = {asdict(system_run_log)} for device_id = {device_id}")
        db.reference(f'/Devices/{device_id}/History').push(asdict(system_run_log))
    if event.data.after == INIT_STATE and event.data.before != INIT_STATE:
        clear_previous_run_logs(device_id)

@db_fn.on_value_created(reference=r"users/{userId}/watched_devices/{watchedDeviceId}")
def add_device_watcher(event: db_fn.Event[db_fn.Event]) -> None:
    """Triggers when a user gets a new follower and sends a notification"""
    userId = event.params["userId"]
    watchedDeviceId = event.params["watchedDeviceId"]
    device_ref = db.reference(f"Devices/{watchedDeviceId}/Watchers/")
    device_ref.update({userId: True})     

@db_fn.on_value_deleted(reference=r"users/{userId}/watched_devices/{watchedDeviceId}")
def remove_device_watcher(event: db_fn.Event[db_fn.Event]) -> None:
    watchers_ref = db.reference(f"Devices/{event.params["watchedDeviceId"]}/Watchers/")
    watchers_ref.child(event.params["userId"]).delete()
    
    
@dataclass
class DeviceAlarm:
    type: str
    start_time: int
    cleared_time: int
    
def log_device_alarm(deviceId, alarm, alarmActive):
    alarm = alarm.replace("_", " ").capitalize()
    if alarmActive:
        db.reference(f"Devices/{deviceId}/AlarmLogs").push(
            asdict(
                DeviceAlarm(
                    type=alarm,
                    start_time=int(time.time()),
                    cleared_time=0
                )
            )
        )
    else:
        alarmRef = db.reference(f"Devices/{deviceId}/AlarmLogs")
        alarms = alarmRef.get()
        if alarms is not None:
            for alarmId in alarms:
                if alarms[alarmId].get('type') == alarm.replace(" cleared", "").capitalize() and alarms[alarmId].get("cleared_time") == 0:
                    # db.reference(f"Devices/{deviceId}/AlarmLogs/{alarmId}").child('cleared_time').delete()
                    db.reference(f"Devices/{deviceId}/AlarmLogs/{alarmId}").update(
                        {
                            "cleared_time": int(time.time())
                        }
                    )
        

@db_fn.on_value_updated(reference=r"Devices/{alarmingDeviceId}/Alarms/{alarm}")
def handle_device_alarm(event: db_fn.Event[db_fn.Change]) -> None:
    alarm = event.params['alarm']
    if "warn" in alarm or "ign" in alarm:
        return
    
    alarmActive = event.data.after
    alarmingDeviceId = event.params["alarmingDeviceId"]
    
    deviceInfoRef = db.reference(f"Devices/{alarmingDeviceId}/Info")
    deviceInfo = deviceInfoRef.get()
    if not db_entry_exists(deviceInfo):
        print("No Device Info found")
        return
    
    log_device_alarm(alarmingDeviceId, alarm, alarmActive)
    
    if alarmActive:
        title = "System Alarm!"
        alarmText = alarm.capitalize()
    else:
        title = "Alarm Cleared!"
        alarmText = f'{alarm.capitalize()} cleared'

    body = f"{alarmText.replace("_", " ")} on device '{alarmingDeviceId}'!"
    args = {'click_action': "FLUTTER_NOTIFICATION_CLICK", 'alarm': alarm, 'deviceId': alarmingDeviceId, 'active': str(alarmActive)}

    all_tokens = []
    watcherIds = get_watcherIds_from_device(alarmingDeviceId)
    for id in watcherIds:
        user_entry = get_user_entry(id)
        print(f"DEBUG -> Got user_entry = {user_entry}")
        send_tokens = [t for t in user_entry.notification_tokens if t not in all_tokens]
        all_tokens += send_tokens
        try:
            send_push_notification(id, send_tokens, title, body, args)
        except Exception as e:
            print(f"Error: ({e}) when trying to send push notification.")
        try:
            send_alarm_email_if_enabled(user_entry, args, deviceInfo.get("name"))
        except Exception as e:
            print(f"Error: ({e}) when trying to send alarm alert email.")

def convert_alarm(alarm):
    if "flow" in alarm:
        return "Flow alarm"
    if "pressure" in alarm:
        return "Pressure alarm"
    if "temp" in alarm:
        return "Temperature alarm"
    if "overload" in alarm:
        return "Overload alarm"
    if "freq" in alarm:
        return "Frequency lock alarm"
    
def send_alarm_email_if_enabled(user_entry: UserEntry, args, deviceName):
    if (not user_entry.email_on_alarm):
        return f"Email alert on alarm not enabled for {user_entry.name}"
    if (not user_entry.email_on_alarm):
        return f"No email on account for {user_entry.name}"
    if (args['active'] == 'False'):
        return f"Alarm cleared, nothing to do"

    sender_email = "cannasolsw@gmail.com"
    sender_password = "yews mfuh mqev pvdf"

    alarmType = convert_alarm(args['alarm'])

    subject = "Cannasol Automation System Alarm Alert!"
    body = f"""Hello, {user_entry.name}. \n\nThis is an automated email alert:
    
        There has been a system alarm on your device.

        Device ID: {args['deviceId']}
        Device Name: {deviceName}
        Alarm Type:  {alarmType}
        """

    # Create the email headers and body
    msg = MIMEMultipart()
    msg['From'] = sender_email
    msg['To'] = user_entry.email
    msg['Subject'] = subject
    msg.attach(MIMEText(body, 'plain'))
    try:
        with smtplib.SMTP_SSL('smtp.gmail.com', 465) as server:
            server.login(sender_email, sender_password)
            server.sendmail(sender_email, user_entry.email, msg.as_string())
    except Exception as e:
        print(f"DEBUG -> Error sending email {e}")
        return f"Error sending email: {e}", 500
    print("DEBUG -> Email sent successfully!!")
    return 'Email sent successfully!', 200

def get_watcherIds_from_device(alarmingDeviceId: str):
    watchers_ref = db.reference(f"Devices/{alarmingDeviceId}/Watchers")
    watcherIds = watchers_ref.get()
    if (not isinstance(watcherIds, dict) or len(watcherIds) < 1):
        return []
    if isinstance(watcherIds, dict):
        return watcherIds.keys()
    return []

def db_entry_exists(entry):
    return (isinstance(entry, dict) and len(entry) >= 1)

def get_user_name(user_db_info):
    return str(user_db_info.get('name'))

def get_email_on_alarm(user_db_info):
    return True if user_db_info.get('email_on_alarm') is True else False

def get_user_email(user_db_info) -> str:
    return str(user_db_info.get('email'))
    
def get_notification_tokens(user_db_info) -> List:   
    notification_tokens = user_db_info.get('notification_tokens')
    return notification_tokens.keys() if isinstance(notification_tokens, dict) else []
    
def get_user_entry(userId):
    user_ref = db.reference(f"users/{userId}")
    user_db_info = user_ref.get()
    if not db_entry_exists(user_db_info):
        print("No user settings found")
        return
    name: str = get_user_name(user_db_info)
    tokens: List = get_notification_tokens(user_db_info)
    email: str = get_user_email(user_db_info)
    email_on_alarm: bool = get_email_on_alarm(user_db_info)
    return UserEntry(userId, name, tokens, email, email_on_alarm)

def send_push_notification(userId: str, tokens: List[str], title: str, body: str, args: dict) -> None:
    if tokens:
        notification = messaging.Notification(title=title, body=body)
        msgs = [messaging.Message(token=tkn, notification=notification, data=args) for tkn in tokens]
        print(f"DEBUG -> Sending Messages: {msgs}")
        if (len(msgs) > 0):
            batch_response: messaging.BatchResponse = messaging.send_each(msgs)
            if batch_response.failure_count < 1:
                return
            remove_stale_tokens(batch_response, userId, msgs)

def remove_stale_tokens(batch_response, userId: str, msgs: List[messaging.Message]):
    # Clean up the tokens that are not registered any more.
    tokens_ref = db.reference(f"users/{userId}/notification_tokens")
    for i in range(len(batch_response.responses)):
        exception = batch_response.responses[i].exception
        print(f"DEBUG -> Exception: {exception}")
        if not isinstance(exception, exceptions.FirebaseError):
            continue
        message = exception.http_response.json()["error"]["message"]
        print(f"DEBUG -> Error message: {message}")
        if (isinstance(exception, messaging.UnregisteredError) or
            message == "The registration token is not a valid FCM registration token"):
            tokens_ref.child(msgs[i].token).delete()
    return


##################################SIMULATION ZONE######################################
@db_fn.on_value_updated(reference=r"Devices/SIMULATION-DEVICE-1/State/{key}")
def handle_simulation_1_state_change(event: db_fn.Event[db_fn.Change]) -> None:
    handle_simulation_state_change("SIMULATION-DEVICE-1", event)
    
@db_fn.on_value_updated(reference=r"Devices/SIMULATION-DEVICE-2/State/{key}")
def handle_simulation_2_state_change(event: db_fn.Event[db_fn.Change]) -> None:
    handle_simulation_state_change("SIMULATION-DEVICE-2", event)
    
@db_fn.on_value_updated(reference=r"Devices/SIMULATION-DEVICE-1/Config/{key}")
def handle_simulation_1_config_change(event: db_fn.Event[db_fn.Change]) -> None:
    handle_simulation_config_change("SIMULATION-DEVICE-1", event)

@db_fn.on_value_updated(reference=r"Devices/SIMULATION-DEVICE-2/Config/{key}")
def handle_simulation_2_config_change(event: db_fn.Event[db_fn.Change]) -> None:
    handle_simulation_config_change("SIMULATION-DEVICE-2", event)
    # HwSimulator.handle_simulation_config_change("SIMULATION-DEVICE-2", event)
    
@db_fn.on_value_updated(reference=r"Devices/SIMULATION-DEVICE-1/Alarms/{key}")
def handle_simulation_1_alarm_change(event: db_fn.Event[db_fn.Change]) -> None:
    handle_simulation_alarms_change("SIMULATION-DEVICE-1", event)
        
@db_fn.on_value_updated(reference=r"Devices/SIMULATION-DEVICE-2/Alarms/{key}")
def handle_simulation_2_alarm_change(event: db_fn.Event[db_fn.Change]) -> None:
    handle_simulation_alarms_change("SIMULATION-DEVICE-2", event)
    
@db_fn.on_value_updated(reference=r"Devices/{deviceId}/History")
def export_device_history(event: db_fn.Event[db_fn.Change]) -> None:
    
    print("DEBUG -> Calling export_device_history")
    # device_id = event.params['deviceId']
    print(f"DEBUG -> INSIDE EXPORT DEVICE HISTORY instance = {event.instance}  reference = {event.reference} location = {event.location}") 
    device_id = event.params['deviceId']

    
    print(f"Export Run History triggered for device {device_id}. Exporting history...")
    
    # Fetch the run history data
    device_ref = db.reference(f'Devices/{device_id}')
    history_ref = device_ref.child(f'History')
    cloud_logging_ref = device_ref.child(f'CloudLogging')

    history_data = history_ref.get()

    cloud_logging_ref.update({
            "export_history": False
        }
    )
    
    if not history_data:
        print(f"No run history data found for device {device_id}.")
        return

    run_logs = []
    for __, entry in history_data.items():
        run_log = {
            'Start Time': entry.get('start_time'),
            'End Time': entry.get('end_time'),
            'Start Operator': entry.get('start_user'),
            'Run Hours': entry.get('run_hours'),
            'Run Minutes': entry.get('run_minutes'),
            'Run Seconds': entry.get('run_seconds'),
            'Average Flow Rate': entry.get('avg_flow_rate'),
            'Average Temp': entry.get('avg_temp'),
            'Number of Passes': entry.get('num_passes'),
        }
        run_log["System Config"] = json.dumps(entry.get('system_config'))
        run_log['Alarm Logs'] = json.dumps(entry.get('alarm_logs', {}))
        run_logs.append(run_log)
    
    if not run_logs:
        print(f"No run logs to export for device {device_id}.")
        return
    
    # Create Excel Workbook and Worksheet
    workbook = Workbook()
    worksheet = workbook.active
    worksheet.title = 'Run Logs'
    
    # Define columns based on the first run log
    columns = list(run_logs[0].keys())
    worksheet.append(columns)
    
    # Write data rows
    for LOG in run_logs:
        row = list(log.values())
        worksheet.append(row)
    
    # Save workbook to a BytesIO stream
    excel_stream = BytesIO()
    workbook.save(excel_stream)
    excel_stream.seek(0)
    # Initialize Cloud Storage client and bucket
    storage_client = storage.Client.from_service_account_json("serviceAccountKey.json")
    bucket = storage_client.bucket('cannasoltech.firebasestorage.app')

    # Define file path    # Define file path in Cloud Storage
    
    timestamp = int(datetime.now(timezone.utc).timestamp())
    file_name = f'RunLogs_{device_id}_{timestamp}.xlsx'
    blob = bucket.blob(f'exports/{device_id}/{file_name}')
    
    # Upload the Excel file to Cloud Storage
    blob.upload_from_file(excel_stream, content_type='application/vnd.openxmlformats-officedocument.spreadsheetml.sheet')
    
    print(f"Excel file uploaded to {blob.public_url}")
    
    # Generate a signed URL valid for 1 hour
    url = blob.generate_signed_url(
        version='v4',
        expiration=timedelta(hours=1),
        method='GET',
        expires=30*24*60*60
    )
    
    # Update the run history with the download URL
    cloud_logging_ref.update({
        "Spreadsheet":  {
            'file_name': file_name,
            'download_url': url,
            'time_stamp': datetime.now(timezone.utc).isoformat()
        }
    })
    print(f"Download URL generated: {url}")
    


# @db_fn.on_value_written(reference=r"Devices/{deviceId}/History/{systemRunId}")
# def export_device_history(event: db_fn.Event[db_fn.Change]) -> None:
#     # Get the new message data
    
#     device_id = event.params['deviceId']
#     system_run_id = event.params['systemRunId'] 
    
#     message = event.data.val()
#     user_input = message.get('text', '')
    
#     system_run_log_ref = db.reference(f"Devices/{event.params['deviceId']}/History/{event.params['systemRunId']}")

#     # Generate AI response
#     system_run_summary = analyze_system_run(system_run_log_ref.get())
    
#     system_run_log_ref.update({
#         'genai_summary' : system_run_summary
#     })
