// Notice Dialog Widget Tests
//
// This file contains comprehensive widget tests for the NoticeDialog component.
// Tests verify UI behavior, user interactions, dialog functionality, and widget rendering.
//
// Testing Framework: flutter_test + mocktail
// Standards: Follow Axovia Flow Flutter testing standards

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cannasoltech_automation/components/notice_dialog.dart';

// Import centralized test helpers
import '../../helpers/test_utils.dart';

void main() {
  // Setup test environment
  TestEnvironment.setupGroup();

  group('NoticeDialog Widget Tests', () {
    const testTitle = 'Important Notice';
    const testMessage = 'This is an important system notification.';
    const testButtonText = 'Acknowledge';

    group('Rendering Tests', () {
      testWidgets('should render dialog with title and message',
          (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(
          createTestApp(
            child: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => showDialog(
                  context: context,
                  builder: (_) => const NoticeDialog(
                    title: testTitle,
                    message: testMessage,
                  ),
                ),
                child: const Text('Show Dialog'),
              ),
            ),
          ),
        );

        await TestInteractions.tap(tester, find.text('Show Dialog'));
        await tester.pumpAndSettle();

        // Assert
        TestAssertions.expectVisible(find.byType(NoticeDialog));
        TestAssertions.expectVisible(find.text(testTitle));
        TestAssertions.expectVisible(find.text(testMessage));
      });

      testWidgets('should render default OK button',
          (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(
          createTestApp(
            child: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => showDialog(
                  context: context,
                  builder: (_) => const NoticeDialog(
                    title: testTitle,
                    message: testMessage,
                  ),
                ),
                child: const Text('Show Dialog'),
              ),
            ),
          ),
        );

        await TestInteractions.tap(tester, find.text('Show Dialog'));
        await tester.pumpAndSettle();

        // Assert
        TestAssertions.expectVisible(find.text('OK'));
      });

      testWidgets('should render custom button text when provided',
          (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(
          createTestApp(
            child: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => showDialog(
                  context: context,
                  builder: (_) => const NoticeDialog(
                    title: testTitle,
                    message: testMessage,
                    buttonText: testButtonText,
                  ),
                ),
                child: const Text('Show Dialog'),
              ),
            ),
          ),
        );

        await TestInteractions.tap(tester, find.text('Show Dialog'));
        await tester.pumpAndSettle();

        // Assert
        TestAssertions.expectVisible(find.text(testButtonText));
      });

      testWidgets('should display info icon by default',
          (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(
          createTestApp(
            child: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => showDialog(
                  context: context,
                  builder: (_) => const NoticeDialog(
                    title: testTitle,
                    message: testMessage,
                  ),
                ),
                child: const Text('Show Dialog'),
              ),
            ),
          ),
        );

        await TestInteractions.tap(tester, find.text('Show Dialog'));
        await tester.pumpAndSettle();

        // Assert
        TestAssertions.expectVisible(find.byIcon(Icons.info));
      });

      testWidgets('should display warning icon when type is warning',
          (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(
          createTestApp(
            child: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => showDialog(
                  context: context,
                  builder: (_) => const NoticeDialog(
                    title: testTitle,
                    message: testMessage,
                    type: NoticeType.warning,
                  ),
                ),
                child: const Text('Show Dialog'),
              ),
            ),
          ),
        );

        await TestInteractions.tap(tester, find.text('Show Dialog'));
        await tester.pumpAndSettle();

        // Assert
        TestAssertions.expectVisible(find.byIcon(Icons.warning));
      });

      testWidgets('should display error icon when type is error',
          (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(
          createTestApp(
            child: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => showDialog(
                  context: context,
                  builder: (_) => const NoticeDialog(
                    title: testTitle,
                    message: testMessage,
                    type: NoticeType.error,
                  ),
                ),
                child: const Text('Show Dialog'),
              ),
            ),
          ),
        );

        await TestInteractions.tap(tester, find.text('Show Dialog'));
        await tester.pumpAndSettle();

        // Assert
        TestAssertions.expectVisible(find.byIcon(Icons.error));
      });

      testWidgets('should display success icon when type is success',
          (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(
          createTestApp(
            child: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => showDialog(
                  context: context,
                  builder: (_) => const NoticeDialog(
                    title: testTitle,
                    message: testMessage,
                    type: NoticeType.success,
                  ),
                ),
                child: const Text('Show Dialog'),
              ),
            ),
          ),
        );

        await TestInteractions.tap(tester, find.text('Show Dialog'));
        await tester.pumpAndSettle();

        // Assert
        TestAssertions.expectVisible(find.byIcon(Icons.check_circle));
      });
    });

    group('Interaction Tests', () {
      testWidgets('should close dialog when OK button is tapped',
          (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(
          createTestApp(
            child: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => showDialog(
                  context: context,
                  builder: (_) => const NoticeDialog(
                    title: testTitle,
                    message: testMessage,
                  ),
                ),
                child: const Text('Show Dialog'),
              ),
            ),
          ),
        );

        await TestInteractions.tap(tester, find.text('Show Dialog'));
        await tester.pumpAndSettle();

        // Verify dialog is visible
        TestAssertions.expectVisible(find.byType(NoticeDialog));

        // Act
        await TestInteractions.tap(tester, find.text('OK'));
        await tester.pumpAndSettle();

        // Assert
        TestAssertions.expectNotVisible(find.byType(NoticeDialog));
      });

      testWidgets('should call onPressed callback when provided',
          (WidgetTester tester) async {
        // Arrange
        bool callbackCalled = false;
        void onPressed() => callbackCalled = true;

        await tester.pumpWidget(
          createTestApp(
            child: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => showDialog(
                  context: context,
                  builder: (_) => NoticeDialog(
                    title: testTitle,
                    message: testMessage,
                    onPressed: onPressed,
                  ),
                ),
                child: const Text('Show Dialog'),
              ),
            ),
          ),
        );

        await TestInteractions.tap(tester, find.text('Show Dialog'));
        await tester.pumpAndSettle();

        // Act
        await TestInteractions.tap(tester, find.text('OK'));
        await tester.pumpAndSettle();

        // Assert
        expect(callbackCalled, isTrue);
      });

      testWidgets('should close dialog when barrier is tapped',
          (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(
          createTestApp(
            child: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => showDialog(
                  context: context,
                  builder: (_) => const NoticeDialog(
                    title: testTitle,
                    message: testMessage,
                  ),
                ),
                child: const Text('Show Dialog'),
              ),
            ),
          ),
        );

        await TestInteractions.tap(tester, find.text('Show Dialog'));
        await tester.pumpAndSettle();

        // Verify dialog is visible
        TestAssertions.expectVisible(find.byType(NoticeDialog));

        // Act - Tap outside dialog (barrier)
        await tester.tapAt(const Offset(10, 10));
        await tester.pumpAndSettle();

        // Assert
        TestAssertions.expectNotVisible(find.byType(NoticeDialog));
      });

      testWidgets('should not close when barrierDismissible is false',
          (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(
          createTestApp(
            child: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) => const NoticeDialog(
                    title: testTitle,
                    message: testMessage,
                  ),
                ),
                child: const Text('Show Dialog'),
              ),
            ),
          ),
        );

        await TestInteractions.tap(tester, find.text('Show Dialog'));
        await tester.pumpAndSettle();

        // Act - Tap outside dialog (barrier)
        await tester.tapAt(const Offset(10, 10));
        await tester.pumpAndSettle();

        // Assert - Dialog should still be visible
        TestAssertions.expectVisible(find.byType(NoticeDialog));
      });
    });

    group('Accessibility Tests', () {
      testWidgets('should have proper semantic labels',
          (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(
          createTestApp(
            child: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => showDialog(
                  context: context,
                  builder: (_) => const NoticeDialog(
                    title: testTitle,
                    message: testMessage,
                  ),
                ),
                child: const Text('Show Dialog'),
              ),
            ),
          ),
        );

        await TestInteractions.tap(tester, find.text('Show Dialog'));
        await tester.pumpAndSettle();

        // Assert
        final okButton = find.text('OK');
        TestAssertions.expectVisible(okButton);

        final semantics = tester.getSemantics(okButton);
        expect(semantics.label, contains('OK'));
      });

      testWidgets('should be accessible via screen reader',
          (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(
          createTestApp(
            child: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => showDialog(
                  context: context,
                  builder: (_) => const NoticeDialog(
                    title: testTitle,
                    message: testMessage,
                  ),
                ),
                child: const Text('Show Dialog'),
              ),
            ),
          ),
        );

        await TestInteractions.tap(tester, find.text('Show Dialog'));
        await tester.pumpAndSettle();

        // Assert
        final dialog = tester.widget<AlertDialog>(find.byType(AlertDialog));
        expect(dialog.title, isNotNull);
        expect(dialog.content, isNotNull);
      });

      testWidgets('should support keyboard navigation',
          (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(
          createTestApp(
            child: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => showDialog(
                  context: context,
                  builder: (_) => const NoticeDialog(
                    title: testTitle,
                    message: testMessage,
                  ),
                ),
                child: const Text('Show Dialog'),
              ),
            ),
          ),
        );

        await TestInteractions.tap(tester, find.text('Show Dialog'));
        await tester.pumpAndSettle();

        // Assert - Check that button is focusable
        // Find TextButton widget directly instead of by text content
        final okButton = find.descendant(
          of: find.byType(TextButton),
          matching: find.text('OK'),
        );
        expect(tester.widget<TextButton>(okButton).focusNode, isNotNull);
      });
    });

    group('Theme and Styling Tests', () {
      testWidgets('should apply correct colors based on notice type',
          (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(
          createTestApp(
            child: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => showDialog(
                  context: context,
                  builder: (_) => const NoticeDialog(
                    title: testTitle,
                    message: testMessage,
                    type: NoticeType.error,
                  ),
                ),
                child: const Text('Show Dialog'),
              ),
            ),
          ),
        );

        await TestInteractions.tap(tester, find.text('Show Dialog'));
        await tester.pumpAndSettle();

        // Assert
        final icon = tester.widget<Icon>(find.byIcon(Icons.error));
        expect(icon.color, equals(Colors.red));
      });

      testWidgets('should handle custom theme colors',
          (WidgetTester tester) async {
        // Arrange
        final customTheme = ThemeData(
          dialogTheme: const DialogTheme(
            backgroundColor: Colors.blue,
            titleTextStyle: TextStyle(color: Colors.white),
          ),
        );

        // Act
        await tester.pumpWidget(
          createTestApp(
            child: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => showDialog(
                  context: context,
                  builder: (_) => const NoticeDialog(
                    title: testTitle,
                    message: testMessage,
                  ),
                ),
                child: const Text('Show Dialog'),
              ),
            ),
            theme: customTheme,
          ),
        );

        await TestInteractions.tap(tester, find.text('Show Dialog'));
        await tester.pumpAndSettle();

        // Assert
        final dialog = tester.widget<AlertDialog>(find.byType(AlertDialog));
        expect(dialog.backgroundColor, equals(Colors.blue));
      });
    });

    group('Edge Cases', () {
      testWidgets('should handle empty title gracefully',
          (WidgetTester tester) async {
        // Act & Assert - Should not throw
        await tester.pumpWidget(
          createTestApp(
            child: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => showDialog(
                  context: context,
                  builder: (_) => const NoticeDialog(
                    title: '',
                    message: testMessage,
                  ),
                ),
                child: const Text('Show Dialog'),
              ),
            ),
          ),
        );

        await TestInteractions.tap(tester, find.text('Show Dialog'));
        await tester.pumpAndSettle();

        TestAssertions.expectVisible(find.byType(NoticeDialog));
      });

      testWidgets('should handle empty message gracefully',
          (WidgetTester tester) async {
        // Act & Assert - Should not throw
        await tester.pumpWidget(
          createTestApp(
            child: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => showDialog(
                  context: context,
                  builder: (_) => const NoticeDialog(
                    title: testTitle,
                    message: '',
                  ),
                ),
                child: const Text('Show Dialog'),
              ),
            ),
          ),
        );

        await TestInteractions.tap(tester, find.text('Show Dialog'));
        await tester.pumpAndSettle();

        TestAssertions.expectVisible(find.byType(NoticeDialog));
      });

      testWidgets('should handle very long content',
          (WidgetTester tester) async {
        // Arrange
        const longTitle =
            'This is a very long title that should be handled properly by the dialog without causing overflow issues';
        const longMessage =
            'This is a very long message that should be handled properly by the dialog without causing overflow or layout issues. It contains multiple sentences and should wrap correctly within the dialog bounds.';

        // Act
        await tester.pumpWidget(
          createTestApp(
            child: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => showDialog(
                  context: context,
                  builder: (_) => const NoticeDialog(
                    title: longTitle,
                    message: longMessage,
                  ),
                ),
                child: const Text('Show Dialog'),
              ),
            ),
          ),
        );

        await TestInteractions.tap(tester, find.text('Show Dialog'));
        await tester.pumpAndSettle();

        // Assert - Should not overflow
        TestAssertions.expectVisible(find.byType(NoticeDialog));
        expect(tester.takeException(), isNull);
      });
    });
  });
}
