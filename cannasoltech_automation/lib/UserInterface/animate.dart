
import 'package:flutter/animation.dart';

class EffectsHdlr {
    fadeInOut(ctrl) => 
    ctrl.forward(from: 0.0)
    .then((_) => ctrl.reverse());

    fnfadeInOut(before, ctrl) => (
      before()
      .then(() => ctrl.forward(from: 0.0))
      .then(() => ctrl.reverse())
    );

    fnfadeInOutfn(before, ctrl, after) => (
      before()
      .thenctrl.forward(from: 0.0)
      .then(() => ctrl.reverse())
      .then(() => after())
    );
}


class AnimationsHdlr {
  Animation<int> intAnimation(ctrl, begin, end, setState) => IntTween(
    begin: begin,
    end: end,
  ).animate(ctrl)
  ..addListener(() => setState(() {})); 

  Animation<double> doubleAnimation(ctrl, begin, end, setState) => Tween<double>(
    begin: begin,
    end: end,
  ).animate(ctrl)
  ..addListener(() => setState(() {})); 
  
  Animation<Color?> colorAnimation(ctrl, begin, end, setState) => ColorTween(
    begin: begin,
    end: end,
  ).animate(ctrl)
  ..addListener(() => setState(() {}));

  Animation<dynamic> dynamicAnimation(ctrl, begin, end, setState) => Tween(
    begin: begin,
    end: end,
  ).animate(ctrl)
  ..addListener(() => setState(() {}));

}


class ControllerHdlr {
    AnimationController animateSeconds(obj, seconds) => AnimationController(
      vsync: obj,
      duration: Duration(milliseconds: seconds*1000),
    );
    AnimationController animateMillis(obj, millis) => AnimationController(
      vsync: obj,
      duration: Duration(milliseconds: millis),
    );
}

ControllerHdlr ctrl = ControllerHdlr(); 