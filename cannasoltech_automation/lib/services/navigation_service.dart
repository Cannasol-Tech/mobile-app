import 'package:flutter/material.dart';

/// Service class to encapsulate navigation and scaffolding keys
/// Replaces the global navigatorKey and scaffoldMessengerKey variables
class NavigationService {
  static NavigationService? _instance;
  NavigationService._internal();
  
  factory NavigationService() {
    _instance ??= NavigationService._internal();
    return _instance!;
  }
  
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  
  /// Get the current navigator state
  NavigatorState? get navigator => navigatorKey.currentState;
  
  /// Get the current scaffold messenger state
  ScaffoldMessengerState? get scaffoldMessenger => scaffoldMessengerKey.currentState;
  
  /// Get the current context from navigator
  BuildContext? get currentContext => navigatorKey.currentContext;
  
  /// Navigate to a new route
  Future<T?> pushNamed<T extends Object?>(String routeName, {Object? arguments}) {
    return navigator?.pushNamed<T>(routeName, arguments: arguments) ?? 
           Future.value(null);
  }
  
  /// Pop the current route
  void pop<T extends Object?>([T? result]) {
    navigator?.pop<T>(result);
  }
  
  /// Show a snack bar
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason>? showSnackBar(SnackBar snackBar) {
    return scaffoldMessenger?.showSnackBar(snackBar);
  }
}