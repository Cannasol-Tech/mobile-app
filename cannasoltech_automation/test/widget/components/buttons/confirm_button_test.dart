// Confirm Button Widget Tests
//
// This file contains comprehensive widget tests for the ConfirmButton component.
// Tests verify UI behavior, user interactions, and widget rendering.
//
// Testing Framework: flutter_test + mocktail
// Standards: Follow Cannasol Technologies Flutter testing standards

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cannasoltech_automation/components/buttons/confirm_button.dart';

// Import centralized test helpers
import '../../../helpers/test_utils.dart';

void main() {
  // Setup test environment
  TestEnvironment.setupGroup();

  group('ConfirmButton Widget Tests', () {
    late ProviderMockSetup providerMocks;

    setUp(() {
      providerMocks = MockSetup.createProviderMocks();
    });

    group('Rendering Tests', () {
      testWidgets('should render confirm button with required parameters',
          (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(
          createTestAppWithProviders(
            child: Scaffold(
              body: ConfirmButton(
                color: Colors.blue,
                buttonText: 'Confirm',
                confirmMethod: () {},
                confirmText: 'proceed with this action',
                hero: 'testConfirmButton',
              ),
            ),
            systemDataModel: providerMocks.systemDataModel,
            displayDataModel: providerMocks.displayDataModel,
          ),
        );

        // Assert
        TestAssertions.expectVisible(find.byType(ConfirmButton));
        TestAssertions.expectVisible(find.text('Confirm'));
      });

      testWidgets('should render confirm button with custom text',
          (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(
          createTestAppWithProviders(
            child: Scaffold(
              body: ConfirmButton(
                color: Colors.green,
                buttonText: 'Apply Changes',
                confirmMethod: () {},
                confirmText: 'apply these changes',
                hero: 'applyChangesButton',
              ),
            ),
            systemDataModel: providerMocks.systemDataModel,
            displayDataModel: providerMocks.displayDataModel,
          ),
        );

        // Assert
        TestAssertions.expectVisible(find.text('Apply Changes'));
      });

      testWidgets('should render confirm button with custom color',
          (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(
          createTestAppWithProviders(
            child: Scaffold(
              body: ConfirmButton(
                color: Colors.red,
                buttonText: 'Delete',
                confirmMethod: () {},
                confirmText: 'delete this item',
                hero: 'deleteButton',
              ),
            ),
            systemDataModel: providerMocks.systemDataModel,
            displayDataModel: providerMocks.displayDataModel,
          ),
        );

        // Assert
        TestAssertions.expectVisible(find.text('Delete'));
        final button =
            tester.widget<ElevatedButton>(find.byType(ElevatedButton));
        expect(button.style?.backgroundColor?.resolve({}), equals(Colors.red));
      });
    });

    group('Interaction Tests', () {
      testWidgets('should show confirmation dialog when button is tapped',
          (WidgetTester tester) async {
        // Arrange
        void testMethod() {}

        await tester.pumpWidget(
          createTestAppWithProviders(
            child: Scaffold(
              body: ConfirmButton(
                color: Colors.blue,
                buttonText: 'Test Action',
                confirmMethod: testMethod,
                confirmText: 'perform this test action',
                hero: 'testActionButton',
              ),
            ),
            systemDataModel: providerMocks.systemDataModel,
            displayDataModel: providerMocks.displayDataModel,
          ),
        );

        // Act
        await TestInteractions.tap(tester, find.byType(ConfirmButton));
        await tester.pumpAndSettle();

        // Assert - Should show confirmation dialog
        TestAssertions.expectVisible(find.text('Notice!'));
        TestAssertions.expectVisible(
            find.text('Are you sure you want to perform this test action?'));
        TestAssertions.expectVisible(find.text('Yes'));
        TestAssertions.expectVisible(find.text('No'));
      });

      testWidgets('should show notice dialog when confirmText contains null',
          (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(
          createTestAppWithProviders(
            child: Scaffold(
              body: ConfirmButton(
                color: Colors.red,
                buttonText: 'Remove Device',
                confirmMethod: () {},
                confirmText: 'remove null device',
                hero: 'removeDeviceButton',
              ),
            ),
            systemDataModel: providerMocks.systemDataModel,
            displayDataModel: providerMocks.displayDataModel,
          ),
        );

        // Act
        await TestInteractions.tap(tester, find.byType(ConfirmButton));
        await tester.pumpAndSettle();

        // Assert - Should show notice dialog
        TestAssertions.expectVisible(find.text('No device selected!'));
        TestAssertions.expectVisible(find
            .text('Please select a device from the drop down menu to remove.'));
      });

      testWidgets('should execute confirm method when Yes is pressed in dialog',
          (WidgetTester tester) async {
        // Arrange
        bool methodCalled = false;
        void testMethod() => methodCalled = true;

        await tester.pumpWidget(
          createTestAppWithProviders(
            child: Scaffold(
              body: ConfirmButton(
                color: Colors.green,
                buttonText: 'Execute',
                confirmMethod: testMethod,
                confirmText: 'execute this test',
                hero: 'executeButton',
              ),
            ),
            systemDataModel: providerMocks.systemDataModel,
            displayDataModel: providerMocks.displayDataModel,
          ),
        );

        // Act - Tap button to show dialog
        await TestInteractions.tap(tester, find.byType(ConfirmButton));
        await tester.pumpAndSettle();

        // Tap Yes in the confirmation dialog
        await TestInteractions.tap(tester, find.text('Yes'));
        await tester.pumpAndSettle();

        // Assert
        expect(methodCalled, isTrue);
      });

      testWidgets(
          'should not execute confirm method when No is pressed in dialog',
          (WidgetTester tester) async {
        // Arrange
        bool methodCalled = false;
        void testMethod() => methodCalled = true;

        await tester.pumpWidget(
          createTestAppWithProviders(
            child: Scaffold(
              body: ConfirmButton(
                color: Colors.orange,
                buttonText: 'Cancel Test',
                confirmMethod: testMethod,
                confirmText: 'cancel this test',
                hero: 'cancelButton',
              ),
            ),
            systemDataModel: providerMocks.systemDataModel,
            displayDataModel: providerMocks.displayDataModel,
          ),
        );

        // Act - Tap button to show dialog
        await TestInteractions.tap(tester, find.byType(ConfirmButton));
        await tester.pumpAndSettle();

        // Tap No in the confirmation dialog
        await TestInteractions.tap(tester, find.text('No'));
        await tester.pumpAndSettle();

        // Assert
        expect(methodCalled, isFalse);
      });
    });
  });
}
