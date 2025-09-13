// Shared Display Widgets Tests

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cannasoltech_automation/shared/shared_widgets.dart';

import '../../helpers/test_utils.dart';

void main() {
  TestEnvironment.setupGroup();

  testWidgets('DisplaySysVal shows text and value with colon', (tester) async {
    await tester.pumpWidget(createTestApp(
      child: const Scaffold(
        body: Center(child: DisplaySysVal(text: 'Average Flow', val: '1.2')),
      ),
    ));
    expect(find.text('Average Flow: 1.2'), findsOneWidget);
  });

  testWidgets('DisplaySysValNoColon shows text and value without colon', (tester) async {
    await tester.pumpWidget(createTestApp(
      child: const Scaffold(
        body: Center(child: DisplaySysValNoColon(displayText: 'Operator', displayValue: 'Alice')),
      ),
    ));
    expect(find.text('Operator Alice'), findsOneWidget);
  });
}

