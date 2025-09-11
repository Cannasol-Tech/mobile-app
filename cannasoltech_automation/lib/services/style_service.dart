import 'package:flutter/material.dart';

/// Service class for global styling concerns
/// Replaces global style variables like noDeviceStyle
class StyleService {
  static StyleService? _instance;
  StyleService._internal();
  
  factory StyleService() {
    _instance ??= StyleService._internal();
    return _instance!;
  }
  
  /// Text style for when no device is selected
  static const TextStyle noDeviceStyle = TextStyle(
    fontSize: 24, 
    color: Colors.red, 
    fontWeight: FontWeight.bold
  );
  
  /// Configuration header text style
  static const TextStyle configHeaderStyle = TextStyle(
    fontSize: 22, 
    fontWeight: FontWeight.bold, 
    decoration: TextDecoration.underline
  );
  
  /// Get text style for no device state
  TextStyle getNoDeviceStyle() => noDeviceStyle;
  
  /// Get configuration header style
  TextStyle getConfigHeaderStyle() => configHeaderStyle;
}