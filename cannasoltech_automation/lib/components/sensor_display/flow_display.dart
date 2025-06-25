import 'package:cannasoltech_automation/components/icons/warn_icon.dart';
import 'package:cannasoltech_automation/shared/methods.dart';
import 'sensor_display.dart';


class FlowDisplay extends SensorDisplay {
  const FlowDisplay({super.key});
  @override get units => "L/min";
  @override get valCb => (state) => displayDouble(state.flow, 1);
  @override get warnCb => (alarms) => alarms.flowWarn; 
  @override get alarmCb => (alarms) => alarms.flowAlarm; 
  @override get warnIcon => const FlowWarnIcon();
}