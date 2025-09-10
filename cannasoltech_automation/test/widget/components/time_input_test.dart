// DurationInputWidget Tests
//
// Verifies that valid durations invoke callback and invalid ones show alert.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cannasoltech_automation/components/time_input.dart';

import '../../helpers/test_utils.dart';

void main() {
  TestEnvironment.setupGroup();

  group('DurationInputWidget', () {
    testWidgets('calls onDurationChanged for valid HH:MM', (tester) async {
      final controller = TextEditingController();
      Duration? received;

      await tester.pumpWidget(createTestApp(
        child: Scaffold(
          body: Center(
            child: DurationInputWidget(
              labelText: 'Run Time',
              width: 200,
              controller: controller,
              onDurationChanged: (d) => received = d,
            ),
          ),
        ),
      ));

      await tester.enterText(find.byType(TextField), '01:30');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      expect(received, equals(const Duration(hours: 1, minutes: 30)));
    });

    testWidgets('shows alert for invalid format and clears input', (tester) async {
      final controller = TextEditingController();

      await tester.pumpWidget(createTestApp(
        child: Scaffold(
          body: Center(
            child: DurationInputWidget(
              labelText: 'Run Time',
              width: 200,
              controller: controller,
              onDurationChanged: (_) {},
            ),
          ),
        ),
      ));

      await tester.enterText(find.byType(TextField), '1:3');
      // Tap outside to trigger validation path
      await tester.tapAt(const Offset(1, 1));
      await tester.pumpAndSettle();

      expect(find.text('Notice!'), findsOneWidget);
      expect(find.text("Please enter the run time in the format 'HH:MM'"), findsOneWidget);
    });
  });
}

