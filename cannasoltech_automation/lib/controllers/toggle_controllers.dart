class ToggleController {
  bool value;
  ToggleController({required this.value});
  void toggle() {
    value = !value; 
  }
}

class ToggleControllers {
  ToggleController enableCooldown = ToggleController(value: false);
  ToggleController ignTempAlarm = ToggleController(value: false);
  ToggleController ignFlowAlarm = ToggleController(value: false);
  ToggleController ignPressureAlarm = ToggleController(value: false);
  ToggleController ignFreqLockAlarm = ToggleController(value: false);
  ToggleController ignOverloadAlarm = ToggleController(value: false);
  ToggleController pumpControl = ToggleController(value: false);

  // bool enableCooldown = false;
  bool offline = false;

  void init(dynamic newDeviceData){
    dynamic config = newDeviceData.config;
    dynamic alarm = newDeviceData.alarms;
    enableCooldown.value = config.enableCooldown;
    ignTempAlarm.value = alarm.ignoreTempAlarm;
    ignFlowAlarm.value = alarm.ignoreFlowAlarm;
    ignPressureAlarm.value = alarm.ignorePressureAlarm;
    ignFreqLockAlarm.value = alarm.ignoreFreqLockAlarm;
    ignOverloadAlarm.value = alarm.ignoreOverloadAlarm;
    pumpControl.value = config.pumpControl;
  }

 void dispose() {
    ignTempAlarm.value = false;
    ignFlowAlarm.value = false;
    ignPressureAlarm.value = false;
    ignFreqLockAlarm.value = false;
    ignOverloadAlarm.value = false;
    pumpControl.value = false;
  }

  void clear() {
    enableCooldown.value = false;
    ignTempAlarm.value = false;
    ignFlowAlarm.value = false;
    ignPressureAlarm.value = false;
    ignFreqLockAlarm.value = false;
    ignOverloadAlarm.value = false;
    pumpControl.value = false;
  }

  void update(dynamic newDeviceData, dynamic activeDevice){
    dynamic activeConfig = activeDevice.config;
    dynamic newConfig = newDeviceData.config;
    dynamic activeAlarms = activeDevice.alarms;
    dynamic newAlarms = newDeviceData.alarms;

    if (newDeviceData != null && activeDevice != null){
      if (newConfig.enableCooldown != activeConfig.enableCooldown){
        enableCooldown.value = newConfig.enableCooldown;     
      }

      if (newAlarms.ignoreFlowAlarm != activeAlarms.ignoreFlowAlarm){
        ignFlowAlarm.value = newAlarms.ignoreFlowAlarm;     
      }

      if (newAlarms.ignoreFreqLockAlarm != activeAlarms.ignoreFreqLockAlarm){
        ignFreqLockAlarm.value = newAlarms.ignoreFreqLockAlarm;     
      }

      if (newAlarms.ignoreOverloadAlarm != activeAlarms.ignoreOverloadAlarm){
        ignOverloadAlarm.value = newAlarms.ignoreOverloadAlarm;     
      }

      if (newAlarms.ignorePressureAlarm != activeAlarms.ignorePressureAlarm){
        ignPressureAlarm.value = newAlarms.ignorePressureAlarm;     
      }

      if (newAlarms.ignoreTempAlarm != activeAlarms.ignoreTempAlarm){
        ignTempAlarm.value = newAlarms.ignoreTempAlarm;     
      }

      if (newConfig.pumpControl != activeConfig.pumpControl){
        pumpControl.value = newConfig.pumpControl;     
      }
    }
  }
}
