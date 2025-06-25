// ignore_for_file: no_leading_underscores_for_local_identifiers
import 'package:flutter/material.dart';

import '../icons/arrows.dart';
import '../system_elements/system_element.dart';
import '../system_elements/sonicator_element.dart';
import 'package:cannasoltech_automation/components/system_display/system_display.dart';

///  Displays Sonicator Element on Screen 

class SonicatorDisplay extends SystemDisplay{
  const SonicatorDisplay({super.key, this.orientation=Orientation.portrait});
  final Orientation orientation;
  @override ArrowButton get leftArrow => LeftSonicArrow();
  @override ArrowButton get rightArrow => RightSonicArrow();
  @override SystemElement get systemElement => SonicatorElement();
}
