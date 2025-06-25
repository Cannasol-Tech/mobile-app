import multiprocessing.process
from flask import Flask, jsonify, request
import threading
import time
import firebase_admin
from firebase_admin import credentials, db
import queue
import multiprocessing

app = Flask(__name__)


# ----------------------------------------------------------------------------
# 1. Initialize Firebase Admin SDK
# ----------------------------------------------------------------------------
SERVICE_ACCOUNT_PATH = "serviceAccountKey.json"
REALTIME_DATABASE_URL = "https://cannasoltech-default-rtdb.firebaseio.com/"

cred = credentials.Certificate(SERVICE_ACCOUNT_PATH)
firebase_admin.initialize_app(cred, {
    "databaseURL": REALTIME_DATABASE_URL
})


class SimulationDevice():
    def __init__(self, device_id):
        self.running = False
        self.elapsed_time = 0
        self.device_id = device_id
        self.queue = queue.Queue()
        self.stop_timer_event = threading.Event()
        self.stop_writer_event = threading.Event()
        self.device_ref = db.reference(f"Devices/{self.device_id}/State")
        self.config_ref = db.reference(f"Devices/{self.device_id}/Config")

    def start_timer(self):
        if not self.running:
            timer_updater = threading.Thread(target=self._timer_updater, daemon=True, args=(self.stop_timer_event, ))
            db_writer = threading.Thread(target=self._database_writer, daemon=True, args=(self.stop_writer_event, ))
            timer_updater.start()
            db_writer.start()
            self.running = True
        else:
            print(f"(INFO) -> Timer for {self.device_id} is already running.")

    def stop_timer(self):
        if self.running:
            self.stop_timer_event.set()
            self.stop_writer_event.set()
            self.running = False
        else:
            print(f"(INFO) -> Timer for {self.device_id} is already stopped.")
            
    def reset_timer(self):
        self.elapsed_time = 0
        self.device_ref.update({"run_hours": 0, "run_minutes": 0, "run_seconds": 0})
        print(f"(INFO) -> Timer for {self.device_id} has been reset.")
        
    def update_set_time(self):
        self.stop_timer_event.set()
        self.stop_writer_event.set()
        time.sleep(2)
        self.start_timer()

    def _timer_updater(self, stop_event):
        while not stop_event.is_set():
            time.sleep(1)  # Wait for 1 second
            self.elapsed_time += 1
            if self.queue.empty():
                try:
                    self.queue.put({"update": True}, block=False)
                except Exception as e:
                    print(f"Error updating db_queue for {self.device_id}: {e}")
        stop_event.clear()
        self.running = False
                
    def _database_writer(self, stop_event):
        while not stop_event.is_set():
            self.queue.get()  # Block until an item is available
            db_update_dict = {
                "run_hours": (self.elapsed_time//3600),
                "run_minutes": (self.elapsed_time//60 % 60),
                "run_seconds": (self.elapsed_time % 60)
            }
            try:
                self.device_ref.update(db_update_dict)
            except Exception as e:
                print(f"Error updating Firebase for {self.device_id}: {db_update_dict} -- {e}")
            self.queue.task_done()
        while not self.queue.empty():
            self.queue.get()
            self.queue.task_done()
        stop_event.clear()
        
sim_devices = {
    "SIMULATION-DEVICE-1" : SimulationDevice("SIMULATION-DEVICE-1"),
    "SIMULATION-DEVICE-2" : SimulationDevice("SIMULATION-DEVICE-2")
}

@app.route('/api/timer/start', methods=['POST'])
def start_timer():
    """
    POST /api/timer/start
    JSON body: {"device-id": "some_device_id"}
    
    Starts the timer for the specified device.
    """
    data = request.get_json()
    if not data or "device-id" not in data:
        return jsonify({"error": "Missing 'device-id' in JSON body"}), 400
    
    device_id = data["device-id"]
    
    print("DEBUG -> device_id = {device_id}")
    print("DEBUG -> sim_devices = {sim_devices}")
    
    simulation_device = sim_devices.get(device_id)
    
    print("DEBUG -> simulation_device = {simulation_device}")
    
    if simulation_device is not None:
        print("DEBUG -> sim device is not None")
        simulation_device.start_timer()
    
    return jsonify({
        "message": f"Timer started for {device_id}",
        "data": simulation_device.elapsed_time
    }), 200

@app.route('/api/timer/stop', methods=['POST'])
def stop_timer():
    """
    POST /api/timer/stop
    JSON body: {"device-id": "some_device_id"}
    
    Stops the timer for the specified device.
    """
    data = request.get_json()
    if not data or "device-id" not in data:
        return jsonify({"error": "Missing 'device-id' in JSON body"}), 400

    device_id = data["device-id"]

    simulation_device = sim_devices.get(device_id)
    
    if simulation_device is not None:
        simulation_device.stop_timer()
    
    return jsonify({
        "message": f"Timer stopped for {device_id}",
        "data": simulation_device.elapsed_time
    }), 200

@app.route('/api/timer/reset', methods=['POST'])
def reset_timer():
    """
    POST /api/timer/reset
    JSON body: {"device-id": "some_device_id"}
    
    Resets the timer for the specified device to 0 (does not change running state).
    Also resets the Realtime Database field to 0.
    """
    data = request.get_json()
    if not data or "device-id" not in data:
        return jsonify({"error": "Missing 'device-id' in JSON body"}), 400

    device_id = data["device-id"]

    simulation_device = sim_devices.get(device_id)
    
    if simulation_device is not None:
        simulation_device.reset_timer()

    return jsonify({
        "message": f"Timer reset for {device_id}",
        "data": simulation_device.elapsed_time
    }), 200


# ----------------------------------------------------------------------------
# 6. Run the Flask App Locally
# ----------------------------------------------------------------------------
if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080, debug=True)
