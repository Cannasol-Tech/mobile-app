// Alarm Message Widget Tests
//
// This file contains widget tests for the AlarmMessage component.
// Tests verify UI behavior, alarm state management, and widget rendering.
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
import 'package:cannasoltech_automation/data_models/device.dart';
import 'package:cannasoltech_automation/handlers/alarm_handler.dart';

// Import centralized test helpers
import '../../helpers/mocks.dart';
import '../../helpers/test_data.dart';
import '../../helpers/test_utils.dart';

void main() {
  // Setup test environment
  TestEnvironment.setupGroup();

  group('AlarmMessage Widget Tests', () {
    late ProviderMockSetup providerMocks;
    late MockDevice mockDevice;
    late MockAlarmsModel mockAlarms;

    setUp(() {
      providerMocks = MockSetup.createProviderMocks();
      mockDevice = MockDevice();
      mockAlarms = MockAlarmsModel();

      // Setup device with alarms
      when(() => mockDevice.alarms).thenReturn(mockAlarms);
      when(() => providerMocks.systemDataModel.activeDevice)
          .thenReturn(mockDevice);
      when(() => providerMocks.systemDataModel.alarmFlash).thenReturn(false);
    });

    group('AlarmMessage.fromText Factory Tests', () {
      testWidgets('should create Flow alarm message correctly',
          (WidgetTester tester) async {
        // Arrange
        mockAlarms.setAlarmState('flowAlarm', true);
        mockAlarms.setAlarmState('ignoreFlowAlarm', false);
        when(() => providerMocks.systemDataModel.alarmFlash).thenReturn(true);

        // Act
        await tester.pumpWidget(
          createTestAppWithProviders(
            child: Scaffold(
              body: AlarmMessage.fromText('Flow Alarm!'),
            ),
            systemDataModel: providerMocks.systemDataModel,
            displayDataModel: providerMocks.displayDataModel,
          ),
        );

        // Assert
        TestAssertions.expectVisible(find.byType(AlarmMessage));
        TestAssertions.expectVisible(find.text('Flow Alarm!'));
      });

      testWidgets('should create Temperature alarm message correctly',
          (WidgetTester tester) async {
        // Arrange
        mockAlarms.setAlarmState('tempAlarm', true);
        mockAlarms.setAlarmState('ignoreTempAlarm', false);
        when(() => providerMocks.systemDataModel.alarmFlash).thenReturn(true);

        // Act
        await tester.pumpWidget(
          createTestAppWithProviders(
            child: Scaffold(
              body: AlarmMessage.fromText('Temperature Alarm!'),
            ),
            systemDataModel: providerMocks.systemDataModel,
            displayDataModel: providerMocks.displayDataModel,
          ),
        );

        // Assert
        TestAssertions.expectVisible(find.byType(AlarmMessage));
        TestAssertions.expectVisible(find.text('Temperature Alarm!'));
      });

      testWidgets('should create Pressure alarm message correctly',
          (WidgetTester tester) async {
        // Arrange
        mockAlarms.setAlarmState('pressureAlarm', true);
        mockAlarms.setAlarmState('ignorePressureAlarm', false);
        when(() => providerMocks.systemDataModel.alarmFlash).thenReturn(true);

        // Act
        await tester.pumpWidget(
          createTestAppWithProviders(
            child: Scaffold(
              body: AlarmMessage.fromText('Pressure Alarm!'),
            ),
            systemDataModel: providerMocks.systemDataModel,
            displayDataModel: providerMocks.displayDataModel,
          ),
        );

        // Assert
        TestAssertions.expectVisible(find.byType(AlarmMessage));
        TestAssertions.expectVisible(find.text('Pressure Alarm!'));
      });

      testWidgets('should create Overload alarm message correctly',
          (WidgetTester tester) async {
        // Arrange
        mockAlarms.setAlarmState('overloadAlarm', true);
        mockAlarms.setAlarmState('ignoreOverloadAlarm', false);
        when(() => providerMocks.systemDataModel.alarmFlash).thenReturn(true);

        // Act
        await tester.pumpWidget(
          createTestAppWithProviders(
            child: Scaffold(
              body: AlarmMessage.fromText('Overload Alarm!'),
            ),
            systemDataModel: providerMocks.systemDataModel,
            displayDataModel: providerMocks.displayDataModel,
          ),
        );

        // Assert
        TestAssertions.expectVisible(find.byType(AlarmMessage));
        TestAssertions.expectVisible(find.text('Overload Alarm!'));
      });

      testWidgets('should create Frequency Lock alarm message correctly',
          (WidgetTester tester) async {
        // Arrange
        mockAlarms.setAlarmState('freqLockAlarm', true);
        mockAlarms.setAlarmState('ignoreFreqLockAlarm', false);
        when(() => providerMocks.systemDataModel.alarmFlash).thenReturn(true);

        // Act
        await tester.pumpWidget(
          createTestAppWithProviders(
            child: Scaffold(
              body: AlarmMessage.fromText('Frequency Lock Alarm!'),
            ),
            systemDataModel: providerMocks.systemDataModel,
            displayDataModel: providerMocks.displayDataModel,
          ),
        );

        // Assert
        TestAssertions.expectVisible(find.byType(AlarmMessage));
        TestAssertions.expectVisible(find.text('Frequency Lock Alarm!'));
      });
    });

    group('Alarm Flash Behavior Tests', () {
      testWidgets('should show text when alarm is active and flash is true',
          (WidgetTester tester) async {
        // Arrange
        mockAlarms.setAlarmState('flowAlarm', true);
        mockAlarms.setAlarmState('ignoreFlowAlarm', false);
        when(() => providerMocks.systemDataModel.alarmFlash).thenReturn(true);

        // Act
        await tester.pumpWidget(
          createTestAppWithProviders(
            child: Scaffold(
              body: AlarmMessage.fromText('Flow Alarm!'),
            ),
            systemDataModel: providerMocks.systemDataModel,
            displayDataModel: providerMocks.displayDataModel,
          ),
        );

        // Assert
        final textWidget = tester.widget<Text>(find.text('Flow Alarm!'));
        expect(textWidget.style?.color, isNot(equals(Colors.transparent)));
      });

      testWidgets('should hide text when alarm is active but flash is false',
          (WidgetTester tester) async {
        // Arrange
        mockAlarms.setAlarmState('flowAlarm', true);
        mockAlarms.setAlarmState('ignoreFlowAlarm', false);
        when(() => providerMocks.systemDataModel.alarmFlash).thenReturn(false);

        // Act
        await tester.pumpWidget(
          createTestAppWithProviders(
            child: Scaffold(
              body: AlarmMessage.fromText('Flow Alarm!'),
            ),
            systemDataModel: providerMocks.systemDataModel,
            displayDataModel: providerMocks.displayDataModel,
          ),
        );

        // Assert
        final textWidget = tester.widget<Text>(find.text('Flow Alarm!'));
        expect(textWidget.style?.color, equals(Colors.transparent));
      });
    });

    group('Ignore Alarm Tests', () {
      testWidgets('should hide text when alarm is active but ignored',
          (WidgetTester tester) async {
        // Arrange
        mockAlarms.setAlarmState('flowAlarm', true);
        mockAlarms.setAlarmState('ignoreFlowAlarm', true); // Alarm is ignored
        when(() => providerMocks.systemDataModel.alarmFlash).thenReturn(true);

        // Act
        await tester.pumpWidget(
          createTestAppWithProviders(
            child: Scaffold(
              body: AlarmMessage.fromText('Flow Alarm!'),
            ),
            systemDataModel: providerMocks.systemDataModel,
            displayDataModel: providerMocks.displayDataModel,
          ),
        );

        // Assert - Text should be transparent because alarm is ignored
        final textWidget = tester.widget<Text>(find.text('Flow Alarm!'));
        expect(textWidget.style?.color, equals(Colors.transparent));
      });

      testWidgets('should show text when alarm is active and not ignored',
          (WidgetTester tester) async {
        // Arrange
        mockAlarms.setAlarmState('tempAlarm', true);
        mockAlarms.setAlarmState(
            'ignoreTempAlarm', false); // Alarm is not ignored
        when(() => providerMocks.systemDataModel.alarmFlash).thenReturn(true);

        // Act
        await tester.pumpWidget(
          createTestAppWithProviders(
            child: Scaffold(
              body: AlarmMessage.fromText('Temperature Alarm!'),
            ),
            systemDataModel: providerMocks.systemDataModel,
            displayDataModel: providerMocks.displayDataModel,
          ),
        );

        // Assert - Text should be visible because alarm is active and not ignored
        final textWidget = tester.widget<Text>(find.text('Temperature Alarm!'));
        expect(textWidget.style?.color, isNot(equals(Colors.transparent)));
      });
    });

    group('Edge Cases', () {
      testWidgets('should handle no device gracefully',
          (WidgetTester tester) async {
        // Arrange
        when(() => providerMocks.systemDataModel.activeDevice).thenReturn(null);
        when(() => providerMocks.systemDataModel.alarmFlash).thenReturn(true);

        // Act & Assert - Should not throw
        await tester.pumpWidget(
          createTestAppWithProviders(
            child: Scaffold(
              body: AlarmMessage.fromText('Flow Alarm!'),
            ),
            systemDataModel: providerMocks.systemDataModel,
            displayDataModel: providerMocks.displayDataModel,
          ),
        );

        // Should render but with no alarm data
        TestAssertions.expectVisible(find.byType(AlarmMessage));
      });

      testWidgets('should handle alarm state when no alarm is active',
          (WidgetTester tester) async {
        // Arrange
        mockAlarms.setAlarmState('flowAlarm', false);
        mockAlarms.setAlarmState('ignoreFlowAlarm', false);
        when(() => providerMocks.systemDataModel.alarmFlash).thenReturn(true);

        // Act
        await tester.pumpWidget(
          createTestAppWithProviders(
            child: Scaffold(
              body: AlarmMessage.fromText('Flow Alarm!'),
            ),
            systemDataModel: providerMocks.systemDataModel,
            displayDataModel: providerMocks.displayDataModel,
          ),
        );

        // Assert - Text should be transparent because no alarm is active
        final textWidget = tester.widget<Text>(find.text('Flow Alarm!'));
        expect(textWidget.style?.color, equals(Colors.transparent));
      });
    });

    group('AlarmMessageDb Tests', () {
      test('should create correct alarm messages', () {
        // Arrange & Act
        final alarmDb = AlarmMessageDb();

        // Assert
        expect(alarmDb.flow, isA<AlarmMessage>());
        expect(alarmDb.temp, isA<AlarmMessage>());
        expect(alarmDb.pressure, isA<AlarmMessage>());
        expect(alarmDb.overload, isA<AlarmMessage>());
        expect(alarmDb.freqLock, isA<AlarmMessage>());
      });

      test('should return correct sonic alarm messages', () {
        // Act
        final sonicAlarms = sonicAlarmMessages();

        // Assert
        expect(sonicAlarms, hasLength(3));
        expect(sonicAlarms, everyElement(isA<AlarmMessage>()));
      });

      test('should return correct pump alarm messages', () {
        // Act
        final pumpAlarms = pumpAlarmMessages();

        // Assert
        expect(pumpAlarms, hasLength(1));
        expect(pumpAlarms, everyElement(isA<AlarmMessage>()));
      });

      test('should return correct tank alarm messages', () {
        // Act
        final tankAlarms = tankAlarmMessages();

        // Assert
        expect(tankAlarms, hasLength(1));
        expect(tankAlarms, everyElement(isA<AlarmMessage>()));
      });
    });
  });
}
