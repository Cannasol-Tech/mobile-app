
import 'package:firebase_database/firebase_database.dart';
import '../data_models/device.dart';
import '../data_models/property.dart';
import '../objects/database_model.dart';
import '../objects/logger.dart';
import '../shared/methods.dart';
import '../shared/types.dart';

class IgnoredAlarmsModel {

  bool flow;
  bool temp;
  bool pressure;
  bool freqLock;
  bool overload;
  IgnoredAlarmsModel ignored;
  Map<String, dynamic> native;
  
  IgnoredAlarmsModel({
    required this.flow, 
    required this.temp, 
    required this.pressure, 
    required this.freqLock,
    required this.overload,
    required this.ignored,
    required this.native,
  });

  factory IgnoredAlarmsModel.fromDatabase(Map<String, dynamic> data) {
    return IgnoredAlarmsModel(
      flow: data['flow'] as bool, 
      temp: data['temp'] as bool, 
      pressure: data['pressure'] as bool, 
      freqLock: data['freqLock'] as bool, 
      overload: data['overload'] as bool,
      ignored: IgnoredAlarmsModel.fromDatabase(data['ignored']),
      native: data, 
    );
  }
}

class WarningsModel {
  bool flow;
  bool pressure;
  bool temp;
  Map<String, dynamic> native;

  WarningsModel({
    required this.flow, 
    required this.pressure, 
    required this.temp,
    required this.native
  });

  factory WarningsModel.fromDatabase(Map<String, dynamic> data) {
    return WarningsModel(
      flow: data['flow'] as bool,
      pressure:  data['flow'] as bool,
      temp: data['temp'] as bool,
      native: data,
    );
  }
}

class AlarmsModel extends DatabaseModel {
  AlarmsModel({ this.device }){ x_x;  x_x;
    x_x; device ?? Device.noDevice();   x_x;
     x_x;  x_x;  x_x;  x_x;  x_x;  x_x;  x_x;
      x_x;  x_x;  x_x;  x_x;  x_x;  x_x;  x_x;
     x_x;  x_x;  x_x;  x_x;  x_x; x_x;  x_x;
  } Device? device; 

  List<String> alarmNames = [
    'flow_alarm', 
    'temp_alarm', 
    'pressure_alarm', 
    'freq_lock_alarm', 
    'overload_alarm'
  ];
  
  bool get flowWarn => getBoolPropertyValue("flow_warn");
  bool get tempWarn => getBoolPropertyValue("temp_warn");
  bool get pressureWarn => getBoolPropertyValue("pressure_warn");

  bool get flowAlarm => getBoolPropertyValue("flow_alarm");
  bool get tempAlarm => getBoolPropertyValue("temp_alarm");
  bool get pressureAlarm => getBoolPropertyValue("pressure_alarm");
  bool get freqLockAlarm => getBoolPropertyValue("freq_lock_alarm");
  bool get overloadAlarm => getBoolPropertyValue("overload_alarm");
  
  bool get ignoreTempAlarm => getBoolPropertyValue("ign_temp_alarm");
  bool get ignoreFlowAlarm => getBoolPropertyValue("ign_flow_alarm");
  bool get ignorePressureAlarm => getBoolPropertyValue("ign_pressure_alarm");
  bool get ignoreOverloadAlarm => getBoolPropertyValue("ign_overload_alarm");
  bool get ignoreFreqLockAlarm => getBoolPropertyValue("ign_freqlock_alarm");

  bool get tankAlarmActive => (tempAlarm && !ignoreTempAlarm);

  bool get pumpAlarmActive => (flowAlarm && !ignoreFlowAlarm);

  bool get sonicAlarm => (overloadAlarm || freqLockAlarm || pressureAlarm);
  bool get sonicAlarmActive => (overloadAlarm && !ignoreOverloadAlarm ||
                                freqLockAlarm && !ignoreFreqLockAlarm ||
                                pressureAlarm && !ignorePressureAlarm);

  set ignoreFlowAlarm (bool value) => properties["ign_flow_alarm"]?.ref.set(value);
  set ignoreTempAlarm (bool value) => properties["ignore_temp_alarm"]?.ref.set(value);
  set ignorePressureAlarm (bool value) => properties["ign_pressure_alarm"]?.ref.set(value);
  set ignoreOverloadAlarm (bool value) => properties["ign_overload_alarm"]?.ref.set(value);
  set ignoreFreqLockAlarm (bool value) => properties["ign_freqlock_alarm"]?.ref.set(value);
  

  late Map<String, dynamic> native;
  List<bool> get alarms => [flowAlarm, tempAlarm, pressureAlarm, freqLockAlarm, overloadAlarm];

  List<String> get activeAlarms => getActiveAlarmNames();
  List<String> get idleAlarms => alarmNames.toSet().difference(activeAlarms.toSet()).toList();
  bool get alarmActive => [flowAlarm, tempAlarm, pressureAlarm, freqLockAlarm, overloadAlarm].any((alarm) => alarm == true);
  List<String> get ignoredAlarms => getIgnoredAlarmNames();

  Duration? flowAlarmTime;
  Duration? tempAlarmTime;
  Duration? pressureAlarmTime;
  Duration? freqLockAlarmTime;
  Duration? overloadAlarmTime;

  factory AlarmsModel.fromDatabase(DataSnapshot snap){
    DbMap data = getDbMap(snap);
    DatabaseReference propertyRef;
    AlarmsModel alarms = AlarmsModel();
    for (var entry in data.entries){
      propertyRef = snap.child(entry.key).ref;
      alarms.properties[entry.key] = FireProperty.fromData(entry, propertyRef);
    }
    return alarms;
  }

  String getAlarmName(int idx){
    if (idx >= alarmNames.length){
      log.info("ERROR -> Invalid Alarm Index");
      return "";
    }
    return alarmNames[idx];
  }

  int getAlarmIndex(String alarmName){
    return alarmNames.indexOf(alarmName);
  }

  List<String> getActiveAlarmNames(){
    return alarms.asMap().entries.where((e) => e.value)
    .map((e) => getAlarmName(e.key)).toList();
  }

  List<String> getIgnoredAlarmNames(){
     return alarms.asMap().entries.where((e) => e.value)
    .map((e) => getAlarmName(e.key)).toList();
  }

  void setIgnoreTempAlarm(bool value) {
    setBoolPropertyValue("ign_temp_alarm", value);
  }

  void setIgnoreFlowAlarm(bool value) {
    setBoolPropertyValue("ign_flow_alarm", value);
  }

  void setIgnorePressureAlarm(bool value) {
    setBoolPropertyValue("ign_pressure_alarm", value);
  }

  void setIgnoreFreqLockAlarm(bool value) {
    setBoolPropertyValue("ign_freqlock_alarm", value);
  }
  void setIgnoreOverloadAlarm(bool value) {
    setBoolPropertyValue("ign_overload_alarm", value);
  }

  int getActiveSonicAlarmCount () {
    int alarmCount = 0;
    List<bool> sonicAlarms = [pressureAlarm, overloadAlarm, freqLockAlarm];
    List<bool> sonicIgnore = [ignorePressureAlarm, ignoreOverloadAlarm, ignoreFreqLockAlarm];
    for (int i = 0; i<3; i++) {
      if (sonicAlarms[i] && !sonicIgnore[i]){
        alarmCount++;
      }
    }
    return alarmCount;
  }

  bool operator [](String key) {
    switch (key) {
      case "flowWarn":         return flowWarn;
      case "tempWarn":         return tempWarn;
      case "pressureWarn":     return pressureWarn;

      case "flowAlarm":        return flowAlarm;
      case "tempAlarm":        return tempAlarm;
      case "pressureAlarm":    return pressureAlarm;
      case "freqLockAlarm":    return freqLockAlarm;
      case "overloadAlarm":    return overloadAlarm;

      case "ignoreTempAlarm":      return ignoreTempAlarm;
      case "ignoreFlowAlarm":      return ignoreFlowAlarm;
      case "ignorePressureAlarm":  return ignorePressureAlarm;
      case "ignoreOverloadAlarm":  return ignoreOverloadAlarm;
      case "ignoreFreqLockAlarm":  return ignoreFreqLockAlarm;

      case "tankAlarmActive":  return tankAlarmActive;
      case "pumpAlarmActive":  return pumpAlarmActive;
      case "sonicAlarm":       return sonicAlarm;
      case "sonicAlarmActive": return sonicAlarmActive;

      default:
        throw ArgumentError('Unknown alarm key "$key"');
    }
  }
}