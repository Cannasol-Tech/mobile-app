/**
 * @file state_handler.dart
 * @author Stephen Boyett
 * @date 2025-09-06
 * @brief Device state management and monitoring handler.
 * @details Manages device operational state, runtime tracking, sensor readings,
 *          and system status monitoring with real-time Firebase integration.
 * @version 1.0
 * @since 1.0
 */

import 'package:cannasoltech_automation/data_classes/status_message.dart';
import 'package:cannasoltech_automation/objects/database_model.dart';
import 'package:firebase_database/firebase_database.dart';
import '../data_models/device.dart';
import '../data_models/property.dart';
import '../shared/methods.dart';
import '../shared/types.dart';

/**
 * @brief Handles device state management and monitoring.
 * @details Extends DatabaseModel to provide real-time device state tracking,
 *          sensor readings, runtime monitoring, and system status management.
 * @since 1.0
 */
class StateHandler extends DatabaseModel{
  /**
   * @brief Creates a StateHandler instance.
   * @param device Associated device instance for state management
   */
  StateHandler({this.device});

  /// Associated device instance
  dynamic device;

  /// Getter for device online status
  bool get isOnline => device != null ? device.isOnline() : false;

  /// Getter for current device state
  int get state => getIntPropertyValue('state');

  /// Getter for runtime hours
  int get runHours => getIntPropertyValue('run_hours');

  /// Getter for runtime minutes
  int get runMinutes => getIntPropertyValue('run_minutes');

  /// Getter for runtime seconds
  int get runSeconds => getIntPropertyValue('run_seconds');

  /// Getter for formatted runtime string (HH:MM:SS)
  String get runTime => "$runHours:${padZeros((runMinutes % 60), 2)}:${padZeros((runSeconds % 60), 2)}";

  /// Getter for frequency lock status
  bool get freqLock => getBoolPropertyValue('freq_lock');

  /// Getter for parameters validation status
  bool get paramsValid => getBoolPropertyValue('params_valid');

  /// Getter for alarms cleared status
  bool get alarmsCleared => getBoolPropertyValue('alarms_cleared');

  /// Getter for current flow rate reading
  double get flow => getDoublePropertyValue('flow');

  /// Getter for current pressure reading
  double get pressure => getDoublePropertyValue('pressure');

  /// Getter for current temperature reading
  double get temperature => getDoublePropertyValue('temperature');

  double get avgTemp => getDoublePropertyValue('avg_temp');
  double get numPasses => getDoublePropertyValue('num_passes');
  double get avgFlowRate => getDoublePropertyValue('avg_flow_rate');

  StatusMessage get statusMessage => StatusMessage.fromDevice(device);

  factory StateHandler.fromDatabase(DataSnapshot snap, Device device){
    DbMap data = getDbMap(snap);
    DatabaseReference propertyRef;
    StateHandler state = StateHandler();
    state.device = device;
    for (var entry in data.entries){
      propertyRef = snap.child(entry.key).ref;
      state.properties[entry.key] = FireProperty.fromData(entry, propertyRef);
    }
    return state;
  }

  void setRunTime(runSeconds){
    //Simulation Purposes only!
    if ([properties['run_hours'], properties['run_minutes'], properties['run_seconds']]
      .any((element) => element == null)) {
      return;
    }
    properties['run_hours']?.setValue(runSeconds ~/ 3600);
    properties['run_minutes']?.setValue(runSeconds ~/ 60);
    properties['run_seconds']?.setValue(runSeconds % 60);
  }

  void updateRunLogs(runSeconds){    
    if (properties['avg_flow_rate'] != null){
      int runTime = (runHours*3600 + runMinutes*60 + runSeconds).toInt();
      double avgFlow = (avgFlowRate * (runTime-1) + flow) / runTime;
      properties['avg_flow_rate']!.setValue(avgFlow);
      return;
    }
    return;
  }

  Object? operator [](String key) {
    switch (key) {
      case 'state':           return state;
      case 'runHours':        return runHours;
      case 'runMinutes':      return runMinutes;
      case 'runSeconds':      return runSeconds;
      case 'runTime':         return runTime;

      case 'freqLock':        return freqLock;
      case 'paramsValid':     return paramsValid;
      case 'alarmsCleared':   return alarmsCleared;

      case 'flow':            return flow;
      case 'pressure':        return pressure;
      case 'temperature':     return temperature;

      case 'avgTemp':         return avgTemp;
      case 'numPasses':       return numPasses;
      case 'avgFlowRate':     return avgFlowRate;

      default:
        throw ArgumentError('Unknown key "$key"');
    }
  }
}
