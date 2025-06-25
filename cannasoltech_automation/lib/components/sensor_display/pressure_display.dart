import 'package:cannasoltech_automation/components/icons/warn_icon.dart';
import '../../shared/methods.dart';
import 'sensor_display.dart';


class PressureDisplay extends SensorDisplay {

  const PressureDisplay({super.key});
  @override get units => 'psi';
  @override get valCb => (state) => displayDouble(state.pressure, 1);
  @override get warnCb => (alarms) => alarms.pressureWarn; 
  @override get alarmCb => (alarms) => alarms.sonicAlarmActive; 
  @override get warnIcon => const PressureWarnIcon();
  
}
