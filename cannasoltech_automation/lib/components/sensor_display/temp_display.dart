import 'package:cannasoltech_automation/components/icons/warn_icon.dart';

import '../../shared/methods.dart';
import 'sensor_display.dart';


class TemperatureDisplay extends SensorDisplay {
  const TemperatureDisplay({super.key});
  @override get units => '\u2103';
  @override get valCb => (state) => displayDouble(state.temperature, 1);
  @override get warnCb => (alarms) => alarms.tempWarn; 
  @override get alarmCb => (alarms) => alarms.tempAlarm; 
  @override get warnIcon => const TempWarnIcon();
}
