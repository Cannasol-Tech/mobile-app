// ignore_for_file: no_leading_underscores_for_local_identifiers
import 'system_display.dart';
import '../icons/arrows.dart';
import '../system_elements/pump_element.dart';
import '../system_elements/system_element.dart';

/* Builds a Pump Element and passes the element to be displayed by a system display */

class PumpDisplay extends SystemDisplay{
  const PumpDisplay({super.key});
  @override ArrowButton get leftArrow => LeftPumpArrow();
  @override ArrowButton get rightArrow => RightPumpArrow();
  @override SystemElement get systemElement => PumpElement();
}
