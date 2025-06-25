import 'dart:async';

import 'package:flutter/material.dart';

class TransformModel extends ChangeNotifier {
  dynamic _rotateGradientTimer;

  int _rotateFactor = 0;
  int get rotateFactor => _rotateFactor;

  void init() {
    startRotateGradientTimer();
  }
  @override
  dispose() {
    stopRotateGradientTimer();
    super.dispose();
  }
  
  void _updateRotateGradientVal(){
    _rotateFactor = _rotateFactor + 1;
    notifyListeners();
  }

  void startRotateGradientTimer() {
    if (_rotateGradientTimer == null){
      _rotateGradientTimer = Timer.periodic(const Duration(milliseconds: 100), ((Timer t) {
        _updateRotateGradientVal();
      }));
    }
    else {
      _rotateGradientTimer = null;
    }
  }

  void stopRotateGradientTimer() {
    if (_rotateGradientTimer != null){
      _rotateGradientTimer!.cancel();
      _rotateGradientTimer = null;
    }
  }
}
