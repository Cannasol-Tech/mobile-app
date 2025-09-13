// freqLockDisplay Tests
//
// Verifies basic rendering and label visibility for frequency lock display.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cannasoltech_automation/components/freq_lock_display.dart';

import '../../helpers/test_utils.dart';

void main() {
  TestEnvironment.setupGroup();

  testWidgets('renders with Hz label', (tester) async {
    await tester.pumpWidget(createTestApp(
      child: Scaffold(
        body: Center(child: freqLockDisplay(null, true, false)),
      ),
    ));

    expect(find.text('Hz'), findsOneWidget);
  });
}

