// ignore_for_file: no_leading_underscores_for_local_identifiers
import 'system_display.dart';
import '../icons/arrows.dart';
import '../system_elements/tank_element.dart';
import '../system_elements/system_element.dart';

/* Builds a Tank Element and passes the element to be displayed by a system display */

class TankDisplay extends SystemDisplay{
  const TankDisplay({super.key});
  @override ArrowButton get leftArrow => LeftTankArrow();
  @override ArrowButton get rightArrow => RightTankArrow();
  @override SystemElement get systemElement => TankElement();
}
 