import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cannasoltech_automation/components/buttons/confirm_button.dart';
import '../../../helpers/golden_utils.dart';

void main() {
  group('ConfirmButton golden', () {
    testWidgets('light theme', (tester) async {
      final widget = ConfirmButton(
        color: Colors.green,
        confirmMethod: () {},
        confirmText: 'proceed with operation',
        buttonText: 'Confirm',
        hero: 'confirmBtnLight',
      );

      await tester.pumpWidget(
        GoldenUtils.appWrapper(child: widget, themeMode: ThemeMode.light),
      );
      await GoldenUtils.settleAnimations(tester);

      await expectLater(
        find.byType(ConfirmButton),
        matchesGoldenFile('test/golden/screenshots/confirm_button_light.png'),
      );
    });

    testWidgets('dark theme', (tester) async {
      final widget = ConfirmButton(
        color: Colors.green,
        confirmMethod: () {},
        confirmText: 'proceed with operation',
        buttonText: 'Confirm',
        hero: 'confirmBtnDark',
      );

      await tester.pumpWidget(
        GoldenUtils.appWrapper(child: widget, themeMode: ThemeMode.dark),
      );
      await GoldenUtils.settleAnimations(tester);

      await expectLater(
        find.byType(ConfirmButton),
        matchesGoldenFile('test/golden/screenshots/confirm_button_dark.png'),
      );
    });
  });
}

