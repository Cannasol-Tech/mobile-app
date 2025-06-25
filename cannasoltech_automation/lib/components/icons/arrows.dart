// ignore_for_file: non_constant_identifier_names, no_leading_underscores_for_local_identifiers, library_private_types_in_public_api, empty_statements
import 'package:cannasoltech_automation/UserInterface/ui.dart';
import 'package:simple_animations/simple_animations.dart';
import '../../UserInterface/animate.dart';
import '../../providers/system_data_provider.dart';
import '../../handlers/alarm_handler.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../../shared/types.dart';


mixin RightArrow on ArrowButton {
  @override get pDirection => Direction.right;
  @override IconData get arrowIconData => (Icons.arrow_forward_ios_sharp);
}

mixin LeftArrow on ArrowButton {
  @override get pDirection => Direction.left;
  @override IconData get arrowIconData => Icons.arrow_back_ios_sharp;
}

///\***))) PUMP (((***///\

abstract class PumpArrowButton extends ArrowButton {
  PumpArrowButton( {super.key} );
  @override final String currentElement = "Pump";
  @override get currentAlarmActive => (alarms) => alarms.pumpAlarmActive;
}

class RightPumpArrow extends PumpArrowButton with RightArrow {
  RightPumpArrow( { super.key } );
  @override get pAlarmActive => (alarms) => alarms.tankAlarmActive               ;
  @override get toolTip => pAlarmActive(alarms) ?     "Tap to see Tank Alarm" 
                                                :          "Tank Display"        ;
  @override get buildFilter => (p, n) => (p.tankAlarmActive != n.tankAlarmActive);
}

class LeftPumpArrow extends PumpArrowButton with LeftArrow {
  LeftPumpArrow( { super.key } );   
  @override get pAlarmActive => (alarms) => alarms.sonicAlarmActive                ;
  @override get toolTip => pAlarmActive(alarms) ?  "Click to see Sonicator Alarm"  
                                                :        "Sonicator Display"       ;
  @override get buildFilter => (p, n) => (p.sonicAlarmActive != n.sonicAlarmActive);
}  


///***))) SONICATOR (((***////

abstract class SonicArrowButton extends ArrowButton {
  SonicArrowButton( {super.key} );
  @override String currentElement = "Sonicator";
  @override get currentAlarmActive => (alarms) => (alarms.sonicAlarmActive);
}

class RightSonicArrow extends SonicArrowButton with RightArrow {
  RightSonicArrow( { super.key } );
  @override get pAlarmActive => (alarms) => alarms.pumpAlarmActive || alarms.tankAlarmActive;
  @override get toolTip => pAlarmActive (alarms)?     "Tap to see Pump Alarm" 
                                                :         "Pump Display"         ; 
  @override get buildFilter => (p, n) => (p.pumpAlarmActive != n.pumpAlarmActive);

}

class LeftSonicArrow extends SonicArrowButton with LeftArrow {
  LeftSonicArrow( { super.key } );
  @override get display => false;
  @override get pAlarmActive => (alarms) => alarms.sonicAlarmActive;
  @override get toolTip => pAlarmActive(alarms)   ?      "N/A" 
                                                  :      "N/A"    ;
  @override get buildFilter => (p, n) => (p.sonicAlarmActive != n.sonicAlarmActive);
}


///\***))) TANK (((***///\

abstract class TankArrowButton extends ArrowButton {
  TankArrowButton({super.key});
  @override final String currentElement = "Tank";
  @override get currentAlarmActive => (alarms) => alarms.tankAlarmActive;
}

class RightTankArrow extends TankArrowButton with RightArrow {
  RightTankArrow( { super.key } );
  @override get display => false;
  @override get pAlarmActive => (alarms) => alarms.pumpAlarmActive;
  @override get toolTip => pAlarmActive(alarms)   ?      "N/A" 
                                                  :      "N/A"    ;
  @override get buildFilter  => (pre, nxt)  => (pre.pumpAlarmActive != nxt.pumpAlarmActive);
  
}

class LeftTankArrow extends TankArrowButton with LeftArrow {
  LeftTankArrow( { super.key } );
  @override get pAlarmActive => (alarms) => alarms.pumpAlarmActive || alarms.sonicAlarmActive;
  @override get toolTip => pAlarmActive(alarms)   ? "Click to see Pump Alarm" 
                                                  :      "Pump Display"     ;
  @override get buildFilter  => (pre, nxt)  => (pre.pumpAlarmActive != nxt.pumpAlarmActive);
}


///\*** Base Class ***///\


abstract class ArrowButton extends StatefulWidget {
  ArrowButton({super.key});

  final bool display = true;
  late final AlarmsModel alarms;

  // Must be implemented by concrete subclass:
  abstract final IconData arrowIconData;
  abstract final Direction pDirection;
  abstract final String currentElement;
  abstract final String toolTip;
  abstract final bool Function(AlarmsModel) pAlarmActive;
  abstract final bool Function(AlarmsModel) currentAlarmActive;
  abstract final bool Function(AlarmsModel, AlarmsModel) buildFilter;

  @override
  State<ArrowButton> createState() => _ArrowButtonState();
}

class _ArrowButtonState extends State<ArrowButton> with TickerProviderStateMixin {
  late ArrowButton w;
  late AnimationController _ctrl150Msec;
  late Animation<double> _animationScalor;

  final double startingPad = 8.0;
  final double startingElevation = 10.0;
  double get startShadowOffset => (w.pDirection == Direction.left) ? -5.0 : 5.0;

  @override
  void initState() {
    super.initState();
    w = widget;
    _ctrl150Msec = ctrl.animateMillis(this, 150);
    _animationScalor = ui.animation(double, _ctrl150Msec, 1.0, 0.0, setState);
  }

  @override
  void dispose() {
    _ctrl150Msec.dispose();
    super.dispose();
  }

  void _handlePress(BuildContext context) {
    _ctrl150Msec.forward(from: 0.0)
    .then((_) {
      _ctrl150Msec.reverse()
      .then((_) {
        if (w.display) {
          final sys = context.read<SystemIdx>();
          if (w.pDirection == Direction.left && sys.value != sys.minValue) {
            sys.decrement();
          } else if (w.pDirection == Direction.right) {
            sys.increment();
          }
        }
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    UI ui = userInterface(context);
    return Selector<SystemDataModel, AlarmsModel>(
      selector: (xXx, p) => (p.activeDevice?.alarms ?? AlarmsModel()),
      shouldRebuild: (AlarmsModel pre, AlarmsModel nxt) => w.buildFilter(pre, nxt),
      builder: (_ctx, alarms, _) {
        print("DEBUG -> pAlarmActive == ${w.pAlarmActive}");
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            shadowColor: Colors.transparent,
            backgroundColor: Colors.transparent,
            splashFactory: NoSplash.splashFactory,    
            padding: (w.pDirection == Direction.left) ? 
              EdgeInsets.fromLTRB(startingPad*2*_animationScalor.value, startingPad*_animationScalor.value*0.1, 0, 0)
              : EdgeInsets.fromLTRB(0, startingPad*_animationScalor.value*0.1, startingPad*2*_animationScalor.value, 0),
              
          ),
          onPressed: () => _handlePress(context),
          child: w.display && ui.size.orientation == Orientation.portrait 
          ? MirrorAnimationBuilder(
              tween: ColorTween(begin: Colors.red.withOpacity(0.2), end: Colors.red.withOpacity(1)),
              duration: const Duration(milliseconds: 200),
              curve: Curves.bounceInOut,
              builder: (BuildContext context, Color? color, Widget? child) {
                return ArrowIcon(
              w.arrowIconData, 
              shadowOffset: startShadowOffset*_animationScalor.value,
              arrowShade:  (w.pAlarmActive(alarms) == true) ? 
                  color ?? Colors.transparent
                : Colors.lightBlueAccent.withOpacity(0.4)
              );
            }) : const Icon(Icons.add_circle_outline_rounded, color: Colors.transparent)
        );
      },
    );
  }


  bool pRightSonicAlarms(alarms) =>  alarms.pumpAlarmActive 
                                  || alarms.tankAlarmActive;

  bool pRightPumpAlarms(alarms)  =>  alarms.tankAlarmActive;

  bool pLeftTankAlarms (alarms)  =>  alarms.pumpAlarmActive 
                                  || alarms.sonicAlarmActive;

  bool pLeftPumpAlarms(alarms)   =>  alarms.sonicAlarmActive;

  bool pTankAlarms(alarms, pDir) => pDir == Direction.left 
                                  ? pLeftTankAlarms(alarms) : false;  

  bool pSonicAlarms(alarms, pDir) => pDir == Direction.right 
                                  ? pRightSonicAlarms(alarms) : false;

  bool pPumpAlarms(alarms, pDir) => pDir == Direction.right 
                                  ? pRightPumpAlarms(alarms) : pLeftPumpAlarms(alarms);
}

