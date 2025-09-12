import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cannasoltech_automation/components/display_system.dart';
import '../../helpers/golden_utils.dart';

void main() {
  group('DisplaySysValUnits golden', () {
    testWidgets('light theme - nominal sample', (tester) async {
      final widget = GoldenUtils.appWrapper(
        themeMode: ThemeMode.light,
        child: SizedBox(
          width: 320,
          height: 120,
          child: const DisplaySysValUnits(
            text: 'Frequency',
            val: '20.00',
            units: 'kHz',
          ),
        ),
      );

      await tester.pumpWidget(widget);
      await GoldenUtils.settleAnimations(tester);

      await expectLater(
        find.byType(DisplaySysValUnits),
        matchesGoldenFile('test/golden/screenshots/display_sys_val_units_light.png'),
      );
    });

    testWidgets('dark theme - nominal sample', (tester) async {
      final widget = GoldenUtils.appWrapper(
        themeMode: ThemeMode.dark,
        child: SizedBox(
          width: 320,
          height: 120,
          child: const DisplaySysValUnits(
            text: 'Frequency',
            val: '20.00',
            units: 'kHz',
          ),
        ),
      );

      await tester.pumpWidget(widget);
      await GoldenUtils.settleAnimations(tester);

      await expectLater(
        find.byType(DisplaySysValUnits),
        matchesGoldenFile('test/golden/screenshots/display_sys_val_units_dark.png'),
      );
    });
  });
}

