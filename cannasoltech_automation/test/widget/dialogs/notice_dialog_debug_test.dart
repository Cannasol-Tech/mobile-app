// Debug test for NoticeDialog
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cannasoltech_automation/components/notice_dialog.dart';

import '../../helpers/test_utils.dart';

void main() {
  testWidgets('debug notice dialog buttons', (WidgetTester tester) async {
    // Arrange
    await tester.pumpWidget(
      createTestApp(
        child: Builder(
          builder: (context) => ElevatedButton(
            onPressed: () => showDialog(
              context: context,
              builder: (_) => const NoticeDialog(
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

    // Debug: Try to find widgets by text
    print('\nWidgets found by text "OK":');
    final okFinder = find.text('OK');
    print('Found ${okFinder.evaluate().length} widgets');
    okFinder.evaluate().forEach((element) {
      print('  ${element.widget.runtimeType}: ${element.widget}');
    });

    // Debug: Try to find TextButton widgets specifically
    print('\nTextButton widgets:');
    tester.widgetList(find.byType(TextButton)).forEach((widget) {
      print('  TextButton: $widget');
    });
  });
}
