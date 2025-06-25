import '../alarm_message.dart';
import '../../shared/methods.dart';
import 'package:cannasoltech_automation/handlers/state_handler.dart';
import 'package:cannasoltech_automation/handlers/alarm_handler.dart';
import 'package:cannasoltech_automation/components/system_images/system_image.dart';

import '../sensor_display/sensor_display.dart';

abstract class SystemElement{
  abstract String type;
  abstract SystemImage image;
  abstract SensorDisplay sensorDisplay;
  late final List<AlarmMessage> alarmMessages;

  dynamic sysParam(F, A, T) => (type.contains("Flow") ?  F 
                            :   type.contains("Air")  ?  A 
                            :   type.contains("Tank") ?  T 
                                                      : 0.0);


  String getRunVal(StateHandler? state) => (state != null) ?
    displayDouble(sysParam(
      state.flow, 
      state.pressure, 
      state.temperature
    ), 1) : displayDouble(0.0, 1);

  bool getWarn(AlarmsModel alarms) => sysParam(
    alarms.flowWarn, alarms.pressureWarn, alarms.tempWarn
  );

  bool getAlarm(AlarmsModel alarms) => sysParam(
    alarms.pumpAlarmActive, alarms.sonicAlarmActive, alarms.tankAlarmActive
  );
}

