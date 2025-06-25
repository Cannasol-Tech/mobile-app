import 'package:cannasoltech_automation/data_classes/status_message.dart';
import 'package:cannasoltech_automation/objects/database_model.dart';
import 'package:firebase_database/firebase_database.dart';
import '../data_models/device.dart';
import '../data_models/property.dart';
import '../shared/methods.dart';
import '../shared/types.dart';


class StateHandler extends DatabaseModel{
  StateHandler({this.device});
  dynamic device;

  bool get isOnline => device != null ? device.isOnline() : false;

  int get state => getIntPropertyValue('state');
  int get runHours => getIntPropertyValue('run_hours');
  int get runMinutes => getIntPropertyValue('run_minutes');
  int get runSeconds => getIntPropertyValue('run_seconds');
    
  String get runTime => "$runHours:${padZeros((runMinutes % 60), 2)}:${padZeros((runSeconds % 60), 2)}";

  bool get freqLock => getBoolPropertyValue('freq_lock');
  bool get paramsValid => getBoolPropertyValue('params_valid');
  bool get alarmsCleared => getBoolPropertyValue('alarms_cleared');

  double get flow => getDoublePropertyValue('flow');
  double get pressure => getDoublePropertyValue('pressure');
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
