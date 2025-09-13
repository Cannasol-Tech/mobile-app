// Unit Tests for SystemDataModel Provider
//
// Tests the core business logic of the SystemDataModel provider including
// initialization, state management, timer handling, and device management.
//
// Testing Framework: flutter_test + mocktail
// Coverage Target: ≥85% statement coverage
// Mocking: Permitted for external dependencies

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:cannasoltech_automation/providers/system_data_provider.dart';
import 'package:cannasoltech_automation/shared/constants.dart';

import '../../helpers/mocks.dart';

void main() {
  // Register fallback values for Mocktail
  setUpAll(() {
    registerMockFallbacks();
  });

  group('SystemIdx Tests', () {
    late SystemIdx systemIdx;

    setUp(() {
      systemIdx = SystemIdx();
    });

    test('should initialize with value 0', () {
      expect(systemIdx.value, equals(0));
      expect(systemIdx.minValue, equals(0));
      expect(systemIdx.maxValue, equals(2));
    });

    test('should increment value when below max', () {
      systemIdx.increment();
      expect(systemIdx.value, equals(1));

      systemIdx.increment();
      expect(systemIdx.value, equals(2));
    });

    test('should not increment beyond max value', () {
      systemIdx.set(2);
      systemIdx.increment();
      expect(systemIdx.value, equals(2));
    });

    test('should decrement value when above min', () {
      systemIdx.set(2);
      systemIdx.decrement();
      expect(systemIdx.value, equals(1));

      systemIdx.decrement();
      expect(systemIdx.value, equals(0));
    });

    test('should not decrement below min value', () {
      systemIdx.set(0);
      systemIdx.decrement();
      expect(systemIdx.value, equals(0));
    });

    test('should set value directly', () {
      systemIdx.set(1);
      expect(systemIdx.value, equals(1));

      systemIdx.set(2);
      expect(systemIdx.value, equals(2));
    });

    test('should initialize and reset to 0', () {
      systemIdx.set(2);
      systemIdx.init();
      expect(systemIdx.value, equals(0));
    });
  });

  group('AlarmTimer Tests', () {
    late AlarmTimer alarmTimer;

    setUp(() {
      alarmTimer = AlarmTimer();
    });

    test('should initialize with default values', () {
      expect(alarmTimer.duration, isNull);
      expect(alarmTimer.latch, isNull);
      expect(alarmTimer.started, isFalse);
      expect(alarmTimer.alarmStartTime, isNull);
    });

    test('should start timer correctly', () {
      alarmTimer.alarmStartTime = const Duration(seconds: 0);
      alarmTimer.start();

      expect(alarmTimer.started, isTrue);
      expect(alarmTimer.duration, isNotNull);
      expect(alarmTimer.latch, isNotNull);
    });

    test('should not start timer if already started', () {
      alarmTimer.alarmStartTime = const Duration(seconds: 0);
      alarmTimer.start();
      final firstLatch = alarmTimer.latch;

      alarmTimer.start(); // Try to start again

      expect(alarmTimer.latch, equals(firstLatch));
    });

    test('should stop timer correctly', () {
      alarmTimer.alarmStartTime = const Duration(seconds: 0);
      alarmTimer.start();
      alarmTimer.stop();

      expect(alarmTimer.started, isFalse);
      expect(alarmTimer.latch, isNull);
    });

    test('should handle stop when not started', () {
      alarmTimer.stop();
      expect(alarmTimer.started, isFalse);
      expect(alarmTimer.latch, isNull);
    });
  });

  group('TimerHandler Tests', () {
    late TimerHandler timerHandler;

    setUp(() {
      timerHandler = TimerHandler();
    });

    test('should initialize with default values', () {
      expect(timerHandler.updateDataTimer, isNull);
      expect(timerHandler.updateSeconds, equals(0.25));
      expect(timerHandler.alarmTimers, isNotNull);
      expect(timerHandler.alarmTimers.length, equals(5));
    });

    test('should contain all required alarm timers', () {
      expect(timerHandler.alarmTimers.containsKey('flow_alarm'), isTrue);
      expect(timerHandler.alarmTimers.containsKey('temp_alarm'), isTrue);
      expect(timerHandler.alarmTimers.containsKey('pressure_alarm'), isTrue);
      expect(timerHandler.alarmTimers.containsKey('freq_lock_alarm'), isTrue);
      expect(timerHandler.alarmTimers.containsKey('overload_alarm'), isTrue);
    });

    test('should have AlarmTimer instances for all alarm types', () {
      final alarmNames = [
        'flow_alarm',
        'temp_alarm',
        'pressure_alarm',
        'freq_lock_alarm',
        'overload_alarm'
      ];

      for (final alarmName in alarmNames) {
        expect(timerHandler.alarmTimers[alarmName], isA<AlarmTimer>());
      }
    });
  });

  group('SystemDataModel Tests', () {
    late SystemDataModel systemDataModel;
    late MockFirebaseAuth mockFirebaseAuth;

    setUp(() {
      systemDataModel = SystemDataModel();
      mockFirebaseAuth = MockFirebaseAuth();
    });

    test('should initialize with default values', () {
      expect(systemDataModel.activeDevice, isNull);
      expect(systemDataModel.needsAcceptTaC, isFalse);
      expect(systemDataModel.isPasswordVisible, isFalse);
      expect(systemDataModel.alarmFlash, isFalse);
      expect(systemDataModel.activeDeviceState, equals(INIT));
    });

    test('should have correct run page mappings', () {
      expect(systemDataModel.currentRunPageMap.containsKey(RESET), isTrue);
      expect(systemDataModel.currentRunPageMap.containsKey(INIT), isTrue);
      expect(systemDataModel.currentRunPageMap.containsKey(WARM_UP), isTrue);
      expect(systemDataModel.currentRunPageMap.containsKey(RUNNING), isTrue);
      expect(systemDataModel.currentRunPageMap.containsKey(ALARM), isTrue);
      expect(systemDataModel.currentRunPageMap.containsKey(FINISHED), isTrue);
      expect(systemDataModel.currentRunPageMap.containsKey(COOL_DOWN), isTrue);
    });

    test('should initialize controllers and handlers properly', () {
      expect(systemDataModel.textControllers, isNotNull);
      expect(systemDataModel.toggleControllers, isNotNull);
      expect(systemDataModel.userHandler, isNotNull);
      expect(systemDataModel.devices, isNotNull);
    });

    test('should update Terms and Conditions acceptance correctly', () {
      // Initial state
      expect(systemDataModel.needsAcceptTaC, isFalse);

      // Simulate user doesn't accept ToC by calling updateNeedsAcceptTaC 10 times
      for (int i = 0; i < 10; i++) {
        systemDataModel.updateNeedsAcceptTaC();
      }

      expect(systemDataModel.needsAcceptTaC, isTrue);
    });

    test('should handle current run page updates with no active device', () {
      systemDataModel.updateCurrentRunPage();
      expect(systemDataModel.currentRunPage,
          equals(systemDataModel.currentRunPageMap[RESET]));
    });

    test('should update alarm flash state correctly', () {
      // Initially no alarm flash
      expect(systemDataModel.alarmFlash, isFalse);

      // Test with no active device - should not crash
      systemDataModel.updateAlarmFlash();
      expect(systemDataModel.alarmFlash, isFalse);
    });

    test('should handle data controller updates with null device', () {
      // Should not crash when updating with null device
      systemDataModel.updateDataControllers(null);
      expect(systemDataModel.activeDevice, isNull);
    });

    test('should handle alarm timer updates with no active device', () {
      // Should return early when no active device
      systemDataModel.updateAlarmTimers();
      // Test passes if no exception is thrown
    });

    test('should provide screen utility methods', () {
      // Create a minimal BuildContext for testing
      // Note: In a real test environment, you'd need a proper BuildContext
      // For now, we'll test the existence of these methods
      expect(systemDataModel.display, isA<Function>());
      expect(systemDataModel.screenHeight, isA<Function>());
      expect(systemDataModel.screenWidth, isA<Function>());
    });

    test('should manage device selection correctly', () {
      const testDeviceName = 'test-device-123';

      // Should handle device selection when user handler is available
      systemDataModel.setSelectedDeviceFromName(testDeviceName);

      // Verify the method doesn't crash with empty device name
      systemDataModel.setSelectedDeviceFromName('');
    });

    test('should start and stop update data timer', () {
      // Test timer initialization
      systemDataModel.startUpdateDataTimer();
      expect(systemDataModel.updatingData, isNotNull);

      // Test timer cleanup
      systemDataModel.stopUpdateDataTimer();
    });

    test('should handle password visibility toggle', () {
      expect(systemDataModel.isPasswordVisible, isFalse);
      systemDataModel.togglePWVis();
      expect(systemDataModel.isPasswordVisible, isTrue);
      systemDataModel.togglePWVis();
      expect(systemDataModel.isPasswordVisible, isFalse);
    });

    test('should set bottom navigation pages', () {
      systemDataModel.setBottomNavPages();
      expect(systemDataModel.bottomNavPages, isNotEmpty);
      expect(systemDataModel.bottomNavPages.length, greaterThan(0));
    });

    test('should handle disposal correctly', () {
      systemDataModel.init();
      systemDataModel.dispose();
      // Test passes if disposal doesn't throw exceptions
    });

    test('should handle run page title access', () {
      expect(systemDataModel.runPageTitle, isNotNull);
      expect(systemDataModel.runPageTitle, isA<String>());
    });

    test('should manage alarm count for flashing correctly', () {
      // Test that alarm flash counter resets properly
      expect(systemDataModel.alarmFlash, isFalse);

      // Call multiple times to test the counter logic
      for (int i = 0; i < 5; i++) {
        systemDataModel.updateAlarmFlash();
      }

      // Should still be false since no active device with alarms
      expect(systemDataModel.alarmFlash, isFalse);
    });

    test('should handle registered device status access', () {
      expect(systemDataModel.registeredDeviceStatus, isNotNull);
      expect(
          systemDataModel.registeredDeviceStatus, isA<Map<String, String>>());
    });

    test('should manage authentication state changes', () {
      // The model should have an auth listener
      expect(systemDataModel.authStateChanges, isNotNull);
    });

    test('should handle Terms and Conditions counter reset', () {
      // Test the TaC acceptance logic
      systemDataModel.updateNeedsAcceptTaC();

      // Multiple calls should increment counter but not immediately trigger
      for (int i = 0; i < 5; i++) {
        systemDataModel.updateNeedsAcceptTaC();
      }

      // Should not need TaC yet (less than 10 calls)
      expect(systemDataModel.needsAcceptTaC, isFalse);
    });
  });
}
