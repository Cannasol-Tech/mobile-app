// This is a basic Flutter widget test for the Cannasol Tech Automation app.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:cannasoltech_automation/providers/system_data_provider.dart';
import 'package:cannasoltech_automation/providers/display_data_provider.dart';
import 'package:cannasoltech_automation/providers/transform_provider.dart';
import 'package:cannasoltech_automation/shared/maps.dart';

import 'package:cannasoltech_automation/main.dart';

void main() {
  testWidgets('App loads and displays correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) {
            var sysIdx = SystemIdx();
            return sysIdx;
          }),
          ChangeNotifierProvider(create: (context) {
            var systemDataModel = SystemDataModel();
            return systemDataModel;
          }),
          ChangeNotifierProvider(create: (context) {
            var transformModel = TransformModel();
            return transformModel;
          }),
          ChangeNotifierProvider(create: (context) => DisplayDataModel()),
        ],
        child: const MyApp(),
      ),
    );

    // Let the widget settle
    await tester.pumpAndSettle();

    // Verify that the app builds without errors
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
