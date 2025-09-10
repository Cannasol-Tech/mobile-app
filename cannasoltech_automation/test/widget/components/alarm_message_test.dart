// Alarm Message Widget Tests
//
// This file contains widget tests for the AlarmMessage component.
// Tests verify UI behavior, user interactions, and widget rendering.
//
// Testing Framework: flutter_test + mocktail
// Standards: Follow Axovia Flow Flutter testing standards

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mocktail/mocktail.dart';

import 'package:cannasoltech_automation/components/alarm_message.dart';
import 'package:cannasoltech_automation/providers/system_data_provider.dart';
import 'package:cannasoltech_automation/providers/display_data_provider.dart';

// Import centralized test helpers
import '../../helpers/mocks.dart';
import '../../helpers/test_data.dart';
import '../../helpers/test_utils.dart';

void main() {
  // Setup test environment
  TestEnvironment.setupGroup();

  group('AlarmMessage Widget Tests', () {
    late ProviderMockSetup providerMocks;

    setUp(() {
      providerMocks = MockSetup.createProviderMocks();
    });

    group('Rendering Tests', () {
      testWidgets('should render alarm message when alarm is active',
          (WidgetTester tester) async {
        // Arrange
        when(() => providerMocks.systemDataModel.alarmActive).thenReturn(true);
        when(() => providerMocks.systemDataModel.alarmMessage)
            .thenReturn('Flow alarm active');

        // Act
        await tester.pumpWidget(
          createTestAppWithProviders(
            child: const Scaffold(
              body: AlarmMessage(),
            ),
            systemDataModel: providerMocks.systemDataModel,
            displayDataModel: providerMocks.displayDataModel,
          ),
        );

        // Assert
        TestAssertions.expectVisible(find.byType(AlarmMessage));
        TestAssertions.expectVisible(find.text('Flow alarm active'));
      });

      testWidgets('should not render alarm message when no alarm is active',
          (WidgetTester tester) async {
        // Arrange
        when(() => providerMocks.systemDataModel.alarmActive).thenReturn(false);
        when(() => providerMocks.systemDataModel.alarmMessage).thenReturn('');

        // Act
        await tester.pumpWidget(
          createTestAppWithProviders(
            child: const Scaffold(
              body: AlarmMessage(),
            ),
            systemDataModel: providerMocks.systemDataModel,
            displayDataModel: providerMocks.displayDataModel,
          ),
        );

        // Assert
        TestAssertions.expectNotVisible(find.text('Flow alarm active'));
      });

      testWidgets('should display correct alarm icon',
          (WidgetTester tester) async {
        // Arrange
        when(() => providerMocks.systemDataModel.alarmActive).thenReturn(true);
        when(() => providerMocks.systemDataModel.alarmMessage)
            .thenReturn('Temperature alarm');

        // Act
        await tester.pumpWidget(
          createTestAppWithProviders(
            child: const Scaffold(
              body: AlarmMessage(),
            ),
            systemDataModel: providerMocks.systemDataModel,
            displayDataModel: providerMocks.displayDataModel,
          ),
        );

        // Assert
        TestAssertions.expectVisible(find.byIcon(Icons.warning));
      });
    });

    group('Interaction Tests', () {
      testWidgets('should handle tap interaction on alarm message',
          (WidgetTester tester) async {
        // Arrange
        bool tapped = false;
        when(() => providerMocks.systemDataModel.alarmActive).thenReturn(true);
        when(() => providerMocks.systemDataModel.alarmMessage)
            .thenReturn('Pressure alarm');

        // Act
        await tester.pumpWidget(
          createTestAppWithProviders(
            child: Scaffold(
              body: GestureDetector(
                onTap: () => tapped = true,
                child: const AlarmMessage(),
              ),
            ),
            systemDataModel: providerMocks.systemDataModel,
            displayDataModel: providerMocks.displayDataModel,
          ),
        );

        await TestInteractions.tap(tester, find.byType(AlarmMessage));

        // Assert
        expect(tapped, isTrue);
      });
    });

    group('State Management Tests', () {
      testWidgets('should update when alarm state changes',
          (WidgetTester tester) async {
        // Arrange
        when(() => providerMocks.systemDataModel.alarmActive).thenReturn(false);
        when(() => providerMocks.systemDataModel.alarmMessage).thenReturn('');

        await tester.pumpWidget(
          createTestAppWithProviders(
            child: const Scaffold(
              body: AlarmMessage(),
            ),
            systemDataModel: providerMocks.systemDataModel,
            displayDataModel: providerMocks.displayDataModel,
          ),
        );

        // Verify no alarm initially
        TestAssertions.expectNotVisible(find.text('System alarm'));

        // Act - Simulate alarm activation
        when(() => providerMocks.systemDataModel.alarmActive).thenReturn(true);
        when(() => providerMocks.systemDataModel.alarmMessage)
            .thenReturn('System alarm');

        // Trigger rebuild
        providerMocks.systemDataModel.notifyListeners();
        await tester.pump();

        // Assert
        TestAssertions.expectVisible(find.text('System alarm'));
      });
    });

    group('Accessibility Tests', () {
      testWidgets('should have proper accessibility labels',
          (WidgetTester tester) async {
        // Arrange
        when(() => providerMocks.systemDataModel.alarmActive).thenReturn(true);
        when(() => providerMocks.systemDataModel.alarmMessage)
            .thenReturn('Critical alarm');

        // Act
        await tester.pumpWidget(
          createTestAppWithProviders(
            child: const Scaffold(
              body: AlarmMessage(),
            ),
            systemDataModel: providerMocks.systemDataModel,
            displayDataModel: providerMocks.displayDataModel,
          ),
        );

        // Assert
        final semantics = tester.getSemantics(find.byType(AlarmMessage));
        expect(semantics.label, contains('alarm'));
      });
    });

    group('Edge Cases', () {
      testWidgets('should handle null alarm message gracefully',
          (WidgetTester tester) async {
        // Arrange
        when(() => providerMocks.systemDataModel.alarmActive).thenReturn(true);
        when(() => providerMocks.systemDataModel.alarmMessage).thenReturn(null);

        // Act & Assert - Should not throw
        await tester.pumpWidget(
          createTestAppWithProviders(
            child: const Scaffold(
              body: AlarmMessage(),
            ),
            systemDataModel: providerMocks.systemDataModel,
            displayDataModel: providerMocks.displayDataModel,
          ),
        );

        TestAssertions.expectVisible(find.byType(AlarmMessage));
      });

      testWidgets('should handle empty alarm message',
          (WidgetTester tester) async {
        // Arrange
        when(() => providerMocks.systemDataModel.alarmActive).thenReturn(true);
        when(() => providerMocks.systemDataModel.alarmMessage).thenReturn('');

        // Act
        await tester.pumpWidget(
          createTestAppWithProviders(
            child: const Scaffold(
              body: AlarmMessage(),
            ),
            systemDataModel: providerMocks.systemDataModel,
            displayDataModel: providerMocks.displayDataModel,
          ),
        );

        // Assert
        TestAssertions.expectVisible(find.byType(AlarmMessage));
      });

      testWidgets('should handle very long alarm messages',
          (WidgetTester tester) async {
        // Arrange
        const longMessage =
            'This is a very long alarm message that should be handled properly by the widget without causing overflow or layout issues';
        when(() => providerMocks.systemDataModel.alarmActive).thenReturn(true);
        when(() => providerMocks.systemDataModel.alarmMessage)
            .thenReturn(longMessage);

        // Act
        await tester.pumpWidget(
          createTestAppWithProviders(
            child: const Scaffold(
              body: AlarmMessage(),
            ),
            systemDataModel: providerMocks.systemDataModel,
            displayDataModel: providerMocks.displayDataModel,
          ),
        );

        // Assert - Should not overflow
        TestAssertions.expectVisible(find.byType(AlarmMessage));
        expect(tester.takeException(), isNull);
      });
    });
  });
}
