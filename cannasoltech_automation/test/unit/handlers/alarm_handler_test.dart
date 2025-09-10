// Unit Tests for AlarmHandler Models
//
// This file contains unit tests for the models within the alarm_handler.dart file,
// including IgnoredAlarmsModel, WarningsModel, and AlarmsModel.
//
// Testing Framework: flutter_test + mocktail
// Coverage Target: ≥85% statement coverage

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:cannasoltech_automation/handlers/alarm_handler.dart';
import 'package:cannasoltech_automation/data_models/device.dart';
import 'package:cannasoltech_automation/data_models/property.dart';

import '../../helpers/mocks.dart';

void main() {
  setUpAll(() {
    registerMockFallbacks();
  });

  group('IgnoredAlarmsModel', () {
    test('should create with all parameters', () {
      final model = IgnoredAlarmsModel(
        flow: true,
        temp: false,
        pressure: true,
        freqLock: false,
        overload: true,
        native: {'test': 'data'},
      );

      expect(model.flow, isTrue);
      expect(model.temp, isFalse);
      expect(model.pressure, isTrue);
      expect(model.freqLock, isFalse);
      expect(model.overload, isTrue);
      expect(model.native, equals({'test': 'data'}));
      expect(model.ignored, isNull);
    });

    test('fromDatabase should correctly parse nested data', () {
      // Arrange
      final data = {
        'flow': true,
        'temp': false,
        'pressure': true,
        'freqLock': false,
        'overload': true,
        'ignored': {
          'flow': false,
          'temp': true,
          'pressure': false,
          'freqLock': true,
          'overload': false,
          'ignored': {},
        },
      };

      // Act
      final model = IgnoredAlarmsModel.fromDatabase(data);

      // Assert
      expect(model.flow, isTrue);
      expect(model.temp, isFalse);
      expect(model.pressure, isTrue);
      expect(model.freqLock, isFalse);
      expect(model.overload, isTrue);
      expect(model.ignored, isNotNull);
      expect(model.ignored!.temp, isTrue);
      expect(model.ignored!.overload, isFalse);
      expect(model.ignored!.ignored, isNull);
    });

    test('fromDatabase should handle missing values with defaults', () {
      final data = <String, dynamic>{};

      final model = IgnoredAlarmsModel.fromDatabase(data);

      expect(model.flow, isFalse);
      expect(model.temp, isFalse);
      expect(model.pressure, isFalse);
      expect(model.freqLock, isFalse);
      expect(model.overload, isFalse);
      expect(model.ignored, isNull);
    });

    test('fromDatabase should handle null ignored data', () {
      final data = {
        'flow': true,
        'ignored': null,
      };

      final model = IgnoredAlarmsModel.fromDatabase(data);

      expect(model.flow, isTrue);
      expect(model.ignored, isNull);
    });

    test('fromDatabase should handle empty ignored data', () {
      final data = {
        'flow': true,
        'ignored': {},
      };

      final model = IgnoredAlarmsModel.fromDatabase(data);

      expect(model.flow, isTrue);
      expect(model.ignored, isNull);
    });
  });

  group('WarningsModel', () {
    test('should create with all parameters', () {
      final model = WarningsModel(
        flow: true,
        pressure: false,
        temp: true,
        native: {'test': 'data'},
      );

      expect(model.flow, isTrue);
      expect(model.pressure, isFalse);
      expect(model.temp, isTrue);
      expect(model.native, equals({'test': 'data'}));
    });

    test('fromDatabase should correctly parse data', () {
      final data = {
        'flow': true,
        'pressure': false,
        'temp': true,
      };

      final model = WarningsModel.fromDatabase(data);

      expect(model.flow, isTrue);
      expect(model.pressure, isFalse);
      expect(model.temp, isTrue);
      expect(model.native, equals(data));
    });

    test('fromDatabase should handle missing values with defaults', () {
      final data = <String, dynamic>{};

      final model = WarningsModel.fromDatabase(data);

      expect(model.flow, isFalse);
      expect(model.pressure, isFalse);
      expect(model.temp, isFalse);
    });
  });

  group('AlarmsModel', () {
    late AlarmsModel alarmsModel;
    late MockDevice mockDevice;
    late MockFireProperty mockProperty;

    setUp(() {
      mockDevice = MockDevice();
      mockProperty = MockFireProperty();
      alarmsModel = AlarmsModel(device: mockDevice);

      // Setup default property behavior
      when(() => mockProperty.value).thenReturn(false);
    });

    test('should create with device', () {
      expect(alarmsModel.device, equals(mockDevice));
      expect(alarmsModel.alarmNames.length, equals(5));
      expect(alarmsModel.alarmNames, contains('flow_alarm'));
      expect(alarmsModel.alarmNames, contains('temp_alarm'));
      expect(alarmsModel.alarmNames, contains('pressure_alarm'));
      expect(alarmsModel.alarmNames, contains('freq_lock_alarm'));
      expect(alarmsModel.alarmNames, contains('overload_alarm'));
    });

    test('should create without device', () {
      final model = AlarmsModel();
      expect(model.device, isNull);
    });

    test('should get warning properties correctly', () {
      alarmsModel.properties['flow_warn'] = mockProperty;
      alarmsModel.properties['temp_warn'] = mockProperty;
      alarmsModel.properties['pressure_warn'] = mockProperty;

      when(() => mockProperty.value).thenReturn(true);

      expect(alarmsModel.flowWarn, isTrue);
      expect(alarmsModel.tempWarn, isTrue);
      expect(alarmsModel.pressureWarn, isTrue);
    });

    test('should get alarm properties correctly', () {
      alarmsModel.properties['flow_alarm'] = mockProperty;
      alarmsModel.properties['temp_alarm'] = mockProperty;
      alarmsModel.properties['pressure_alarm'] = mockProperty;
      alarmsModel.properties['freq_lock_alarm'] = mockProperty;
      alarmsModel.properties['overload_alarm'] = mockProperty;

      when(() => mockProperty.value).thenReturn(true);

      expect(alarmsModel.flowAlarm, isTrue);
      expect(alarmsModel.tempAlarm, isTrue);
      expect(alarmsModel.pressureAlarm, isTrue);
      expect(alarmsModel.freqLockAlarm, isTrue);
      expect(alarmsModel.overloadAlarm, isTrue);
    });

    test('should get ignore alarm properties correctly', () {
      alarmsModel.properties['ign_temp_alarm'] = mockProperty;
      alarmsModel.properties['ign_flow_alarm'] = mockProperty;
      alarmsModel.properties['ign_pressure_alarm'] = mockProperty;
      alarmsModel.properties['ign_overload_alarm'] = mockProperty;
      alarmsModel.properties['ign_freqlock_alarm'] = mockProperty;

      when(() => mockProperty.value).thenReturn(true);

      expect(alarmsModel.ignoreTempAlarm, isTrue);
      expect(alarmsModel.ignoreFlowAlarm, isTrue);
      expect(alarmsModel.ignorePressureAlarm, isTrue);
      expect(alarmsModel.ignoreOverloadAlarm, isTrue);
      expect(alarmsModel.ignoreFreqLockAlarm, isTrue);
    });

    test('should calculate tank alarm active correctly', () {
      final tempProperty = MockFireProperty();
      final ignoreTempProperty = MockFireProperty();
      
      alarmsModel.properties['temp_alarm'] = tempProperty;
      alarmsModel.properties['ign_temp_alarm'] = ignoreTempProperty;

      // Alarm active, not ignored
      when(() => tempProperty.value).thenReturn(true);
      when(() => ignoreTempProperty.value).thenReturn(false);
      expect(alarmsModel.tankAlarmActive, isTrue);

      // Alarm active but ignored
      when(() => ignoreTempProperty.value).thenReturn(true);
      expect(alarmsModel.tankAlarmActive, isFalse);

      // Alarm not active
      when(() => tempProperty.value).thenReturn(false);
      when(() => ignoreTempProperty.value).thenReturn(false);
      expect(alarmsModel.tankAlarmActive, isFalse);
    });

    test('should calculate pump alarm active correctly', () {
      final flowProperty = MockFireProperty();
      final ignoreFlowProperty = MockFireProperty();
      
      alarmsModel.properties['flow_alarm'] = flowProperty;
      alarmsModel.properties['ign_flow_alarm'] = ignoreFlowProperty;

      // Alarm active, not ignored
      when(() => flowProperty.value).thenReturn(true);
      when(() => ignoreFlowProperty.value).thenReturn(false);
      expect(alarmsModel.pumpAlarmActive, isTrue);

      // Alarm active but ignored
      when(() => ignoreFlowProperty.value).thenReturn(true);
      expect(alarmsModel.pumpAlarmActive, isFalse);
    });

    test('should calculate sonic alarm correctly', () {
      final overloadProperty = MockFireProperty();
      final freqLockProperty = MockFireProperty();
      final pressureProperty = MockFireProperty();
      
      alarmsModel.properties['overload_alarm'] = overloadProperty;
      alarmsModel.properties['freq_lock_alarm'] = freqLockProperty;
      alarmsModel.properties['pressure_alarm'] = pressureProperty;

      // No sonic alarms
      when(() => overloadProperty.value).thenReturn(false);
      when(() => freqLockProperty.value).thenReturn(false);
      when(() => pressureProperty.value).thenReturn(false);
      expect(alarmsModel.sonicAlarm, isFalse);

      // Overload alarm
      when(() => overloadProperty.value).thenReturn(true);
      expect(alarmsModel.sonicAlarm, isTrue);

      // Frequency lock alarm
      when(() => overloadProperty.value).thenReturn(false);
      when(() => freqLockProperty.value).thenReturn(true);
      expect(alarmsModel.sonicAlarm, isTrue);

      // Pressure alarm
      when(() => freqLockProperty.value).thenReturn(false);
      when(() => pressureProperty.value).thenReturn(true);
      expect(alarmsModel.sonicAlarm, isTrue);
    });

    test('should identify active alarms correctly', () {
      final flowProperty = MockFireProperty();
      final tempProperty = MockFireProperty();
      
      alarmsModel.properties['flow_alarm'] = flowProperty;
      alarmsModel.properties['temp_alarm'] = tempProperty;
      alarmsModel.properties['pressure_alarm'] = mockProperty;
      alarmsModel.properties['freq_lock_alarm'] = mockProperty;
      alarmsModel.properties['overload_alarm'] = mockProperty;

      when(() => flowProperty.value).thenReturn(true);
      when(() => tempProperty.value).thenReturn(true);
      when(() => mockProperty.value).thenReturn(false);

      expect(alarmsModel.alarmActive, isTrue);
      expect(alarmsModel.activeAlarms, hasLength(2));
      expect(alarmsModel.activeAlarms, containsAll(['flow_alarm', 'temp_alarm']));
    });

    test('should identify idle alarms correctly', () {
      final flowProperty = MockFireProperty();
      final tempProperty = MockFireProperty();
      
      alarmsModel.properties['flow_alarm'] = flowProperty;
      alarmsModel.properties['temp_alarm'] = tempProperty;
      alarmsModel.properties['pressure_alarm'] = mockProperty;
      alarmsModel.properties['freq_lock_alarm'] = mockProperty;
      alarmsModel.properties['overload_alarm'] = mockProperty;

      when(() => flowProperty.value).thenReturn(true);
      when(() => tempProperty.value).thenReturn(false);
      when(() => mockProperty.value).thenReturn(false);

      expect(alarmsModel.idleAlarms, hasLength(4));
      expect(alarmsModel.idleAlarms, containsAll(['temp_alarm', 'pressure_alarm', 'freq_lock_alarm', 'overload_alarm']));
    });

    test('should get alarm name by index', () {
      expect(alarmsModel.getAlarmName(0), equals('flow_alarm'));
      expect(alarmsModel.getAlarmName(1), equals('temp_alarm'));
      expect(alarmsModel.getAlarmName(2), equals('pressure_alarm'));
      expect(alarmsModel.getAlarmName(3), equals('freq_lock_alarm'));
      expect(alarmsModel.getAlarmName(4), equals('overload_alarm'));
    });

    test('should handle invalid alarm index', () {
      expect(alarmsModel.getAlarmName(10), equals(''));
      expect(alarmsModel.getAlarmName(-1), equals(''));
    });

    test('should get alarm index by name', () {
      expect(alarmsModel.getAlarmIndex('flow_alarm'), equals(0));
      expect(alarmsModel.getAlarmIndex('temp_alarm'), equals(1));
      expect(alarmsModel.getAlarmIndex('pressure_alarm'), equals(2));
      expect(alarmsModel.getAlarmIndex('freq_lock_alarm'), equals(3));
      expect(alarmsModel.getAlarmIndex('overload_alarm'), equals(4));
      expect(alarmsModel.getAlarmIndex('unknown_alarm'), equals(-1));
    });

    test('should support alarm time properties', () {
      alarmsModel.flowAlarmTime = const Duration(seconds: 30);
      alarmsModel.tempAlarmTime = const Duration(seconds: 45);
      alarmsModel.pressureAlarmTime = const Duration(seconds: 60);
      alarmsModel.freqLockAlarmTime = const Duration(seconds: 75);
      alarmsModel.overloadAlarmTime = const Duration(seconds: 90);

      expect(alarmsModel.flowAlarmTime, equals(const Duration(seconds: 30)));
      expect(alarmsModel.tempAlarmTime, equals(const Duration(seconds: 45)));
      expect(alarmsModel.pressureAlarmTime, equals(const Duration(seconds: 60)));
      expect(alarmsModel.freqLockAlarmTime, equals(const Duration(seconds: 75)));
      expect(alarmsModel.overloadAlarmTime, equals(const Duration(seconds: 90)));
    });

    test('should create from database snapshot', () {
      final mockSnapshot = MockDataSnapshot();
      final mockChildSnapshot = MockDataSnapshot();
      final mockRef = MockDatabaseReference();

      when(() => mockSnapshot.value).thenReturn({
        'flow_alarm': false,
        'temp_alarm': true,
        'pressure_alarm': false,
      });

      when(() => mockSnapshot.child(any())).thenReturn(mockChildSnapshot);
      when(() => mockChildSnapshot.ref).thenReturn(mockRef);
      when(() => mockChildSnapshot.value).thenReturn(false);

      final model = AlarmsModel.fromDatabase(mockSnapshot);

      expect(model, isA<AlarmsModel>());
      expect(model.properties, isNotEmpty);
    });
  });
}