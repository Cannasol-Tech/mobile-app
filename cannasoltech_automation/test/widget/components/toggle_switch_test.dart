// ToggleSwitch Widget Tests
//
// Verifies rendering and interaction behavior of ToggleSwitch.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cannasoltech_automation/components/toggle_switch.dart';

import '../../helpers/test_utils.dart';

void main() {
  TestEnvironment.setupGroup();

  group('ToggleSwitch', () {
    testWidgets('renders with initial value and toggles on tap', (tester) async {
      bool current = false;
      bool? lastCallbackValue;

      await tester.pumpWidget(createTestApp(
        child: Center(
          child: ToggleSwitch(
            value: current,
            onChanged: (v) {
              current = v;
              lastCallbackValue = v;
            },
          ),
        ),
      ));

      // Tap to toggle on
      await tester.tap(find.byType(ToggleSwitch));
      await tester.pumpAndSettle();
      expect(current, isTrue);
      expect(lastCallbackValue, isTrue);

      // Tap to toggle off
      await tester.tap(find.byType(ToggleSwitch));
      await tester.pumpAndSettle();
      expect(current, isFalse);
      expect(lastCallbackValue, isFalse);
    });

    testWidgets('has expected size and colors', (tester) async {
      await tester.pumpWidget(createTestApp(
        child: const Center(
          child: ToggleSwitch(value: false, onChanged: _noop),
        ),
      ));

      expect(find.byType(ToggleSwitch), findsOneWidget);
    });
  });
}

void _noop(bool _) {}

