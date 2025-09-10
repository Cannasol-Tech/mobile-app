// SysValInput Widget Tests
//
// Verifies validation, submission, and dialog behavior of SysValInput.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cannasoltech_automation/components/system_value_input_new.dart';

import '../../helpers/test_utils.dart';

void main() {
  TestEnvironment.setupGroup();

  group('SysValInput', () {
    testWidgets('accepts valid value and calls setMethod on submit', (tester) async {
      final controller = TextEditingController(text: '5.0');
      String? received;

      await tester.pumpWidget(createTestApp(
        child: Scaffold(
          body: Center(
            child: SysValInput(
              controller: controller,
              setMethod: (val) => received = val,
              width: 200,
              minVal: 0,
              maxVal: 10,
              units: 'L',
            ),
          ),
        ),
      ));

      await tester.enterText(find.byType(TextFormField), '7.5');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      expect(received, equals('7.5'));
    });

    testWidgets('shows invalid dialog for out-of-range input', (tester) async {
      final controller = TextEditingController(text: '100');

      await tester.pumpWidget(createTestApp(
        child: Scaffold(
          body: Center(
            child: SysValInput(
              controller: controller,
              setMethod: (_) {},
              width: 200,
              minVal: 0,
              maxVal: 10,
              units: 'L',
            ),
          ),
        ),
      ));

      // Trigger onTapOutside behavior
      await tester.tapAt(const Offset(1, 1));
      await tester.pumpAndSettle();

      expect(find.textContaining('Invalid (0.0 - 10.0)'), findsOneWidget);
      expect(find.text('Notice!'), findsOneWidget);
    });
  });
}

