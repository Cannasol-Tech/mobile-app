// Enhanced Unit Tests for AlarmHandler
//
// Comprehensive tests for alarm management including ignored alarms,
// warnings, active alarms, alarm state tracking, and Firebase integration.
//
// Testing Framework: flutter_test + mocktail
// Coverage Target: ≥85% statement coverage
// Mocking: Permitted for external dependencies (Firebase, Device)

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:cannasoltech_automation/handlers/alarm_handler.dart';
import 'package:cannasoltech_automation/data_models/device.dart';
import 'package:cannasoltech_automation/data_models/property.dart';
import 'package:cannasoltech_automation/shared/types.dart';
import '../../helpers/mocks.dart';
import '../../helpers/test_data.dart';

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    registerMockFallbacks();
  });

  group('IgnoredAlarmsModel Tests', () {
    test('should create IgnoredAlarmsModel with all parameters', () {
      final testData = {
        'flow': true,
        'temp': false,
        'pressure': true,
        'freqLock': false,
        'overload': true,
      };

      final model = IgnoredAlarmsModel(
        flow: true,
        temp: false,
        pressure: true,
        freqLock: false,
        overload: true,
        native: testData,
      );

      expect(model.flow, isTrue);
      expect(model.temp, isFalse);
      expect(model.pressure, isTrue);
      expect(model.freqLock, isFalse);
      expect(model.overload, isTrue);
      expect(model.ignored, isNull);
      expect(model.native, equals(testData));
    });

    test('should create IgnoredAlarmsModel from database with simple data', () {
      final testData = {
        'flow': true,
        'temp': false,
        'pressure': true,
        'freqLock': false,
        'overload': true,
      };

      final model = IgnoredAlarmsModel.fromDatabase(testData);

      expect(model.flow, isTrue);
      expect(model.temp, isFalse);
      expect(model.pressure, isTrue);
      expect(model.freqLock, isFalse);
      expect(model.overload, isTrue);
      expect(model.ignored, isNull);
      expect(model.native, equals(testData));
    });

    test('should create IgnoredAlarmsModel from database with nested data', () {
      final testData = {
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
        },
      };

      final model = IgnoredAlarmsModel.fromDatabase(testData);

      expect(model.flow, isTrue);
      expect(model.temp, isFalse);
      expect(model.pressure, isTrue);
      expect(model.freqLock, isFalse);
      expect(model.overload, isTrue);
      
      expect(model.ignored, isNotNull);
      expect(model.ignored!.flow, isFalse);
      expect(model.ignored!.temp, isTrue);
      expect(model.ignored!.pressure, isFalse);
      expect(model.ignored!.freqLock, isTrue);
      expect(model.ignored!.overload, isFalse);
      expect(model.ignored!.ignored, isNull);
    });

    test('should handle missing fields with defaults in fromDatabase', () {
      final testData = {
        'flow': true,
        // Missing other fields should default to false
      };

      final model = IgnoredAlarmsModel.fromDatabase(testData);

      expect(model.flow, isTrue);
      expect(model.temp, isFalse);
      expect(model.pressure, isFalse);
      expect(model.freqLock, isFalse);
      expect(model.overload, isFalse);
      expect(model.ignored, isNull);
    });

    test('should handle empty nested ignored data', () {
      final testData = {
        'flow': true,
        'temp': false,
        'pressure': true,
        'freqLock': false,
        'overload': true,
        'ignored': {}, // Empty nested data
      };

      final model = IgnoredAlarmsModel.fromDatabase(testData);

      expect(model.ignored, isNull); // Should be null for empty nested data
    });

    test('should handle null nested ignored data', () {
      final testData = {
        'flow': true,
        'temp': false,
        'pressure': true,
        'freqLock': false,
        'overload': true,
        'ignored': null,
      };

      final model = IgnoredAlarmsModel.fromDatabase(testData);

      expect(model.ignored, isNull);
    });

    test('should handle deeply nested ignored data', () {
      final testData = {
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
          'ignored': {
            'flow': true,
            'temp': false,
            'pressure': true,
            'freqLock': false,
            'overload': true,
          },
        },
      };

      final model = IgnoredAlarmsModel.fromDatabase(testData);

      expect(model.ignored, isNotNull);
      expect(model.ignored!.ignored, isNotNull);
      expect(model.ignored!.ignored!.flow, isTrue);
      expect(model.ignored!.ignored!.ignored, isNull);
    });
  });

  group('WarningsModel Tests', () {
    test('should create WarningsModel with all parameters', () {
      final testData = {
        'flow': true,
        'pressure': false,
        'temp': true,
      };

      final model = WarningsModel(
        flow: true,
        pressure: false,
        temp: true,
        native: testData,
      );

      expect(model.flow, isTrue);
      expect(model.pressure, isFalse);
      expect(model.temp, isTrue);
      expect(model.native, equals(testData));
    });

    test('should create WarningsModel from database', () {
      final testData = {
        'flow': true,
        'pressure': false,
        'temp': true,
      };

      final model = WarningsModel.fromDatabase(testData);

      expect(model.flow, isTrue);
      expect(model.pressure, isFalse);
      expect(model.temp, isTrue);
      expect(model.native, equals(testData));
    });

    test('should handle all warning combinations', () {
      final testCases = [
        {'flow': true, 'pressure': true, 'temp': true},
        {'flow': false, 'pressure': false, 'temp': false},
        {'flow': true, 'pressure': false, 'temp': true},
        {'flow': false, 'pressure': true, 'temp': false},
      ];

      for (final testData in testCases) {
        final model = WarningsModel.fromDatabase(testData);
        
        expect(model.flow, equals(testData['flow']));
        expect(model.pressure, equals(testData['pressure']));
        expect(model.temp, equals(testData['temp']));
      }
    });
  });

  group('AlarmsModel Constructor and Factory Tests', () {
    late MockDevice mockDevice;
    late MockDataSnapshot mockSnapshot;
    late MockDatabaseReference mockDatabaseRef;

    setUp(() {
      mockDevice = MockDevice();
      mockSnapshot = MockDataSnapshot();
      mockDatabaseRef = MockDatabaseReference();

      when(() => mockDevice.name).thenReturn('Test Device');
      when(() => mockSnapshot.value).thenReturn({'test': 'data'});
      when(() => mockSnapshot.child(any())).thenReturn(mockSnapshot);
      when(() => mockSnapshot.ref).thenReturn(mockDatabaseRef);
    });

    test('should create AlarmsModel with device', () {
      final model = AlarmsModel(device: mockDevice);

      expect(model.device, equals(mockDevice));
      expect(model.alarmNames, hasLength(5));
      expect(model.alarmNames, contains('flow_alarm'));
      expect(model.alarmNames, contains('temp_alarm'));
      expect(model.alarmNames, contains('pressure_alarm'));
      expect(model.alarmNames, contains('freq_lock_alarm'));
      expect(model.alarmNames, contains('overload_alarm'));
    });

    test('should create AlarmsModel without device', () {
      final model = AlarmsModel();

      expect(model.device, isNull);
      expect(model.alarmNames, hasLength(5));
    });

    test('should create AlarmsModel from database snapshot', () {
      final testData = {
        'flow_alarm': {'value': true},
        'temp_alarm': {'value': false},
        'pressure_alarm': {'value': true},
        'freq_lock_alarm': {'value': false},
        'overload_alarm': {'value': true},
      };

      when(() => mockSnapshot.value).thenReturn(testData);
      when(() => mockSnapshot.children).thenReturn([
        mockSnapshot,
        mockSnapshot,
        mockSnapshot,
        mockSnapshot,
        mockSnapshot,
      ]);

      final model = AlarmsModel.fromDatabase(mockSnapshot);

      expect(model, isNotNull);
      expect(model.alarmNames, hasLength(5));
    });
  });

  group('AlarmsModel Alarm Property Tests', () {
    late AlarmsModel alarmsModel;
    late MockProperty mockProperty;

    setUp(() {
      alarmsModel = AlarmsModel();
      mockProperty = MockProperty();
      
      // Setup properties map with mock properties
      alarmsModel.properties = {
        'flow_alarm': mockProperty,
        'temp_alarm': mockProperty,
        'pressure_alarm': mockProperty,
        'freq_lock_alarm': mockProperty,
        'overload_alarm': mockProperty,
        'flow_warn': mockProperty,
        'temp_warn': mockProperty,
        'pressure_warn': mockProperty,
        'ign_flow_alarm': mockProperty,
        'ign_temp_alarm': mockProperty,
        'ign_pressure_alarm': mockProperty,
        'ign_overload_alarm': mockProperty,
        'ign_freqlock_alarm': mockProperty,
      };
    });

    test('should get alarm states correctly', () {
      when(() => mockProperty.value).thenReturn(true);

      expect(alarmsModel.flowAlarm, isTrue);
      expect(alarmsModel.tempAlarm, isTrue);
      expect(alarmsModel.pressureAlarm, isTrue);
      expect(alarmsModel.freqLockAlarm, isTrue);
      expect(alarmsModel.overloadAlarm, isTrue);
    });

    test('should get warning states correctly', () {
      when(() => mockProperty.value).thenReturn(false);

      expect(alarmsModel.flowWarn, isFalse);
      expect(alarmsModel.tempWarn, isFalse);
      expect(alarmsModel.pressureWarn, isFalse);
    });

    test('should get ignore alarm states correctly', () {
      when(() => mockProperty.value).thenReturn(true);

      expect(alarmsModel.ignoreFlowAlarm, isTrue);
      expect(alarmsModel.ignoreTempAlarm, isTrue);
      expect(alarmsModel.ignorePressureAlarm, isTrue);
      expect(alarmsModel.ignoreOverloadAlarm, isTrue);
      expect(alarmsModel.ignoreFreqLockAlarm, isTrue);
    });

    test('should calculate tank alarm active correctly', () {
      // Setup temp alarm as true and ignore as false
      final tempAlarmProperty = MockProperty();
      final ignoreTempProperty = MockProperty();
      
      when(() => tempAlarmProperty.value).thenReturn(true);
      when(() => ignoreTempProperty.value).thenReturn(false);
      
      alarmsModel.properties['temp_alarm'] = tempAlarmProperty;
      alarmsModel.properties['ign_temp_alarm'] = ignoreTempProperty;

      expect(alarmsModel.tankAlarmActive, isTrue);

      // Test with ignore enabled
      when(() => ignoreTempProperty.value).thenReturn(true);
      expect(alarmsModel.tankAlarmActive, isFalse);
    });

    test('should calculate pump alarm active correctly', () {
      // Setup flow alarm as true and ignore as false
      final flowAlarmProperty = MockProperty();
      final ignoreFlowProperty = MockProperty();
      
      when(() => flowAlarmProperty.value).thenReturn(true);
      when(() => ignoreFlowProperty.value).thenReturn(false);
      
      alarmsModel.properties['flow_alarm'] = flowAlarmProperty;
      alarmsModel.properties['ign_flow_alarm'] = ignoreFlowProperty;

      expect(alarmsModel.pumpAlarmActive, isTrue);

      // Test with ignore enabled
      when(() => ignoreFlowProperty.value).thenReturn(true);
      expect(alarmsModel.pumpAlarmActive, isFalse);
    });

    test('should calculate sonic alarm correctly', () {
      final overloadProperty = MockProperty();
      final freqLockProperty = MockProperty();
      final pressureProperty = MockProperty();
      
      when(() => overloadProperty.value).thenReturn(true);
      when(() => freqLockProperty.value).thenReturn(false);
      when(() => pressureProperty.value).thenReturn(true);
      
      alarmsModel.properties['overload_alarm'] = overloadProperty;
      alarmsModel.properties['freq_lock_alarm'] = freqLockProperty;
      alarmsModel.properties['pressure_alarm'] = pressureProperty;

      expect(alarmsModel.sonicAlarm, isTrue); // At least one sonic alarm is true
      
      // Test with all false
      when(() => overloadProperty.value).thenReturn(false);
      when(() => pressureProperty.value).thenReturn(false);
      expect(alarmsModel.sonicAlarm, isFalse);
    });

    test('should calculate sonic alarm active correctly', () {
      final overloadProperty = MockProperty();
      final ignoreOverloadProperty = MockProperty();
      final freqLockProperty = MockProperty();
      final ignoreFreqLockProperty = MockProperty();
      final pressureProperty = MockProperty();
      final ignorePressureProperty = MockProperty();
      
      when(() => overloadProperty.value).thenReturn(true);
      when(() => ignoreOverloadProperty.value).thenReturn(false);
      when(() => freqLockProperty.value).thenReturn(false);
      when(() => ignoreFreqLockProperty.value).thenReturn(false);
      when(() => pressureProperty.value).thenReturn(false);
      when(() => ignorePressureProperty.value).thenReturn(false);
      
      alarmsModel.properties = {
        'overload_alarm': overloadProperty,
        'ign_overload_alarm': ignoreOverloadProperty,
        'freq_lock_alarm': freqLockProperty,
        'ign_freqlock_alarm': ignoreFreqLockProperty,
        'pressure_alarm': pressureProperty,
        'ign_pressure_alarm': ignorePressureProperty,
      };

      expect(alarmsModel.sonicAlarmActive, isTrue); // Overload alarm is active and not ignored
    });
  });

  group('AlarmsModel Ignore Alarm Setters Tests', () {
    late AlarmsModel alarmsModel;
    late MockProperty mockProperty;
    late MockDatabaseReference mockRef;

    setUp(() {
      alarmsModel = AlarmsModel();
      mockProperty = MockProperty();
      mockRef = MockDatabaseReference();
      
      when(() => mockProperty.ref).thenReturn(mockRef);
      when(() => mockRef.set(any())).thenAnswer((_) async => null);
      
      alarmsModel.properties = {
        'ign_flow_alarm': mockProperty,
        'ignore_temp_alarm': mockProperty,
        'ign_pressure_alarm': mockProperty,
        'ign_overload_alarm': mockProperty,
        'ign_freqlock_alarm': mockProperty,
      };
    });

    test('should set ignore flow alarm', () {
      alarmsModel.ignoreFlowAlarm = true;
      verify(() => mockRef.set(true)).called(1);
    });

    test('should set ignore temp alarm', () {
      alarmsModel.ignoreTempAlarm = false;
      verify(() => mockRef.set(false)).called(1);
    });

    test('should set ignore pressure alarm', () {
      alarmsModel.ignorePressureAlarm = true;
      verify(() => mockRef.set(true)).called(1);
    });

    test('should set ignore overload alarm', () {
      alarmsModel.ignoreOverloadAlarm = false;
      verify(() => mockRef.set(false)).called(1);
    });

    test('should set ignore freq lock alarm', () {
      alarmsModel.ignoreFreqLockAlarm = true;
      verify(() => mockRef.set(true)).called(1);
    });
  });

  group('AlarmsModel Method-based Ignore Setters Tests', () {
    late AlarmsModel alarmsModel;
    late MockProperty mockProperty;

    setUp(() {
      alarmsModel = AlarmsModel();
      mockProperty = MockProperty();
      
      alarmsModel.properties = {
        'ign_temp_alarm': mockProperty,
        'ign_flow_alarm': mockProperty,
        'ign_pressure_alarm': mockProperty,
        'ign_freqlock_alarm': mockProperty,
        'ign_overload_alarm': mockProperty,
      };
      
      when(() => mockProperty.setValue(any())).thenAnswer((_) async {});
    });

    test('should set ignore temp alarm via method', () {
      alarmsModel.setIgnoreTempAlarm(true);
      verify(() => mockProperty.setValue(true)).called(1);
    });

    test('should set ignore flow alarm via method', () {
      alarmsModel.setIgnoreFlowAlarm(false);
      verify(() => mockProperty.setValue(false)).called(1);
    });

    test('should set ignore pressure alarm via method', () {
      alarmsModel.setIgnorePressureAlarm(true);
      verify(() => mockProperty.setValue(true)).called(1);
    });

    test('should set ignore freq lock alarm via method', () {
      alarmsModel.setIgnoreFreqLockAlarm(false);
      verify(() => mockProperty.setValue(false)).called(1);
    });

    test('should set ignore overload alarm via method', () {
      alarmsModel.setIgnoreOverloadAlarm(true);
      verify(() => mockProperty.setValue(true)).called(1);
    });
  });

  group('AlarmsModel Alarm Name Management Tests', () {
    late AlarmsModel alarmsModel;

    setUp(() {
      alarmsModel = AlarmsModel();
    });

    test('should get alarm name by valid index', () {
      expect(alarmsModel.getAlarmName(0), equals('flow_alarm'));
      expect(alarmsModel.getAlarmName(1), equals('temp_alarm'));
      expect(alarmsModel.getAlarmName(2), equals('pressure_alarm'));
      expect(alarmsModel.getAlarmName(3), equals('freq_lock_alarm'));
      expect(alarmsModel.getAlarmName(4), equals('overload_alarm'));
    });

    test('should handle invalid alarm index', () {
      expect(alarmsModel.getAlarmName(5), equals(''));
      expect(alarmsModel.getAlarmName(-1), equals(''));
      expect(alarmsModel.getAlarmName(100), equals(''));
    });

    test('should get alarm index by name', () {
      expect(alarmsModel.getAlarmIndex('flow_alarm'), equals(0));
      expect(alarmsModel.getAlarmIndex('temp_alarm'), equals(1));
      expect(alarmsModel.getAlarmIndex('pressure_alarm'), equals(2));
      expect(alarmsModel.getAlarmIndex('freq_lock_alarm'), equals(3));
      expect(alarmsModel.getAlarmIndex('overload_alarm'), equals(4));
    });

    test('should handle invalid alarm name', () {
      expect(alarmsModel.getAlarmIndex('invalid_alarm'), equals(-1));
      expect(alarmsModel.getAlarmIndex(''), equals(-1));
    });
  });

  group('AlarmsModel Active Alarm Management Tests', () {
    late AlarmsModel alarmsModel;

    setUp(() {
      alarmsModel = AlarmsModel();
      
      // Mock the alarms getter to return predictable values
      final flowProperty = MockProperty();
      final tempProperty = MockProperty();
      final pressureProperty = MockProperty();
      final freqLockProperty = MockProperty();
      final overloadProperty = MockProperty();
      
      when(() => flowProperty.value).thenReturn(true);
      when(() => tempProperty.value).thenReturn(false);
      when(() => pressureProperty.value).thenReturn(true);
      when(() => freqLockProperty.value).thenReturn(false);
      when(() => overloadProperty.value).thenReturn(true);
      
      alarmsModel.properties = {
        'flow_alarm': flowProperty,
        'temp_alarm': tempProperty,
        'pressure_alarm': pressureProperty,
        'freq_lock_alarm': freqLockProperty,
        'overload_alarm': overloadProperty,
      };
    });

    test('should get active alarm names correctly', () {
      final activeAlarms = alarmsModel.getActiveAlarmNames();
      
      expect(activeAlarms, contains('flow_alarm'));
      expect(activeAlarms, contains('pressure_alarm'));
      expect(activeAlarms, contains('overload_alarm'));
      expect(activeAlarms, isNot(contains('temp_alarm')));
      expect(activeAlarms, isNot(contains('freq_lock_alarm')));
    });

    test('should get idle alarms correctly', () {
      final idleAlarms = alarmsModel.idleAlarms;
      
      expect(idleAlarms, contains('temp_alarm'));
      expect(idleAlarms, contains('freq_lock_alarm'));
      expect(idleAlarms, isNot(contains('flow_alarm')));
      expect(idleAlarms, isNot(contains('pressure_alarm')));
      expect(idleAlarms, isNot(contains('overload_alarm')));
    });

    test('should detect alarm active state correctly', () {
      expect(alarmsModel.alarmActive, isTrue);
      
      // Test with no active alarms
      when(() => alarmsModel.properties['flow_alarm']!.value).thenReturn(false);
      when(() => alarmsModel.properties['pressure_alarm']!.value).thenReturn(false);
      when(() => alarmsModel.properties['overload_alarm']!.value).thenReturn(false);
      
      // Need to create new model to reflect changes
      final noAlarmsModel = AlarmsModel();
      final falseProperty = MockProperty();
      when(() => falseProperty.value).thenReturn(false);
      
      noAlarmsModel.properties = {
        'flow_alarm': falseProperty,
        'temp_alarm': falseProperty,
        'pressure_alarm': falseProperty,
        'freq_lock_alarm': falseProperty,
        'overload_alarm': falseProperty,
      };
      
      expect(noAlarmsModel.alarmActive, isFalse);
    });
  });

  group('AlarmsModel Sonic Alarm Count Tests', () {
    late AlarmsModel alarmsModel;

    setUp(() {
      alarmsModel = AlarmsModel();
    });

    test('should count active sonic alarms correctly', () {
      final pressureProperty = MockProperty();
      final overloadProperty = MockProperty();
      final freqLockProperty = MockProperty();
      final ignorePressureProperty = MockProperty();
      final ignoreOverloadProperty = MockProperty();
      final ignoreFreqLockProperty = MockProperty();
      
      // Setup: pressure and overload alarms active, freq lock inactive
      // None are ignored
      when(() => pressureProperty.value).thenReturn(true);
      when(() => overloadProperty.value).thenReturn(true);
      when(() => freqLockProperty.value).thenReturn(false);
      when(() => ignorePressureProperty.value).thenReturn(false);
      when(() => ignoreOverloadProperty.value).thenReturn(false);
      when(() => ignoreFreqLockProperty.value).thenReturn(false);
      
      alarmsModel.properties = {
        'pressure_alarm': pressureProperty,
        'overload_alarm': overloadProperty,
        'freq_lock_alarm': freqLockProperty,
        'ign_pressure_alarm': ignorePressureProperty,
        'ign_overload_alarm': ignoreOverloadProperty,
        'ign_freqlock_alarm': ignoreFreqLockProperty,
      };
      
      expect(alarmsModel.getActiveSonicAlarmCount(), equals(2));
      
      // Test with one alarm ignored
      when(() => ignorePressureProperty.value).thenReturn(true);
      expect(alarmsModel.getActiveSonicAlarmCount(), equals(1));
      
      // Test with all alarms ignored
      when(() => ignoreOverloadProperty.value).thenReturn(true);
      expect(alarmsModel.getActiveSonicAlarmCount(), equals(0));
    });

    test('should handle all sonic alarms active', () {
      final pressureProperty = MockProperty();
      final overloadProperty = MockProperty();
      final freqLockProperty = MockProperty();
      final ignorePressureProperty = MockProperty();
      final ignoreOverloadProperty = MockProperty();
      final ignoreFreqLockProperty = MockProperty();
      
      when(() => pressureProperty.value).thenReturn(true);
      when(() => overloadProperty.value).thenReturn(true);
      when(() => freqLockProperty.value).thenReturn(true);
      when(() => ignorePressureProperty.value).thenReturn(false);
      when(() => ignoreOverloadProperty.value).thenReturn(false);
      when(() => ignoreFreqLockProperty.value).thenReturn(false);
      
      alarmsModel.properties = {
        'pressure_alarm': pressureProperty,
        'overload_alarm': overloadProperty,
        'freq_lock_alarm': freqLockProperty,
        'ign_pressure_alarm': ignorePressureProperty,
        'ign_overload_alarm': ignoreOverloadProperty,
        'ign_freqlock_alarm': ignoreFreqLockProperty,
      };
      
      expect(alarmsModel.getActiveSonicAlarmCount(), equals(3));
    });
  });

  group('AlarmsModel Operator[] Tests', () {
    late AlarmsModel alarmsModel;
    late MockProperty mockProperty;

    setUp(() {
      alarmsModel = AlarmsModel();
      mockProperty = MockProperty();
      
      when(() => mockProperty.value).thenReturn(true);
      
      alarmsModel.properties = {
        'flow_warn': mockProperty,
        'temp_warn': mockProperty,
        'pressure_warn': mockProperty,
        'flow_alarm': mockProperty,
        'temp_alarm': mockProperty,
        'pressure_alarm': mockProperty,
        'freq_lock_alarm': mockProperty,
        'overload_alarm': mockProperty,
        'ign_temp_alarm': mockProperty,
        'ign_flow_alarm': mockProperty,
        'ign_pressure_alarm': mockProperty,
        'ign_overload_alarm': mockProperty,
        'ign_freqlock_alarm': mockProperty,
      };
    });

    test('should handle warning property access via operator', () {
      expect(alarmsModel['flowWarn'], isTrue);
      expect(alarmsModel['tempWarn'], isTrue);
      expect(alarmsModel['pressureWarn'], isTrue);
    });

    test('should handle alarm property access via operator', () {
      expect(alarmsModel['flowAlarm'], isTrue);
      expect(alarmsModel['tempAlarm'], isTrue);
      expect(alarmsModel['pressureAlarm'], isTrue);
      expect(alarmsModel['freqLockAlarm'], isTrue);
      expect(alarmsModel['overloadAlarm'], isTrue);
    });

    test('should handle ignore alarm property access via operator', () {
      expect(alarmsModel['ignoreTempAlarm'], isTrue);
      expect(alarmsModel['ignoreFlowAlarm'], isTrue);
      expect(alarmsModel['ignorePressureAlarm'], isTrue);
      expect(alarmsModel['ignoreOverloadAlarm'], isTrue);
      expect(alarmsModel['ignoreFreqLockAlarm'], isTrue);
    });

    test('should handle composite property access via operator', () {
      expect(alarmsModel['tankAlarmActive'], isTrue);
      expect(alarmsModel['pumpAlarmActive'], isTrue);
      expect(alarmsModel['sonicAlarmActive'], isTrue);
    });

    test('should handle invalid property keys', () {
      expect(alarmsModel['invalidKey'], isFalse);
      expect(alarmsModel[''], isFalse);
      expect(alarmsModel['nonexistent'], isFalse);
    });
  });

  group('AlarmsModel Edge Cases and Error Handling Tests', () {
    late AlarmsModel alarmsModel;

    setUp(() {
      alarmsModel = AlarmsModel();
    });

    test('should handle empty properties map', () {
      alarmsModel.properties = {};
      
      expect(() => alarmsModel.flowAlarm, returnsNormally);
      expect(() => alarmsModel.getActiveAlarmNames(), returnsNormally);
      expect(() => alarmsModel.alarmActive, returnsNormally);
      expect(() => alarmsModel.getActiveSonicAlarmCount(), returnsNormally);
    });

    test('should handle null property values', () {
      final nullProperty = MockProperty();
      when(() => nullProperty.value).thenReturn(null);
      
      alarmsModel.properties = {
        'flow_alarm': nullProperty,
      };
      
      expect(() => alarmsModel.flowAlarm, returnsNormally);
    });

    test('should handle property access errors', () {
      final errorProperty = MockProperty();
      when(() => errorProperty.value).thenThrow(Exception('Property error'));
      
      alarmsModel.properties = {
        'flow_alarm': errorProperty,
      };
      
      expect(() => alarmsModel.flowAlarm, returnsNormally);
    });

    test('should handle mixed property types gracefully', () {
      final stringProperty = MockProperty();
      final intProperty = MockProperty();
      final boolProperty = MockProperty();
      
      when(() => stringProperty.value).thenReturn('true');
      when(() => intProperty.value).thenReturn(1);
      when(() => boolProperty.value).thenReturn(true);
      
      alarmsModel.properties = {
        'string_prop': stringProperty,
        'int_prop': intProperty,
        'bool_prop': boolProperty,
      };
      
      expect(() => alarmsModel.getBoolPropertyValue('string_prop'), returnsNormally);
      expect(() => alarmsModel.getBoolPropertyValue('int_prop'), returnsNormally);
      expect(() => alarmsModel.getBoolPropertyValue('bool_prop'), returnsNormally);
    });
  });
}