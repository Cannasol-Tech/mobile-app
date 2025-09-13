// resetButton Tests
//
// Verifies that resetButton renders and tapping shows confirm dialog.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cannasoltech_automation/components/buttons/reset_button.dart';

import '../../../helpers/test_utils.dart';

class _FakeConfig { void resetDevice() {} }
class _FakeDevice { final _FakeConfig config = _FakeConfig(); }
class _FakeProvider { final _FakeDevice? activeDevice = _FakeDevice(); }

typedef _DP = dynamic Function(BuildContext,{bool listen});

void main() {
  TestEnvironment.setupGroup();

  testWidgets('shows confirm dialog on tap', (tester) async {
    final _DP dp = (BuildContext _, {bool listen = false}) => _FakeProvider();

    await tester.pumpWidget(createTestApp(
      child: Scaffold(
        body: Center(child: Builder(
          builder: (context) => resetButton(context, dp),
        )),
      ),
    ));

    await tester.tap(find.text('Reset'));
    await tester.pumpAndSettle();

    expect(find.textContaining('wish to reset the device'), findsOneWidget);
  });
}

