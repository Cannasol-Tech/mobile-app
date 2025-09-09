// Confirm Button Widget Tests
//
// This file contains comprehensive widget tests for the ConfirmButton component.
// Tests verify UI behavior, user interactions, button states, and widget rendering.
//
// Testing Framework: flutter_test + mocktail
// Standards: Follow Axovia Flow Flutter testing standards

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mocktail/mocktail.dart';

import 'package:cannasoltech_automation/components/buttons/confirm_button.dart';
import 'package:cannasoltech_automation/providers/system_data_provider.dart';
import 'package:cannasoltech_automation/providers/display_data_provider.dart';

// Import centralized test helpers
import '../../../helpers/mocks.dart';
import '../../../helpers/test_data.dart';
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
      testWidgets('should render confirm button with default text', 
          (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(
          createTestAppWithProviders(
            child: const Scaffold(
              body: ConfirmButton(),
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
            child: const Scaffold(
              body: ConfirmButton(text: 'Apply Changes'),
            ),
            systemDataModel: providerMocks.systemDataModel,
            displayDataModel: providerMocks.displayDataModel,
          ),
        );

        // Assert
        TestAssertions.expectVisible(find.text('Apply Changes'));
      });

      testWidgets('should display loading indicator when isLoading is true', 
          (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(
          createTestAppWithProviders(
            child: const Scaffold(
              body: ConfirmButton(isLoading: true),
            ),
            systemDataModel: providerMocks.systemDataModel,
            displayDataModel: providerMocks.displayDataModel,
          ),
        );

        // Assert
        TestAssertions.expectVisible(find.byType(CircularProgressIndicator));
        TestAssertions.expectNotVisible(find.text('Confirm'));
      });

      testWidgets('should be disabled when isEnabled is false', 
          (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(
          createTestAppWithProviders(
            child: const Scaffold(
              body: ConfirmButton(isEnabled: false),
            ),
            systemDataModel: providerMocks.systemDataModel,
            displayDataModel: providerMocks.displayDataModel,
          ),
        );

        // Assert
        final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
        expect(button.onPressed, isNull);
      });

      testWidgets('should display correct icon when provided', 
          (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(
          createTestAppWithProviders(
            child: const Scaffold(
              body: ConfirmButton(icon: Icons.check),
            ),
            systemDataModel: providerMocks.systemDataModel,
            displayDataModel: providerMocks.displayDataModel,
          ),
        );

        // Assert
        TestAssertions.expectVisible(find.byIcon(Icons.check));
      });
    });

    group('Interaction Tests', () {
      testWidgets('should call onPressed when button is tapped', 
          (WidgetTester tester) async {
        // Arrange
        bool pressed = false;
        void onPressed() => pressed = true;

        await tester.pumpWidget(
          createTestAppWithProviders(
            child: Scaffold(
              body: ConfirmButton(onPressed: onPressed),
            ),
            systemDataModel: providerMocks.systemDataModel,
            displayDataModel: providerMocks.displayDataModel,
          ),
        );

        // Act
        await TestInteractions.tap(tester, find.byType(ConfirmButton));

        // Assert
        expect(pressed, isTrue);
      });

      testWidgets('should not call onPressed when button is disabled', 
          (WidgetTester tester) async {
        // Arrange
        bool pressed = false;
        void onPressed() => pressed = true;

        await tester.pumpWidget(
          createTestAppWithProviders(
            child: Scaffold(
              body: ConfirmButton(
                onPressed: onPressed,
                isEnabled: false,
              ),
            ),
            systemDataModel: providerMocks.systemDataModel,
            displayDataModel: providerMocks.displayDataModel,
          ),
        );

        // Act
        await TestInteractions.tap(tester, find.byType(ConfirmButton));

        // Assert
        expect(pressed, isFalse);
      });

      testWidgets('should not call onPressed when button is loading', 
          (WidgetTester tester) async {
        // Arrange
        bool pressed = false;
        void onPressed() => pressed = true;

        await tester.pumpWidget(
          createTestAppWithProviders(
            child: Scaffold(
              body: ConfirmButton(
                onPressed: onPressed,
                isLoading: true,
              ),
            ),
            systemDataModel: providerMocks.systemDataModel,
            displayDataModel: providerMocks.displayDataModel,
          ),
        );

        // Act
        await TestInteractions.tap(tester, find.byType(ConfirmButton));

        // Assert
        expect(pressed, isFalse);
      });

      testWidgets('should handle rapid taps gracefully', 
          (WidgetTester tester) async {
        // Arrange
        int pressCount = 0;
        void onPressed() => pressCount++;

        await tester.pumpWidget(
          createTestAppWithProviders(
            child: Scaffold(
              body: ConfirmButton(onPressed: onPressed),
            ),
            systemDataModel: providerMocks.systemDataModel,
            displayDataModel: providerMocks.displayDataModel,
          ),
        );

        // Act - Rapid taps
        for (int i = 0; i < 5; i++) {
          await TestInteractions.tap(tester, find.byType(ConfirmButton));
          await tester.pump(const Duration(milliseconds: 10));
        }

        // Assert
        expect(pressCount, equals(5));
      });
    });

    group('State Management Tests', () {
      testWidgets('should update button state when properties change', 
          (WidgetTester tester) async {
        // Arrange
        bool isLoading = false;
        
        await tester.pumpWidget(
          createTestAppWithProviders(
            child: StatefulBuilder(
              builder: (context, setState) => Scaffold(
                body: Column(
                  children: [
                    ConfirmButton(isLoading: isLoading),
                    ElevatedButton(
                      onPressed: () => setState(() => isLoading = !isLoading),
                      child: const Text('Toggle Loading'),
                    ),
                  ],
                ),
              ),
            ),
            systemDataModel: providerMocks.systemDataModel,
            displayDataModel: providerMocks.displayDataModel,
          ),
        );

        // Verify initial state
        TestAssertions.expectVisible(find.text('Confirm'));
        TestAssertions.expectNotVisible(find.byType(CircularProgressIndicator));

        // Act
        await TestInteractions.tap(tester, find.text('Toggle Loading'));
        await tester.pump();

        // Assert
        TestAssertions.expectNotVisible(find.text('Confirm'));
        TestAssertions.expectVisible(find.byType(CircularProgressIndicator));
      });
    });

    group('Accessibility Tests', () {
      testWidgets('should have proper semantic labels', 
          (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(
          createTestAppWithProviders(
            child: const Scaffold(
              body: ConfirmButton(),
            ),
            systemDataModel: providerMocks.systemDataModel,
            displayDataModel: providerMocks.displayDataModel,
          ),
        );

        // Assert
        final semantics = tester.getSemantics(find.byType(ConfirmButton));
        expect(semantics.label, contains('Confirm'));
      });

      testWidgets('should be accessible via screen reader', 
          (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(
          createTestAppWithProviders(
            child: const Scaffold(
              body: ConfirmButton(),
            ),
            systemDataModel: providerMocks.systemDataModel,
            displayDataModel: providerMocks.displayDataModel,
          ),
        );

        // Assert
        final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
        expect(button.child, isNotNull);
      });

      testWidgets('should indicate disabled state to screen readers', 
          (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(
          createTestAppWithProviders(
            child: const Scaffold(
              body: ConfirmButton(isEnabled: false),
            ),
            systemDataModel: providerMocks.systemDataModel,
            displayDataModel: providerMocks.displayDataModel,
          ),
        );

        // Assert
        final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
        expect(button.onPressed, isNull);
      });
    });

    group('Theme and Styling Tests', () {
      testWidgets('should apply custom theme colors', 
          (WidgetTester tester) async {
        // Arrange
        final customTheme = ThemeData(
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
          ),
        );

        // Act
        await tester.pumpWidget(
          createTestAppWithProviders(
            child: const Scaffold(
              body: ConfirmButton(),
            ),
            systemDataModel: providerMocks.systemDataModel,
            displayDataModel: providerMocks.displayDataModel,
            theme: customTheme,
          ),
        );

        // Assert
        final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
        expect(button.style?.backgroundColor?.resolve({}), equals(Colors.green));
      });

      testWidgets('should handle different button sizes', 
          (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(
          createTestAppWithProviders(
            child: const Scaffold(
              body: ConfirmButton(
                width: 200,
                height: 50,
              ),
            ),
            systemDataModel: providerMocks.systemDataModel,
            displayDataModel: providerMocks.displayDataModel,
          ),
        );

        // Assert
        final container = tester.widget<Container>(
          find.ancestor(
            of: find.byType(ElevatedButton),
            matching: find.byType(Container),
          ),
        );
        expect(container.constraints?.maxWidth, equals(200));
        expect(container.constraints?.maxHeight, equals(50));
      });
    });

    group('Edge Cases', () {
      testWidgets('should handle null onPressed gracefully', 
          (WidgetTester tester) async {
        // Act & Assert - Should not throw
        await tester.pumpWidget(
          createTestAppWithProviders(
            child: const Scaffold(
              body: ConfirmButton(onPressed: null),
            ),
            systemDataModel: providerMocks.systemDataModel,
            displayDataModel: providerMocks.displayDataModel,
          ),
        );

        TestAssertions.expectVisible(find.byType(ConfirmButton));
        
        final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
        expect(button.onPressed, isNull);
      });

      testWidgets('should handle empty text gracefully', 
          (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(
          createTestAppWithProviders(
            child: const Scaffold(
              body: ConfirmButton(text: ''),
            ),
            systemDataModel: providerMocks.systemDataModel,
            displayDataModel: providerMocks.displayDataModel,
          ),
        );

        // Assert
        TestAssertions.expectVisible(find.byType(ConfirmButton));
      });

      testWidgets('should handle very long text', 
          (WidgetTester tester) async {
        // Arrange
        const longText = 'This is a very long button text that should be handled properly without causing overflow';

        // Act
        await tester.pumpWidget(
          createTestAppWithProviders(
            child: const Scaffold(
              body: ConfirmButton(text: longText),
            ),
            systemDataModel: providerMocks.systemDataModel,
            displayDataModel: providerMocks.displayDataModel,
          ),
        );

        // Assert - Should not overflow
        TestAssertions.expectVisible(find.byType(ConfirmButton));
        expect(tester.takeException(), isNull);
      });
    });
  });
}
