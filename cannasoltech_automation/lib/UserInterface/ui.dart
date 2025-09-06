/**
 * @file ui.dart
 * @author Stephen Boyett
 * @date 2025-09-06
 * @brief User interface utilities and color management library.
 * @details Provides UI components, color schemes, and visual utilities for the
 *          Cannasol Technologies application including system state colors and animations.
 * @version 1.0
 * @since 1.0
 */

library ui;

import 'package:decorated_icon/decorated_icon.dart';
import 'package:flutter/material.dart';

import 'animate.dart';
part 'icons.dart';

/**
 * @brief Color database for application-wide color management.
 * @details Provides standardized colors for different system states including
 *          warm-up, cool-down, alarm, and warning states with alpha variations.
 * @since 1.0
 */
class ColorDb {
  /// Primary warm-up state color
  Color get warmUp1 => const Color.fromARGB(255, 170, 51, 51);

  /// Secondary warm-up state color
  Color get warmUp2 => const Color.fromARGB(255, 117, 25, 25);

  /**
   * @brief Creates warm-up color 1 with specified alpha.
   * @param alpha Alpha value (0-255)
   * @return Color with specified alpha
   */
  Color alphaWarm1(int alpha) => Color.fromARGB(alpha, 170, 51, 51);

  /**
   * @brief Creates warm-up color 2 with specified alpha.
   * @param alpha Alpha value (0-255)
   * @return Color with specified alpha
   */
  Color alphaWarm2(int alpha) => Color.fromARGB(alpha, 117, 25, 25);

  /// Primary cool-down state color
  Color get CoolDown1 => const Color.fromARGB(255, 52, 113, 206);

  /// Secondary cool-down state color
  Color get CoolDown2 => const Color.fromARGB(255, 53, 130, 245);

  /**
   * @brief Creates cool-down color 1 with specified alpha.
   * @param alpha Alpha value (0-255)
   * @return Color with specified alpha
   */
  Color alphaCool1(int alpha) => Color.fromARGB(alpha, 52, 113, 206);

  /**
   * @brief Creates cool-down color 2 with specified alpha.
   * @param alpha Alpha value (0-255)
   * @return Color with specified alpha
   */
  Color alphaCool2(int alpha) => Color.fromARGB(alpha, 53, 130, 245);

  /// Alarm state color (bright red)
  Color get alarm => const Color.fromARGB(255, 255, 17, 0);

  /// No alarm state color (transparent)
  Color get noAlarm => Colors.transparent;

  /**
   * @brief Creates alarm color with specified alpha.
   * @param alpha Alpha value (0-255)
   * @return Alarm color with specified alpha
   */
  Color alphaAlarm(int alpha) => Color.fromARGB(alpha, 255, 30, 40);

  /**
   * @brief Creates warning color with specified alpha.
   * @param alpha Alpha value (0-255)
   * @return Warning color with specified alpha
   */
  Color alphaWarn(int alpha) => Color.fromARGB(alpha, 255, 242, 61); // Use ARGB for explicit alpha

  Color scaleBlend(int scalor) => Color.alphaBlend(
    Color.fromARGB((scalor*255),255,255,255),
    const Color.fromARGB(150,255,255,255),

  ); 

Color alphaColor(alpha, color) => Color.fromARGB((alpha*255).toInt(), color.red, color.green, color.blue);

  Color dialogBtnColor(alpha) => Color.alphaBlend(
    Colors.white.withAlpha((alpha*50).toInt()),
    Colors.blueGrey.withAlpha((alpha*20).toInt())
  );

  Color alphaWhite(int alpha) => Color.fromARGB(alpha, 255, 255, 255);

  ColorTween coolDownTween({alpha= 255}) => ColorTween(
    begin: alphaCool1(alpha), 
    end: alphaCool2(alpha)
  );

  ColorTween warmUpTween({int alpha= 255}) => ColorTween(
    begin: alphaWarm1(alpha), 
    end: alphaWarm2(alpha)
  );

  ColorTween alarmTween() => ColorTween(
    begin: alphaAlarm(0), 
    end: alphaAlarm(255)
  );

  ColorTween warnTween() => ColorTween(
    begin: alphaWarn(0), 
    end: alphaWarn(255)
  );
  
}

class SizeHdlr {
  BuildContext? _ctx;
  Orientation get orientation => MediaQuery.of(_ctx!).orientation;
  SizeHdlr({ctx}) {
    _ctx = ctx;
  } 


  bool get isPortrait => (orientation == Orientation.portrait);

  Size get display => MediaQuery.of(_ctx!).size;
  double get displayWidth => MediaQuery.of(_ctx!).size.width;  
  double get displayHeight => MediaQuery.of(_ctx!).size.height;
  double get maxWidth => displayWidth < 325 ? displayWidth*0.9 : 350;

  double get boxHeight => (isPortrait) ? displayHeight*0.06 : displayHeight*0.10;

  double get boxWidth => (isPortrait) ? displayWidth*0.38: displayWidth*0.15;

  double get bottomButtonWidth => 100;

  double get bottomButtonHeight => 50;

  double get sysImageWidth => (isPortrait) 
                            ? displayWidth*0.7
                            : displayWidth*0.33;

  double get sysImageHeight => (isPortrait) 
                            ? displayHeight*0.6
                            : displayHeight*0.42;
}

class UI {
  BuildContext? _ctx;
  UI({ctx}){ _ctx = ctx; }

  set ctx(BuildContext? ctx) => _ctx = ctx;

  ColorDb get colors => ColorDb();
  ArrowIcons arrowIcons = ArrowIcons();
  SizeHdlr get size => SizeHdlr(ctx: _ctx);
  Orientation get orientation => MediaQuery.of(_ctx!).orientation;
  bool get isPortrait => (orientation == Orientation.portrait);

  EffectsHdlr fx = EffectsHdlr();
  ControllerHdlr ctrl = ControllerHdlr();
  animation(
    type, ctrl, begin, end, setState
  ) { 
    if (type == int) {
      return AnimationsHdlr().intAnimation(ctrl, begin.toInt(), end.toInt(), setState);
    }
    else if (type == double) {
      return AnimationsHdlr().doubleAnimation(ctrl, begin.toDouble(), end.toDouble(), setState);
    }
    else if (type == Color) {
      return AnimationsHdlr().colorAnimation(ctrl, begin, end, setState);
    }
    else {
      return AnimationsHdlr().dynamicAnimation(ctrl, begin, end, setState);  
    }
  }
}

UI userInterface(ctx) => UI(ctx: ctx);

UI get ui => UI();
