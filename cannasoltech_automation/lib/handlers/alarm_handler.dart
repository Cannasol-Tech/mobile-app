
/**
 * @file alarm_handler.dart
 * @author Stephen Boyett
 * @date 2025-09-06
 * @brief Alarm management and handling system for device monitoring.
 * @details Provides comprehensive alarm management including ignored alarms,
 *          warnings, active alarms, and alarm state tracking with Firebase integration.
 * @version 1.0
 * @since 1.0
 */

import 'package:firebase_database/firebase_database.dart';
import '../data_models/device.dart';
import '../data_models/property.dart';
import '../objects/database_model.dart';
import '../objects/logger.dart';
import '../shared/methods.dart';
import '../shared/types.dart';

/**
 * @brief Model for managing ignored alarm states.
 * @details Tracks which alarm types are currently being ignored for a device,
 *          allowing selective alarm suppression while maintaining monitoring.
 * @since 1.0
 */
class IgnoredAlarmsModel {

  /// Flow alarm ignore status
  bool flow;

  /// Temperature alarm ignore status
  bool temp;

  /// Pressure alarm ignore status
  bool pressure;

  /// Frequency lock alarm ignore status
  bool freqLock;

  /// Overload alarm ignore status
  bool overload;

  /// Nested ignored alarms model for complex alarm hierarchies
  IgnoredAlarmsModel ignored;

  /// Raw native data from database
  Map<String, dynamic> native;

  /**
   * @brief Creates an IgnoredAlarmsModel with specified alarm ignore states.
   * @param flow Flow alarm ignore status
   * @param temp Temperature alarm ignore status
   * @param pressure Pressure alarm ignore status
   * @param freqLock Frequency lock alarm ignore status
   * @param overload Overload alarm ignore status
   * @param ignored Nested ignored alarms model
   * @param native Raw database data
   */
  IgnoredAlarmsModel({
    required this.flow,
    required this.temp,
    required this.pressure,
    required this.freqLock,
    required this.overload,
    required this.ignored,
    required this.native,
  });

  /**
   * @brief Factory constructor to create IgnoredAlarmsModel from database data.
   * @details Parses database map to create an IgnoredAlarmsModel instance with
   *          all alarm ignore states properly initialized.
   * @param data Database map containing alarm ignore states
   * @return IgnoredAlarmsModel instance populated from database
   * @since 1.0
   */
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

/**
 * @brief Model for managing device warning states.
 * @details Tracks warning conditions for flow, pressure, and temperature
 *          sensors, providing early indication of potential issues.
 * @since 1.0
 */
class WarningsModel {
  /// Flow warning status
  bool flow;

  /// Pressure warning status
  bool pressure;

  /// Temperature warning status
  bool temp;

  /// Raw native data from database
  Map<String, dynamic> native;

  /**
   * @brief Creates a WarningsModel with specified warning states.
   * @param flow Flow warning status
   * @param pressure Pressure warning status
   * @param temp Temperature warning status
   * @param native Raw database data
   */
  WarningsModel({
    required this.flow,
    required this.pressure,
    required this.temp,
    required this.native
  });

  /**
   * @brief Factory constructor to create WarningsModel from database data.
   * @details Parses database map to create a WarningsModel instance with
   *          all warning states properly initialized.
   * @param data Database map containing warning states
   * @return WarningsModel instance populated from database
   * @since 1.0
   */
  factory WarningsModel.fromDatabase(Map<String, dynamic> data) {
    return WarningsModel(
      flow: data['flow'] as bool,
      pressure:  data['flow'] as bool,
      temp: data['temp'] as bool,
      native: data,
    );
  }
}

/**
 * @brief Main alarm management model for device monitoring.
 * @details Extends DatabaseModel to provide comprehensive alarm management
 *          including active alarms, ignored alarms, warnings, and alarm state tracking.
 * @since 1.0
 */
class AlarmsModel extends DatabaseModel {
  /**
   * @brief Creates an AlarmsModel instance.
   * @param device Associated device for alarm monitoring
   */
  AlarmsModel({ this.device }){
    device ?? Device.noDevice();
  }

  /// Associated device for alarm monitoring
  Device? device;

  /// List of alarm property names for monitoring
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