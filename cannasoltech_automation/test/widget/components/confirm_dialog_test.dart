// Confirm Dialog Widget Tests
//
// This file contains comprehensive widget tests for the ConfirmDialog component.
// Tests verify UI behavior, user interactions, dialog functionality, and widget rendering.
//
// Testing Framework: flutter_test + mocktail
// Standards: Follow Axovia Flow Flutter testing standards

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:cannasoltech_automation/components/confirm_dialog.dart';

// Import centralized test helpers
import '../../helpers/mocks.dart';
import '../../helpers/test_data.dart';
import '../../helpers/test_utils.dart';

void main() {
  // Setup test environment
  TestEnvironment.setupGroup();

  group('ConfirmDialog Widget Tests', () {
    const testTitle = 'Confirm Action';
    const testMessage = 'Are you sure you want to proceed?';
    const testConfirmText = 'Confirm';
    const testCancelText = 'Cancel';

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
                  builder: (_) => const ConfirmDialog(
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
        TestAssertions.expectVisible(find.byType(ConfirmDialog));
        TestAssertions.expectVisible(find.text(testTitle));
        TestAssertions.expectVisible(find.text(testMessage));
      });

      testWidgets('should render default confirm and cancel buttons', 
          (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(
          createTestApp(
            child: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => showDialog(
                  context: context,
                  builder: (_) => const ConfirmDialog(
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
        TestAssertions.expectVisible(find.text('Confirm'));
        TestAssertions.expectVisible(find.text('Cancel'));
      });

      testWidgets('should render custom button texts when provided', 
          (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(
          createTestApp(
            child: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => showDialog(
                  context: context,
                  builder: (_) => const ConfirmDialog(
                    title: testTitle,
                    message: testMessage,
                    confirmText: testConfirmText,
                    cancelText: testCancelText,
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
        TestAssertions.expectVisible(find.text(testConfirmText));
        TestAssertions.expectVisible(find.text(testCancelText));
      });

      testWidgets('should display warning icon when isDestructive is true', 
          (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(
          createTestApp(
            child: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => showDialog(
                  context: context,
                  builder: (_) => const ConfirmDialog(
                    title: testTitle,
                    message: testMessage,
                    isDestructive: true,
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
    });

    group('Interaction Tests', () {
      testWidgets('should return true when confirm button is tapped', 
          (WidgetTester tester) async {
        // Arrange
        bool? result;

        await tester.pumpWidget(
          createTestApp(
            child: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () async {
                  result = await showDialog<bool>(
                    context: context,
                    builder: (_) => const ConfirmDialog(
                      title: testTitle,
                      message: testMessage,
                    ),
                  );
                },
                child: const Text('Show Dialog'),
              ),
            ),
          ),
        );

        await TestInteractions.tap(tester, find.text('Show Dialog'));
        await tester.pumpAndSettle();

        // Act
        await TestInteractions.tap(tester, find.text('Confirm'));
        await tester.pumpAndSettle();

        // Assert
        expect(result, isTrue);
      });

      testWidgets('should return false when cancel button is tapped', 
          (WidgetTester tester) async {
        // Arrange
        bool? result;

        await tester.pumpWidget(
          createTestApp(
            child: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () async {
                  result = await showDialog<bool>(
                    context: context,
                    builder: (_) => const ConfirmDialog(
                      title: testTitle,
                      message: testMessage,
                    ),
                  );
                },
                child: const Text('Show Dialog'),
              ),
            ),
          ),
        );

        await TestInteractions.tap(tester, find.text('Show Dialog'));
        await tester.pumpAndSettle();

        // Act
        await TestInteractions.tap(tester, find.text('Cancel'));
        await tester.pumpAndSettle();

        // Assert
        expect(result, isFalse);
      });

      testWidgets('should return null when dialog is dismissed by barrier tap', 
          (WidgetTester tester) async {
        // Arrange
        bool? result;

        await tester.pumpWidget(
          createTestApp(
            child: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () async {
                  result = await showDialog<bool>(
                    context: context,
                    builder: (_) => const ConfirmDialog(
                      title: testTitle,
                      message: testMessage,
                    ),
                  );
                },
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

        // Assert
        expect(result, isNull);
      });

      testWidgets('should call onConfirm callback when provided', 
          (WidgetTester tester) async {
        // Arrange
        bool callbackCalled = false;
        void onConfirm() => callbackCalled = true;

        await tester.pumpWidget(
          createTestApp(
            child: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => showDialog(
                  context: context,
                  builder: (_) => ConfirmDialog(
                    title: testTitle,
                    message: testMessage,
                    onConfirm: onConfirm,
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
        await TestInteractions.tap(tester, find.text('Confirm'));
        await tester.pumpAndSettle();

        // Assert
        expect(callbackCalled, isTrue);
      });

      testWidgets('should call onCancel callback when provided', 
          (WidgetTester tester) async {
        // Arrange
        bool callbackCalled = false;
        void onCancel() => callbackCalled = true;

        await tester.pumpWidget(
          createTestApp(
            child: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => showDialog(
                  context: context,
                  builder: (_) => ConfirmDialog(
                    title: testTitle,
                    message: testMessage,
                    onCancel: onCancel,
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
        await TestInteractions.tap(tester, find.text('Cancel'));
        await tester.pumpAndSettle();

        // Assert
        expect(callbackCalled, isTrue);
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
                  builder: (_) => const ConfirmDialog(
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
        final confirmButton = find.text('Confirm');
        final cancelButton = find.text('Cancel');
        
        TestAssertions.expectVisible(confirmButton);
        TestAssertions.expectVisible(cancelButton);
        
        // Check that buttons are properly labeled for screen readers
        final confirmSemantics = tester.getSemantics(confirmButton);
        final cancelSemantics = tester.getSemantics(cancelButton);
        
        expect(confirmSemantics.label, contains('Confirm'));
        expect(cancelSemantics.label, contains('Cancel'));
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
                  builder: (_) => const ConfirmDialog(
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

        // Assert - Check that buttons are focusable
        final confirmButton = find.text('Confirm');
        final cancelButton = find.text('Cancel');
        
        expect(tester.widget<TextButton>(confirmButton).focusNode, isNotNull);
        expect(tester.widget<TextButton>(cancelButton).focusNode, isNotNull);
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
                  builder: (_) => const ConfirmDialog(
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

        TestAssertions.expectVisible(find.byType(ConfirmDialog));
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
                  builder: (_) => const ConfirmDialog(
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

        TestAssertions.expectVisible(find.byType(ConfirmDialog));
      });

      testWidgets('should handle very long text content', 
          (WidgetTester tester) async {
        // Arrange
        const longTitle = 'This is a very long title that should be handled properly by the dialog without causing overflow issues';
        const longMessage = 'This is a very long message that should be handled properly by the dialog without causing overflow or layout issues. It contains multiple sentences and should wrap correctly.';

        // Act
        await tester.pumpWidget(
          createTestApp(
            child: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => showDialog(
                  context: context,
                  builder: (_) => const ConfirmDialog(
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
        TestAssertions.expectVisible(find.byType(ConfirmDialog));
        expect(tester.takeException(), isNull);
      });
    });
  });
}
