from constants import *
# from functions.constants import *
import time
from firebase_admin import db
import random
from device_timers import *
# from functions.device_timers import *

def start_simulation(device_ref):
    status = device_ref.child("Simulation").child("status").get()
    if status is None:
        device_ref.child("Simulation").update({"status": "stopped"})
    if device_ref.child("Simulation").child("status").get() == "running":
        deviceName = device_ref.child("Info").child("name").get()
        return
    init_device(device_ref)
    set_simulation_state(device_ref, WARMING_STATE)
    device_ref.child("Simulation").update({"status": "running"})
    while True:
        simulation_state = get_simulation_state(device_ref)
        run_seconds = get_run_time_seconds(device_ref)
        state = device_ref.child("State").get()
        # UPDATE TEMPERATURE IF WARMING UP
        if simulation_state is not None:
            if simulation_state == WARMING_STATE or simulation_state == RUN_STATE:                
                if state.get("avg_flow_rate") is not None and state.get("avg_temp") is not None:
                    if run_seconds != 0:
                        avgFlow = (state.get('avg_flow_rate') * (run_seconds-1) + state.get('flow')) / run_seconds
                        avgTemp = (state.get('avg_temp') * (run_seconds-1) + state.get('temperature')) / run_seconds
                        numPasses = float((run_seconds / 60) / float(device_ref.child("Config").child("batch_size").get()))
                    else:
                        avgFlow = 0
                        avgTemp = 0
                        numPasses = 0
                device_ref.child("State").update({"avg_flow_rate": avgFlow, "avg_temp": avgTemp, "num_passes": numPasses})
            if simulation_state == INIT_STATE or simulation_state == END_STATE:
                device_ref.child("Simulation").child("status").set("stopped")
                return
        simulate_sensor_data(device_ref)
        time.sleep(2)
            
def warm_up(device_ref):
    state = get_simulation_state(device_ref)
    if state == ALARM_STATE:
        return
    set_temp = device_ref.child("Config").child("set_temp").get()
    current_temp = device_ref.child("State").child("temperature").get()
    while current_temp < set_temp:
        device_ref.child("State").child("temperature").set(current_temp + random.uniform(0.7, 1.2))
        time.sleep(random.uniform(0.4, 1.0))
        set_temp = device_ref.child("Config").child("set_temp").get()
        current_temp = device_ref.child("State").child("temperature").get()
    set_simulation_state(device_ref, RUN_STATE)

def cool_down(device_ref):
    cool_down_temp = device_ref.child("Config").child("cool_down_temp").get()
    current_temp = device_ref.child("State").child("temperature").get()
    while current_temp > cool_down_temp:
        if get_simulation_state(device_ref) == COOL_STATE:
            current_temp = device_ref.child("State").child("temperature").get()
            device_ref.child("State").child("temperature").set(current_temp - random.uniform(0.4, 0.7))
            time.sleep(0.7)
        else:
            return
    if get_simulation_state(device_ref) == COOL_STATE:
        set_simulation_state(device_ref, END_STATE)

def simulate_sensor_data(device_ref):
    pressure_thresh = device_ref.child("Config").child("pressure_thresh").get()
    flow_thresh = device_ref.child("Config").child("flow_thresh").get()
    state = get_simulation_state(device_ref)
    if state == WARMING_STATE or state == RUN_STATE or state == ALARM_STATE or state == COOL_STATE:
        device_ref.child("State").update({
                "pressure": random.uniform(pressure_thresh, pressure_thresh + 5.0),
                "flow": random.uniform(flow_thresh, flow_thresh + 5.0),
            })
        if state == RUN_STATE or state == ALARM_STATE:
            set_temp  = device_ref.child("Config").child("set_temp").get() + random.uniform(-0.5, 0.5)
            current_temp = device_ref.child("State").child("temperature").get()
            if (current_temp > set_temp - 1): 
                device_ref.child("State").child("temperature").set(set_temp)

def set_system_warning(device_ref, warning):
    if warning is not None:
        device_ref.child("Alarms").update({f"{warning}_warn": True})
    else:
        device_ref.child("Alarms").update({
            "flow_warn": False,
            "temp_warn": False,
            "pressure_warn": False
        })

def set_system_alarm(device_ref, alarm):
    if alarm is not None:
        device_ref.child("Alarms").update({f"{alarm}_alarm": True})
        device_ref.child("State").update({"alarms_cleared": False})
    else:
        device_ref.child("Alarms").update({
            "flow_alarm": False,
            "temp_alarm": False,
            "pressure_alarm": False,
            "freq_lock_alarm": False,
            "overload_alarm": False,
        })
        device_ref.child("State").update({"alarms_cleared": True})

def simulate_system_warnings(device_ref):
    sim_ref = device_ref.child("Simulation")
    for warning in ["flow", None, "pressure", None, "temp", None]:
        if device_ref.child("State").child("state").get() in [INIT_STATE, COOL_STATE, END_STATE]:
            set_system_warning(device_ref, None)
            return
        set_system_warning(device_ref, warning)
        time.sleep(7)

def simulate_system_alarms(device_ref):
    sim_ref = device_ref.child("Simulation")
    alarms = ["flow", None, "pressure", None, "temp", None, "freq_lock", None, "overload", None]
    for alarm in alarms:
        if device_ref.child("State").child("state").get() in [INIT_STATE, COOL_STATE, END_STATE]:
            set_system_alarm(device_ref, None)
            return
        set_system_alarm(device_ref, alarm)
        time.sleep(10)
 
def end_simulation(device_ref):
    if device_ref.child('Config').child('enable_cooldown').get():
        set_simulation_state(device_ref, COOL_STATE)
    else:
        set_simulation_state(device_ref, END_STATE)

def get_run_time_seconds(device_ref):
    run_seconds = 0
    state = device_ref.child("State").get()
    if state is not None:
        run_seconds = state["run_hours"] * 3600 + state["run_minutes"] * 60 + state["run_seconds"]
    return run_seconds

def get_set_time_seconds(device_ref):
    config = device_ref.child("Config").get()
    if config is not None:
        set_hours = config.get("set_hours") if config.get("set_hours") is not None else 0
        set_minutes = config.get("set_minutes") if config.get("set_minutes") is not None else 0
        return (set_hours * 3600 + set_minutes * 60)
    return 0

def set_simulation_state(device_ref, state):
    while get_simulation_state(device_ref) != state:
        device_ref.child('State').update({
            'state': state
        })

def get_simulation_state(device_ref):
    state = device_ref.child("State").child("state").get()
    return state

def simulate_load_config(device_ref, load_slot):
    load_cfg = device_ref.child('SaveSlots').child(f"slot_{load_slot}").get()
    device_ref.child('Config').update({
        'batch_size': load_cfg.get("batch_size", 0),
        'cool_down_temp': load_cfg.get("cool_down_temp", 0),
        'enable_cooldown': load_cfg.get("enable_cooldown", False),
        'flow_thresh': load_cfg.get("min_flow", 0),
        'pressure_thresh': load_cfg.get("min_pressure", 0),
        'set_hours': load_cfg.get("hours", 0),
        'set_minutes': load_cfg.get("minutes", 0),
        'set_temp': load_cfg.get("set_temp", 0),
        'temp_thresh': load_cfg.get("temp_var", 0)
    })
    device_ref.child('Config').update({
        'load_slot': 0
    })

def simulate_save_config(device_ref, save_slot):
    save_cfg = device_ref.child('Config').get()
    device_ref.child('SaveSlots').child(f'slot_{save_slot}').update({
        'batch_size': save_cfg.get("batch_size", 0),
        'cool_down_temp': save_cfg.get("cool_down_temp", 0),
        'enable_cooldown': save_cfg.get("enable_cooldown", False),
        'min_flow': save_cfg.get("flow_thresh", 0),
        'min_pressure': save_cfg.get("pressure_thresh", 0),
        'hours': save_cfg.get("set_hours", 0),
        'minutes': save_cfg.get("set_minutes", 0),
        'set_temp': save_cfg.get("set_temp", 0),
        'temp_var': save_cfg.get("temp_thresh", 0)
    })
    device_ref.child('Config').update({
        'save_slot': 0
    })

def alarms_cleared(alarms_ref):
    alarms = alarms_ref.get()
    if alarms.get("flow_alarm") and not alarms.get("ign_flow_alarm"):
        return False
    if alarms.get("temp_alarm") and not alarms.get("ign_temp_alarm"):
        return False
    if alarms.get("pressure") and not alarms.get("ign_pressure_alarm"):
        return False
    if alarms.get("overload_alarm") and not alarms.get("ign_overload_alarm"):
        return False
    if alarms.get("freq_lock_alarm") and not alarms.get("ign_freqlock_alarm"):
        return False
    return True

def handle_simulation_alarms_change(device_id, event) -> None:
    alarms_ref = db.reference(f'Devices/{device_id}/Alarms')
    if alarms_cleared(alarms_ref):
        device_ref = db.reference(f'Devices/{device_id}')
        device_ref.child("State").child("alarms_cleared").set(True)
    else:
        device_ref = db.reference(f'Devices/{device_id}')
        set_simulation_state(device_ref, ALARM_STATE)
        device_ref.child("State").child("alarms_cleared").set(False)
        
def handle_simulation_config_change(device_id, event) -> None:
    key = event.params['key']
    if "SIMULATION" in device_id:
        device_ref = db.reference(f'Devices/{device_id}')
        if key in ["set_hours", "set_minutes", "pump_control", "batch_size"]:
            set_temp = device_ref.child("Config").child("set_temp").get()
            set_hours = device_ref.child("Config").child("set_hours").get() or 0
            set_minutes = device_ref.child("Config").child("set_minutes").get() or 0
            pump_control = device_ref.child("Config").child("pump_control").get()
            batch_size = device_ref.child("Config").child("batch_size").get() or 0
            params_valid = (set_hours * 3600 + set_minutes * 60 > 0 and
                            batch_size > 0 and set_temp >= 20 and pump_control)
            device_ref.child("State").update({
                "params_valid": params_valid
            })

        if key == "start":
            if event.data.after and not event.data.before:
                device_ref.child("Config").update({"start": False})
                start_simulation(device_ref)

        if key == "end_run":
            if event.data.after and not event.data.before:
                device_ref.child("Config").child("end_run").set(False)
                end_simulation(device_ref)

        if key == "load_slot":
            if 0 < event.data.after <= 5 and event.data.before == 0:
                device_ref.child("Config").child("load_slot").set(0)
                simulate_load_config(device_ref, event.data.after)

        if key == "save_slot":
            if 0 < event.data.after <= 5 and event.data.before == 0:
                device_ref.child("Config").child("save_slot").set(0)
                simulate_save_config(device_ref, event.data.after)
                
        if key == "resume": 
            if 0 < event.data.after and not event.data.before:
                device_ref.child("Config").child("resume").set(False)
                set_simulation_state(device_ref, RUN_STATE)

        if key == "abort_run":
            if event.data.after and not event.data.before:
                init_device(device_ref)
                device_ref.child("Config").child("abort_run").set(False)
                set_simulation_state(device_ref, INIT_STATE)


def check_for_warmup(device_ref, event):
    temperature = device_ref.child("State").child("temperature").get()
    set_temp = event.data.after
    if temperature is not None:
        if set_temp > temperature:
            set_simulation_state(device_ref, WARMING_STATE)        
    

def init_device(device_ref):
    device_ref.child("Simulation").update({
        "status": "stopped"
    })

    device_ref.child("Alarms").update({
        "flow_alarm": False,
        "flow_warn": False,
        "freq_lock_alarm": False,
        "ign_flow_alarm": False,
        "ign_freqlock_alarm": False,
        "ign_overload_alarm": False,
        "ign_pressure_alarm": False,
        "ign_temp_alarm": False,
        "overload_alarm": False,
        "pressure_alarm": False,
        "pressure_warn": False,
        "temp_alarm": False,
        "temp_warn": False
    })
    device_ref.child("Config").update({
        "start": False,
        "abort_run": False,
        "end_run": False,
        "load_slot": 0,
        "restart": False,
        "resume": False,
        "start": False,
    })
    device_ref.child("State").update({
        "avg_flow_rate": 0,
        "avg_temp": 0,
        "flow": 0,
        "freq_lock": False,
        "num_passes": 0,
        "params_valid": True,
        "pressure": 0,
        "pump_status": False,
        "run_hours": 0,
        "run_minutes": 0,
        "run_seconds": 0,
        "state": 0,
        "temperature": 0,
        "warming_up": False
    })

def handle_simulation_state_change(device_id, event):
    key = event.params['key']
    device_ref = db.reference(f'Devices/{device_id}')
    if key == "state":
        if event.data.after == INIT_STATE:
            init_device(device_ref)
            stop_run_timer(device_id)
            time.sleep(3)
            reset_run_timer(device_id)
            init_device(device_ref)
        if event.data.after in [WARMING_STATE, RUN_STATE]:
            start_run_timer(device_id)
            if event.data.after == WARMING_STATE:
                warm_up(device_ref)
            if event.data.after == RUN_STATE:
                check_for_warmup(device_ref, event)
        if event.data.after in [ALARM_STATE, COOL_STATE, END_STATE]:
            stop_run_timer(device_id)
            if event.data.after == COOL_STATE:
                cool_down(device_ref)
            if event.data.after == END_STATE:
                device_ref.child("Simulation").update({"status": "stopped"})
            
    elif key == "set_temp":
        check_for_warmup(device_ref, event)

    elif key == "run_minutes":
        set_seconds = get_set_time_seconds(device_ref)
        run_seconds = get_run_time_seconds(device_ref)
        if run_seconds > 0 and run_seconds < set_seconds - 60:
            if event.data.after  == 1:
                simulate_system_warnings(device_ref)
            elif event.data.after == 2:
                simulate_system_alarms(device_ref)
        if run_seconds >= set_seconds:
            stop_run_timer(device_id)
            device_ref.child("State").child("run_minutes").set(set_seconds//60)
            end_simulation(device_ref)
