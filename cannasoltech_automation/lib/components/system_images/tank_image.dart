import '../../shared/constants.dart';
import 'system_image.dart';

class TankImage extends SystemImage{
  const TankImage({super.key});
  @override final String path = TANK_PATH;
  @override get alarmActive => (a) => a.tankAlarmActive;
  @override get aspectRatio => .4;
}
