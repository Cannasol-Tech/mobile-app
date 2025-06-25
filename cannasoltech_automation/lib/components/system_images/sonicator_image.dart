import '../../shared/constants.dart';
import 'system_image.dart';


class SonicatorImage extends SystemImage{
  const SonicatorImage({super.key});
  @override final String path = SONIC_PATH;
  @override get alarmActive => (a) => a.sonicAlarmActive;
  @override get aspectRatio => 6/7;
}
