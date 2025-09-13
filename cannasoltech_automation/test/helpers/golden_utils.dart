import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Utilities for golden testing without mocks.
class GoldenUtils {
  GoldenUtils._();

  /// Wraps [child] in a MaterialApp + Scaffold, with the given theme mode.
  static Widget appWrapper({
    required Widget child,
    ThemeMode themeMode = ThemeMode.light,
    ThemeData? lightTheme,
    ThemeData? darkTheme,
  }) {
    return MaterialApp(
      theme: lightTheme ?? ThemeData.light(useMaterial3: true),
      darkTheme: darkTheme ?? ThemeData.dark(useMaterial3: true),
      themeMode: themeMode,
      home: Scaffold(
        backgroundColor: themeMode == ThemeMode.dark
            ? (darkTheme?.colorScheme.background ?? Colors.black)
            : (lightTheme?.colorScheme.background ?? Colors.white),
        body: Center(child: child),
      ),
    );
  }

  /// Pump a frame and wait long enough for short entrance animations to settle.
  static Future<void> settleAnimations(WidgetTester tester) async {
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 250));
  }
}

