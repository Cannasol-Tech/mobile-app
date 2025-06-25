

import '../../shared/constants.dart';
import 'system_image.dart';


class PumpImage extends SystemImage{
  const PumpImage({super.key});
  @override final String path = PUMP_PATH;
  @override get alarmActive => (a) => a.pumpAlarmActive;
  @override get aspectRatio => 1;
}