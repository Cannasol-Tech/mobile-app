// WarnIcon/sysWarning Tests
//
// Verifies that sysWarning dialog shows expected text and dismisses.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cannasoltech_automation/components/icons/warn_icon.dart';

import '../../helpers/test_utils.dart';

void main() {
  TestEnvironment.setupGroup();

  testWidgets('sysWarning shows proper dialog content', (tester) async {
    await tester.pumpWidget(createTestApp(
      child: Builder(
        builder: (context) => ElevatedButton(
          onPressed: () => showDialog(
            context: context,
            builder: (_) => sysWarning(context, 'Flow', 1.0, null, 'L/min'),
          ),
          child: const Text('Open'),
        ),
      ),
    ));

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    expect(find.text('Warning!'), findsOneWidget);
    expect(find.textContaining('Flow is close to configured minimum value of 1.0 L/min!'), findsOneWidget);

    await tester.tap(find.text('Ok'));
    await tester.pumpAndSettle();
    expect(find.text('Warning!'), findsNothing);
  });
}

