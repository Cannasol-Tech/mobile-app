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

    setUp(() {
      mockAuth = MockFirebaseAuth();
      mockUserHandler = MockUserHandler();
      mockDatabase = MockFirebaseDatabase();

      systemDataModel = SystemDataModel();

      // Setup basic mocks
      when(() => mockAuth.authStateChanges()).thenAnswer(
        (_) => Stream.value(null),
      );
      when(() => mockUserHandler.initialized).thenReturn(false);
      when(() => mockUserHandler.initialize()).thenAnswer((_) async {});
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

    test('should update alarm flash correctly', () {
      systemDataModel.updateAlarmFlash();

      // With no active device, alarm flash should remain false
      expect(systemDataModel.alarmFlash, isFalse);
    });

    test('should handle data controllers update with null device', () {
      systemDataModel.updateDataControllers(null);

      expect(systemDataModel.activeDevice, isNull);
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
