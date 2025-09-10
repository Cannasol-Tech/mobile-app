// Debug test for ConfirmDialog
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cannasoltech_automation/components/confirm_dialog.dart';

import '../../helpers/test_utils.dart';

void main() {
  testWidgets('debug confirm dialog buttons', (WidgetTester tester) async {
    // Arrange
    await tester.pumpWidget(
      createTestApp(
        child: Builder(
          builder: (context) => ElevatedButton(
            onPressed: () => showDialog(
              context: context,
              builder: (_) => const ConfirmDialog(
                title: 'Test',
                message: 'Test message',
              ),
            ),
            child: const Text('Show Dialog'),
          ),
        ),
      ),
    );

    await TestInteractions.tap(tester, find.text('Show Dialog'));
    await tester.pumpAndSettle();

    // Debug: Print all widgets
    print('All widgets:');
    tester.widgetList(find.byType(Widget)).forEach((widget) {
      print('  ${widget.runtimeType}: $widget');
    });

    // Debug: Try to find TextButton widgets specifically
    print('\nTextButton widgets:');
    tester.widgetList(find.byType(TextButton)).forEach((widget) {
      print('  TextButton: $widget');
    });

    // Debug: Try to find widgets by text
    print('\nWidgets found by text "Confirm":');
    final confirmFinder = find.text('Confirm');
    print('Found ${confirmFinder.evaluate().length} widgets');
    confirmFinder.evaluate().forEach((element) {
      print('  ${element.widget.runtimeType}: ${element.widget}');
    });
  });
}
