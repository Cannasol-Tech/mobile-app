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
      final alarmNames = ['flow_alarm', 'temp_alarm', 'pressure_alarm', 'freq_lock_alarm', 'overload_alarm'];
      
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
      expect(systemDataModel.currentRunPage, equals(systemDataModel.currentRunPageMap[RESET]));
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
      const testDeviceId = 'test-device-123';
      
      // Should handle device selection when user handler is available
      systemDataModel.selectDevice(testDeviceId);
      
      // Verify the method doesn't crash with empty device ID
      systemDataModel.selectDevice('');
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
      systemDataModel.togglePasswordVisibility();
      expect(systemDataModel.isPasswordVisible, isTrue);
      systemDataModel.togglePasswordVisibility();
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
      expect(systemDataModel.registeredDeviceStatus, isA<Map<String, String>>());
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
      expect(timerHandler.alarmTimers.containsKey('overload_alarm'), isTrue);
    });

    test('should have AlarmTimer instances for each alarm', () {
      timerHandler.alarmTimers.forEach((key, value) {
        expect(value, isA<AlarmTimer>());
      });
    });
  });

  group('SystemDataModel Tests', () {
    late SystemDataModel systemDataModel;
    late MockFirebaseAuth mockAuth;
    late MockUserHandler mockUserHandler;
    late MockFirebaseDatabase mockDatabase;
    late MockDevice mockDevice;
    late MockStateHandler mockStateHandler;
    late MockAlarmsModel mockAlarmsModel;

    setUp(() {
      mockAuth = MockFirebaseAuth();
      mockUserHandler = MockUserHandler();
      mockDatabase = MockFirebaseDatabase();
      mockDevice = MockDevice();
      mockStateHandler = MockStateHandler();
      mockAlarmsModel = MockAlarmsModel();

      systemDataModel = SystemDataModel();

      // Setup basic mocks
      when(() => mockAuth.authStateChanges()).thenAnswer(
        (_) => Stream.value(null),
      );
      when(() => mockUserHandler.initialized).thenReturn(false);
      when(() => mockUserHandler.initialize()).thenAnswer((_) async {});
      when(() => mockUserHandler.watchedDevices).thenReturn(['test-device-id']);
      when(() => mockUserHandler.selectedDevice).thenReturn('test-device-id');
      when(() => mockUserHandler.doesAcceptTaC).thenReturn(true);
      
      // Setup device mocks
      when(() => mockDevice.name).thenReturn('Test Device');
      when(() => mockDevice.status).thenReturn('ONLINE');
      when(() => mockDevice.state).thenReturn(mockStateHandler);
      when(() => mockDevice.alarms).thenReturn(mockAlarmsModel);
      when(() => mockStateHandler.state).thenReturn(RUNNING);
      when(() => mockAlarmsModel.alarmActive).thenReturn(false);
      when(() => mockAlarmsModel.activeAlarms).thenReturn(<String>[]);
      when(() => mockAlarmsModel.idleAlarms).thenReturn(<String>[]);
    });

    tearDown(() {
      systemDataModel.dispose();
    });

    test('should initialize with default values', () {
      expect(systemDataModel.activeDevice, isNull);
      expect(systemDataModel.activeDeviceState, equals(INIT));
      expect(systemDataModel.isPasswordVisible, isFalse);
      expect(systemDataModel.alarmFlash, isFalse);
      expect(systemDataModel.needsAcceptTaC, isFalse);
      expect(systemDataModel.runPageTitle, equals(RUN_TITLE));
    });

    test('should initialize correctly', () {
      systemDataModel.init();

      expect(systemDataModel.bottomNavPages.length, equals(4));
      // Timer should be started during initialization
      expect(systemDataModel.updatingData, isTrue);
    });

    test('should start update data timer', () {
      systemDataModel.startUpdateDataTimer();
      expect(systemDataModel.updatingData, isTrue);
    });

    test('should stop update data timer', () {
      systemDataModel.startUpdateDataTimer();
      systemDataModel.stopUpdateDataTimer();
      expect(systemDataModel.updatingData, isFalse);
    });

    test('should handle timer restart correctly', () {
      systemDataModel.startUpdateDataTimer();
      expect(systemDataModel.updatingData, isTrue);

      // Starting again should reset the timer
      systemDataModel.startUpdateDataTimer();
      expect(systemDataModel.updatingData, isTrue);
    });

    test('should set bottom nav pages correctly', () {
      systemDataModel.setBottomNavPages();

      expect(systemDataModel.bottomNavPages.length, equals(4));
      expect(systemDataModel.bottomNavPages[0], isA<Widget>());
      expect(systemDataModel.bottomNavPages[1], isA<Widget>());
      expect(systemDataModel.bottomNavPages[2], isA<Widget>());
      expect(systemDataModel.bottomNavPages[3], isA<Widget>());
    });

    test('should update current run page based on device state', () {
      systemDataModel.updateCurrentRunPage();

      // With no active device, should use RESET state page
      expect(systemDataModel.currentRunPage, isNotNull);
    });

    test('should update current run page with active device', () {
      // Setup active device with specific state
      systemDataModel.updateDataControllers(mockDevice);
      
      systemDataModel.updateCurrentRunPage();
      
      expect(systemDataModel.currentRunPage, isNotNull);
      expect(systemDataModel.bottomNavPages[0], equals(systemDataModel.currentRunPage));
    });

    test('should update alarm flash correctly', () {
      systemDataModel.updateAlarmFlash();

      // With no active device, alarm flash should remain false
      expect(systemDataModel.alarmFlash, isFalse);
    });

    test('should update alarm flash with active device and alarm', () {
      // Setup device with active alarm
      when(() => mockAlarmsModel.alarmActive).thenReturn(true);
      systemDataModel.updateDataControllers(mockDevice);
      
      // First few calls should increment counter
      systemDataModel.updateAlarmFlash();
      systemDataModel.updateAlarmFlash();
      expect(systemDataModel.alarmFlash, isFalse);
      
      // Third call should toggle alarm flash
      systemDataModel.updateAlarmFlash();
      expect(systemDataModel.alarmFlash, isTrue);
      
      // Fourth call should toggle again
      systemDataModel.updateAlarmFlash();
      systemDataModel.updateAlarmFlash();
      systemDataModel.updateAlarmFlash();
      expect(systemDataModel.alarmFlash, isFalse);
    });

    test('should handle data controllers update with null device', () {
      systemDataModel.updateDataControllers(null);

      expect(systemDataModel.activeDevice, isNull);
    });

    test('should handle data controllers update with device', () {
      systemDataModel.updateDataControllers(mockDevice);

      expect(systemDataModel.activeDevice, isNotNull);
    });

    test('should handle data controllers update with offline device', () {
      when(() => mockDevice.status).thenReturn('OFFLINE');
      
      systemDataModel.updateDataControllers(mockDevice);
      
      expect(systemDataModel.activeDevice, isNotNull);
    });

    test('should handle device status change from online to offline', () {
      // First set device as online
      when(() => mockDevice.status).thenReturn('ONLINE');
      systemDataModel.updateDataControllers(mockDevice);
      
      // Then change to offline
      final offlineDevice = MockDevice();
      when(() => offlineDevice.name).thenReturn('Test Device');
      when(() => offlineDevice.status).thenReturn('OFFLINE');
      when(() => offlineDevice.state).thenReturn(mockStateHandler);
      when(() => offlineDevice.alarms).thenReturn(mockAlarmsModel);
      
      systemDataModel.updateDataControllers(offlineDevice);
      
      expect(systemDataModel.activeDevice, isNotNull);
    });

    test('should update alarm timers with no active device', () {
      systemDataModel.updateAlarmTimers();
      
      // Should return early when no active device
      expect(systemDataModel.activeDevice, isNull);
    });

    test('should update alarm timers with active alarms', () {
      // Setup device with active alarms
      when(() => mockAlarmsModel.activeAlarms).thenReturn(['flow_alarm', 'temp_alarm']);
      when(() => mockAlarmsModel.idleAlarms).thenReturn(['pressure_alarm']);
      
      final mockAlarmLogs = MockAlarmsModel();
      when(() => mockDevice.alarmLogs).thenReturn(mockAlarmLogs);
      
      systemDataModel.updateDataControllers(mockDevice);
      systemDataModel.updateAlarmTimers();
      
      expect(systemDataModel.activeDevice, isNotNull);
    });

    test('should toggle password visibility correctly', () {
      expect(systemDataModel.isPasswordVisible, isFalse);
      
      systemDataModel.togglePWVis();
      
      // After fixing the bug in togglePWVis, visibility should now be true
      expect(systemDataModel.isPasswordVisible, isTrue);
    });

    test('should set selected device from name', () {
      // Setup mock devices and user handler
      when(() => mockUserHandler.watchedDevices).thenReturn(['device-id-1']);
      when(() => mockUserHandler.setSelectedDeviceId(any())).thenReturn(null);
      
      bool notified = false;
      systemDataModel.addListener(() {
        notified = true;
      });
      
      systemDataModel.setSelectedDeviceFromName('Test Device');
      
      expect(notified, isTrue);
    });

    test('should update needs accept TaC when user does not accept', () {
      when(() => mockUserHandler.doesAcceptTaC).thenReturn(false);
      
      // Call multiple times to trigger TaC requirement
      for (int i = 0; i < 10; i++) {
        systemDataModel.updateNeedsAcceptTaC();
      }
      
      expect(systemDataModel.needsAcceptTaC, isTrue);
    });

    test('should reset TaC count when user accepts', () {
      when(() => mockUserHandler.doesAcceptTaC).thenReturn(true);
      
      systemDataModel.updateNeedsAcceptTaC();
      
      expect(systemDataModel.needsAcceptTaC, isFalse);
    });

    test('should update data when handlers are initialized', () {
      when(() => mockUserHandler.initialized).thenReturn(true);
      
      bool notified = false;
      systemDataModel.addListener(() {
        notified = true;
      });
      
      systemDataModel.updateData();
      
      expect(notified, isTrue);
    });

    test('should initialize handlers when not initialized', () {
      when(() => mockUserHandler.initialized).thenReturn(false);
      
      systemDataModel.updateData();
      
      verify(() => mockUserHandler.initialize()).called(1);
    });

    test('should dispose correctly', () {
      systemDataModel.init();
      systemDataModel.dispose();

      expect(systemDataModel.updatingData, isFalse);
    });

    test('should notify listeners on data update', () {
      bool notified = false;
      systemDataModel.addListener(() {
        notified = true;
      });

      systemDataModel.updateData();

      expect(notified, isTrue);
    });

    test('should handle screen size calculations', () {
      final context = MockBuildContext();
      final mediaQuery = MockMediaQueryData();
      const testSize = Size(375, 667);

      when(() => mediaQuery.size).thenReturn(testSize);
      when(() => MediaQuery.of(context)).thenReturn(mediaQuery);

      expect(systemDataModel.display(context), equals(testSize));
      expect(systemDataModel.screenHeight(context), equals(667));
      expect(systemDataModel.screenWidth(context), equals(375));
    });

    test('should handle getters correctly', () {
      expect(systemDataModel.userHandler, isNotNull);
      expect(systemDataModel.devices, isNotNull);
      expect(systemDataModel.registeredDeviceStatus, isNotNull);
    test('should toggle password visibility correctly', () {
      // Initial state should be false
      expect(systemDataModel.isPasswordVisible, isFalse);

      // Toggle to true
      systemDataModel.togglePWVis();
      expect(systemDataModel.isPasswordVisible, isTrue);

      // Toggle back to false
      systemDataModel.togglePWVis();
      expect(systemDataModel.isPasswordVisible, isFalse);
    });

    test('should update current run page with no active device', () {
      systemDataModel.updateCurrentRunPage();

      expect(systemDataModel.currentRunPage, isNotNull);
      expect(systemDataModel.bottomNavPages[0],
          equals(systemDataModel.currentRunPage));
    });

    test('should update alarm flash with no active device', () {
      systemDataModel.updateAlarmFlash();

      // With no active device, alarm flash should remain false
      expect(systemDataModel.alarmFlash, isFalse);
    });

    test('should clear controllers when device is null', () {
      systemDataModel.updateDataControllers(null);

      expect(systemDataModel.activeDevice, isNull);
    });

    test('should handle null active device in alarm timers', () {
      systemDataModel.updateAlarmTimers();

      // Should not throw any errors
      expect(() => systemDataModel.updateAlarmTimers(), returnsNormally);
    });

    test('should handle dispose without listeners', () {
      systemDataModel.authListener = null;
      systemDataModel.devicesListener = null;

      expect(() => systemDataModel.dispose(), returnsNormally);
      expect(systemDataModel.updatingData, isFalse);
    });

    test('should update needs accept TaC correctly', () {
      final mockUserHandler = MockUserHandler();

      when(() => mockUserHandler.doesAcceptTaC).thenReturn(false);

      systemDataModel.updateNeedsAcceptTaC();

      expect(systemDataModel.needsAcceptTaC, isFalse);
    });

    test('should set needs accept TaC after 10 counts', () {
      final mockUserHandler = MockUserHandler();

      when(() => mockUserHandler.doesAcceptTaC).thenReturn(false);

      // Simulate 10 calls
      for (int i = 0; i < 10; i++) {
        systemDataModel.updateNeedsAcceptTaC();
      }

      expect(systemDataModel.needsAcceptTaC, isTrue);
    });

    test('should reset TaC count when user accepts', () {
      final mockUserHandler = MockUserHandler();

      when(() => mockUserHandler.doesAcceptTaC).thenReturn(true);

      systemDataModel.updateNeedsAcceptTaC();

      expect(systemDataModel.needsAcceptTaC, isFalse);
    });

    test('should get run page title', () {
      expect(systemDataModel.runPageTitle, equals(RUN_TITLE));
    });

    test('should get current run page', () {
      expect(systemDataModel.currentRunPage, isNotNull);
    });

    test('should get is password visible', () {
      expect(systemDataModel.isPasswordVisible, isFalse);
    });

    test('should get alarm flash', () {
      expect(systemDataModel.alarmFlash, isFalse);
    });

    test('should get user handler', () {
      expect(systemDataModel.userHandler, isNotNull);
    });

    test('should get auth state changes stream', () {
      expect(systemDataModel.authStateChanges, isNotNull);
    });

    test('should get bottom nav pages', () {
      expect(systemDataModel.bottomNavPages, isNotNull);
      expect(systemDataModel.bottomNavPages.length, equals(4));
    });

    test('should get needs accept TaC', () {
      expect(systemDataModel.needsAcceptTaC, isFalse);
    });
  });
}
