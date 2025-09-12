import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cannasoltech_automation/components/confirm_dialog.dart';
import '../../helpers/golden_utils.dart';

void main() {
  group('ConfirmDialog golden', () {
    testWidgets('default dialog', (tester) async {
      final widget = GoldenUtils.appWrapper(
        themeMode: ThemeMode.light,
        child: Builder(
          builder: (context) {
            // Build a button that opens the dialog, then open it.
            return ElevatedButton(
              onPressed: () => showDialog(
                context: context,
                builder: (_) => const ConfirmDialog(
                  title: 'Confirm Action',
                  message: 'Are you sure you want to proceed? This cannot be undone.',
                ),
              ),
              child: const Text('Open'),
            );
          },
        ),
      );

      await tester.pumpWidget(widget);
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(ConfirmDialog),
        matchesGoldenFile('test/golden/screenshots/confirm_dialog_default.png'),
      );
    });

    testWidgets('destructive dialog', (tester) async {
      final widget = GoldenUtils.appWrapper(
        themeMode: ThemeMode.light,
        child: Builder(
          builder: (context) {
            return ElevatedButton(
              onPressed: () => showDialog(
                context: context,
                builder: (_) => const ConfirmDialog(
                  title: 'Delete Device',
                  message: 'This will permanently remove the device.',
                  isDestructive: true,
                  confirmText: 'Delete',
                ),
              ),
              child: const Text('Open'),
            );
          },
        ),
      );

      await tester.pumpWidget(widget);
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(ConfirmDialog),
        matchesGoldenFile('test/golden/screenshots/confirm_dialog_destructive.png'),
      );
    });
  });
}

