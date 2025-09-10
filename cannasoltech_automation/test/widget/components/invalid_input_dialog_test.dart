// invalidInputDialog Tests
//
// Verifies that the invalid input dialog shows expected title and content and dismisses.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cannasoltech_automation/components/invalid_input.dart';

import '../../helpers/test_utils.dart';

void main() {
  TestEnvironment.setupGroup();

  testWidgets('shows invalid input dialog and dismisses', (tester) async {
    await tester.pumpWidget(createTestApp(
      child: Builder(
        builder: (context) => ElevatedButton(
          onPressed: () => invalidInputDialog(context, 0, 10),
          child: const Text('Open'),
        ),
      ),
    ));

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    expect(find.text('Invalid Input!'), findsOneWidget);
    expect(find.textContaining('Please enter a value in the range'), findsOneWidget);

    await tester.tap(find.text('Ok'));
    await tester.pumpAndSettle();
    expect(find.text('Invalid Input!'), findsNothing);
  });
}

