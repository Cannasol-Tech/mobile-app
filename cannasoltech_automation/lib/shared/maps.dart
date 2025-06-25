import 'package:cannasoltech_automation/shared/constants.dart';

Map<String, dynamic> alarmToNameMap = {
  'flow_alarm' : 'Flow Alarm',
  'temp_alarm' : 'Temperature Alarm',
  'pressure_alarm' : 'Pressure Alarm',
  'overload_alarm' : 'Overload Alarm',
  'freq_lock_alarm' : 'Frequency Lock Alarm',
};

Map<String, dynamic> alarmToIdxMap = {
  'flow_alarm' : SHOW_PUMP,
  'temp_alarm' : SHOW_TANK,
  'pressure_alarm' : SHOW_SONICATOR,
  'overload_alarm' : SHOW_SONICATOR,
  'freq_lock_alarm' : SHOW_SONICATOR
};
