/**
 * @file transform_provider.dart
 * @author Stephen Boyett
 * @date 2025-09-06
 * @brief Transform and animation provider for UI effects.
 * @details Manages UI transformation animations including gradient rotation
 *          and other visual effects with timer-based updates.
 * @version 1.0
 * @since 1.0
 */

import 'dart:async';

import 'package:flutter/material.dart';

/**
 * @brief Provider for managing UI transform animations.
 * @details Extends ChangeNotifier to provide reactive animation state management
 *          including gradient rotation effects with periodic timer updates.
 * @since 1.0
 */
class TransformModel extends ChangeNotifier {
  /// Timer for gradient rotation animation
  dynamic _rotateGradientTimer;

  /// Private rotation factor for gradient animation
  int _rotateFactor = 0;

  /// Getter for current rotation factor
  int get rotateFactor => _rotateFactor;

  /**
   * @brief Initializes the transform model and starts animations.
   * @details Sets up gradient rotation timer and begins animation cycles.
   * @since 1.0
   */
  void init() {
    startRotateGradientTimer();
  }

  /**
   * @brief Disposes of the transform model and cleans up resources.
   * @details Stops all timers and calls parent dispose method.
   * @since 1.0
   */
  @override
  dispose() {
    stopRotateGradientTimer();
    super.dispose();
  }

  /**
   * @brief Updates the rotation gradient value and notifies listeners.
   * @details Increments the rotation factor and triggers UI updates.
   * @since 1.0
   */
  void _updateRotateGradientVal(){
    _rotateFactor = _rotateFactor + 1;
    notifyListeners();
  }

  /**
   * @brief Starts the gradient rotation timer.
   * @details Creates a periodic timer that updates rotation values every 100ms.
   * @since 1.0
   */
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
