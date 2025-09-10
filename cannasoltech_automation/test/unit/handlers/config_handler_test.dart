/**
 * @file config_handler_test.dart
 * @author Stephen Boyett
 * @date 2025-09-10
 * @brief Comprehensive unit tests for ConfigHandler class
 * @details Tests all public methods, edge cases, and error conditions
 *          using flutter_test and mocktail for external dependencies
 * @version 1.0
 * @since 1.0
 */

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:cannasoltech_automation/handlers/config_handler.dart';
import 'package:cannasoltech_automation/handlers/state_handler.dart';
import 'package:cannasoltech_automation/data_models/device.dart';
import 'package:cannasoltech_automation/data_models/property.dart';
import 'package:cannasoltech_automation/objects/database_model.dart';
import 'package:cannasoltech_automation/shared/constants.dart';
import '../../helpers/mocks.dart';

// Add missing mock classes that aren't in the mocks.dart file
class MockFireProperty extends Mock implements FireProperty {}

class FakeDevice extends Fake implements Device {}

void main() {
  late MockDevice mockDevice;
  late MockDatabaseReference mockDatabaseRef;
  late MockDataSnapshot mockSnapshot;
  late MockFireProperty mockProperty;
  late MockBuildContext mockContext;

  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    registerMockFallbacks();
  });

  setUp(() {
    mockDevice = MockDevice();
    mockDatabaseRef = MockDatabaseReference();
    mockSnapshot = MockDataSnapshot();
    mockProperty = MockFireProperty();
    mockContext = MockBuildContext();

    // Initialize late fields
    mockDevice.state = StateHandler(device: mockDevice);

    // Setup default mock behaviors
    when(() => mockDevice.name).thenReturn('Test Device');
    when(() => mockSnapshot.value).thenReturn({'test': 'data'});
    when(() => mockSnapshot.children).thenReturn([]);
    when(() => mockProperty.setValue(any())).thenAnswer((_) async {});
    when(() => mockDatabaseRef.child(any())).thenReturn(mockDatabaseRef);
  });

  group('ConfigHandler Constructor and Factory', () {
    test('should create ConfigHandler with device', () {
      final handler = ConfigHandler(device: mockDevice);

      expect(handler.device, equals(mockDevice));
    });

    test('should create ConfigHandler without device', () {
      final handler = ConfigHandler();

      expect(handler.device, isNull);
    });

    test('should create ConfigHandler from database', () {
      when(() => mockSnapshot.child(any())).thenReturn(mockSnapshot);
      when(() => mockSnapshot.ref).thenReturn(mockDatabaseRef);

      final handler = ConfigHandler.fromDatabase(mockSnapshot, mockDevice);

      expect(handler.device, equals(mockDevice));
    });
  });

  group('Device Control Methods', () {
    test('should start device', () {
      final handler = ConfigHandler(device: mockDevice);
      handler.properties['start'] = mockProperty;

      handler.startDevice(mockContext);

      verify(() => mockProperty.setValue(true)).called(1);
    });

    test('should reset device', () {
      final handler = ConfigHandler(device: mockDevice);
      handler.properties['abort_run'] = mockProperty;

      handler.resetDevice();

      verify(() => mockProperty.setValue(true)).called(1);
    });

    test('should abort run', () {
      final handler = ConfigHandler(device: mockDevice);
      handler.properties['abort_run'] = mockProperty;

      handler.abortRun();

      verify(() => mockProperty.setValue(true)).called(1);
    });

    test('should end run', () {
      final handler = ConfigHandler(device: mockDevice);
      handler.properties['end_run'] = mockProperty;

      handler.endRun();

      verify(() => mockProperty.setValue(true)).called(1);
    });

    test('should resume run', () {
      final handler = ConfigHandler(device: mockDevice);
      handler.properties['resume'] = mockProperty;

      handler.resumeRun();

      verify(() => mockProperty.setValue(true)).called(1);
    });
  });

  group('Configuration Methods', () {
    test('should set set time from duration', () {
      final handler = ConfigHandler(device: mockDevice);
      handler.properties['set_hours'] = mockProperty;
      handler.properties['set_minutes'] = mockProperty;

      final duration = Duration(hours: 2, minutes: 30);
      handler.setSetTime(duration);

      verify(() => mockProperty.setValue(2)).called(1);
      verify(() => mockProperty.setValue(30)).called(1);
    });

    test('should set enable cooldown', () {
      final handler = ConfigHandler(device: mockDevice);
      handler.properties['enable_cooldown'] = mockProperty;

      handler.setEnableCoolDown(true);

      verify(() => mockProperty.setValue(true)).called(1);
    });

    test('should set pump control', () {
      final handler = ConfigHandler(device: mockDevice);
      handler.properties['pump_control'] = mockProperty;

      handler.setPumpControl(true);

      verify(() => mockProperty.setValue(true)).called(1);
    });

    test('should set batch size from string', () {
      final handler = ConfigHandler(device: mockDevice);
      handler.properties['batch_size'] = mockProperty;

      handler.setBatchSize('200.5');

      verify(() => mockProperty.setValue(200.5)).called(1);
    });

    test('should set temperature from string', () {
      final handler = ConfigHandler(device: mockDevice);
      handler.properties['set_temp'] = mockProperty;

      handler.setTemperature('90.0');

      verify(() => mockProperty.setValue(90.0)).called(1);
    });

    test('should set temperature variance from string', () {
      final handler = ConfigHandler(device: mockDevice);
      handler.properties['temp_thresh'] = mockProperty;

      handler.setTempVariance('5.0');

      verify(() => mockProperty.setValue(5.0)).called(1);
    });

    test('should set minimum flow rate from string', () {
      final handler = ConfigHandler(device: mockDevice);
      handler.properties['flow_thresh'] = mockProperty;

      handler.setMinFlowRate('10.0');

      verify(() => mockProperty.setValue(10.0)).called(1);
    });

    test('should set minimum pressure from string', () {
      final handler = ConfigHandler(device: mockDevice);
      handler.properties['pressure_thresh'] = mockProperty;

      handler.setMinPressure('20.0');

      verify(() => mockProperty.setValue(20.0)).called(1);
    });

    test('should set cooldown temperature from string', () {
      final handler = ConfigHandler(device: mockDevice);
      handler.properties['cool_down_temp'] = mockProperty;

      handler.setCooldownTemp('15.0');

      verify(() => mockProperty.setValue(15.0)).called(1);
    });
  });

  group('Property Getters and Setters', () {
    late ConfigHandler handler;
    late MockFireProperty mockBoolProperty;
    late MockFireProperty mockIntProperty;
    late MockFireProperty mockDoubleProperty;

    setUp(() {
      handler = ConfigHandler(device: mockDevice);
      mockBoolProperty = MockFireProperty();
      mockIntProperty = MockFireProperty();
      mockDoubleProperty = MockFireProperty();

      // Setup property return values
      when(() => mockBoolProperty.value).thenReturn(true);
      when(() => mockIntProperty.value).thenReturn(5);
      when(() => mockDoubleProperty.value).thenReturn(25.5);
    });

    test('should get and set reset property', () {
      handler.properties['abort_run'] = mockBoolProperty;
      
      expect(handler.reset, isTrue);
      
      handler.reset = false;
      verify(() => mockBoolProperty.setValue(false)).called(1);
    });

    test('should get and set start property', () {
      handler.properties['start'] = mockBoolProperty;
      
      expect(handler.start, isTrue);
      
      handler.start = false;
      verify(() => mockBoolProperty.setValue(false)).called(1);
    });

    test('should get and set end property', () {
      handler.properties['end_run'] = mockBoolProperty;
      
      expect(handler.end, isTrue);
      
      handler.end = false;
      verify(() => mockBoolProperty.setValue(false)).called(1);
    });

    test('should get and set abort property', () {
      handler.properties['abort_run'] = mockBoolProperty;
      
      expect(handler.abort, isTrue);
      
      handler.abort = false;
      verify(() => mockBoolProperty.setValue(false)).called(1);
    });

    test('should get and set setHours property', () {
      handler.properties['set_hours'] = mockIntProperty;
      
      expect(handler.setHours, equals(5));
      
      handler.setHours = 3;
      verify(() => mockIntProperty.setValue(3)).called(1);
    });

    test('should get and set setMinutes property', () {
      handler.properties['set_minutes'] = mockIntProperty;
      
      expect(handler.setMinutes, equals(5));
      
      handler.setMinutes = 30;
      verify(() => mockIntProperty.setValue(30)).called(1);
    });

    test('should get setTime as formatted string', () {
      handler.properties['set_hours'] = mockIntProperty;
      handler.properties['set_minutes'] = mockIntProperty;
      
      expect(handler.setTime, equals('5:05'));
    });

    test('should get and set pumpControl property', () {
      handler.properties['pump_control'] = mockBoolProperty;
      
      expect(handler.pumpControl, isTrue);
      
      handler.pumpControl = false;
      verify(() => mockBoolProperty.setValue(false)).called(1);
    });

    test('should get and set enableCooldown property', () {
      handler.properties['enable_cooldown'] = mockBoolProperty;
      
      expect(handler.enableCooldown, isTrue);
      
      handler.enableCooldown = false;
      verify(() => mockBoolProperty.setValue(false)).called(1);
    });

    test('should get and set setTemp property', () {
      handler.properties['set_temp'] = mockDoubleProperty;
      
      expect(handler.setTemp, equals(25.5));
      
      handler.setTemp = 30.0;
      verify(() => mockDoubleProperty.setValue(30.0)).called(1);
    });

    test('should get and set batchSize property', () {
      handler.properties['batch_size'] = mockDoubleProperty;
      
      expect(handler.batchSize, equals(25.5));
      
      handler.batchSize = 100.0;
      verify(() => mockDoubleProperty.setValue(100.0)).called(1);
    });

    test('should get and set flowThresh property', () {
      handler.properties['flow_thresh'] = mockDoubleProperty;
      
      expect(handler.flowThresh, equals(25.5));
      
      handler.flowThresh = 15.0;
      verify(() => mockDoubleProperty.setValue(15.0)).called(1);
    });

    test('should get and set tempThresh property', () {
      handler.properties['temp_thresh'] = mockDoubleProperty;
      
      expect(handler.tempThresh, equals(25.5));
      
      handler.tempThresh = 5.0;
      verify(() => mockDoubleProperty.setValue(5.0)).called(1);
    });

    test('should get and set cooldownTemp property', () {
      handler.properties['cool_down_temp'] = mockDoubleProperty;
      
      expect(handler.cooldownTemp, equals(25.5));
      
      handler.cooldownTemp = 20.0;
      verify(() => mockDoubleProperty.setValue(20.0)).called(1);
    });

    test('should get and set pressureThresh property', () {
      handler.properties['pressure_thresh'] = mockDoubleProperty;
      
      expect(handler.pressureThresh, equals(25.5));
      
      handler.pressureThresh = 18.0;
      verify(() => mockDoubleProperty.setValue(18.0)).called(1);
    });

    test('should get currSetTemp based on device state', () {
      handler.properties['set_temp'] = mockDoubleProperty;
      handler.properties['cool_down_temp'] = mockDoubleProperty;
      
      // Mock device state as not COOL_DOWN
      final mockStateHandler = MockStateHandler();
      when(() => mockDevice.state).thenReturn(mockStateHandler);
      when(() => mockStateHandler.state).thenReturn(RUNNING); // Not COOL_DOWN
      
      expect(handler.currSetTemp, equals(25.5)); // Should return setTemp
    });

    test('should get currSetTemp as cooldown temp when in COOL_DOWN state', () {
      handler.properties['set_temp'] = MockFireProperty();
      handler.properties['cool_down_temp'] = mockDoubleProperty;
      
      // Mock device state as COOL_DOWN
      final mockStateHandler = MockStateHandler();
      when(() => mockDevice.state).thenReturn(mockStateHandler);
      when(() => mockStateHandler.state).thenReturn(COOL_DOWN);
      
      expect(handler.currSetTemp, equals(25.5)); // Should return cooldownTemp
    });
  });

  group('Save Slot Operations', () {
    test('should initialize with empty save slots', () {
      final handler = ConfigHandler(device: mockDevice);
      
      expect(handler.saveSlots, isEmpty);
    });

    test('should handle save slot operations', () {
      final handler = ConfigHandler(device: mockDevice);
      handler.properties['batch_size'] = mockProperty;
      handler.properties['set_temp'] = mockProperty;
      
      // Test that save slots can be modified
      expect(() => handler.saveSlots.clear(), returnsNormally);
    });
  });

  group('Error Handling and Edge Cases', () {
    test('should handle null property in startDevice', () {
      final handler = ConfigHandler(device: mockDevice);
      // properties['start'] is null

      expect(() => handler.startDevice(mockContext), returnsNormally);
    });

    test('should handle null property in resetDevice', () {
      final handler = ConfigHandler(device: mockDevice);
      // properties['abort_run'] is null

      expect(() => handler.resetDevice(), returnsNormally);
    });

    test('should handle null property in abortRun', () {
      final handler = ConfigHandler(device: mockDevice);
      // properties['abort_run'] is null

      expect(() => handler.abortRun(), returnsNormally);
    });

    test('should handle null property in endRun', () {
      final handler = ConfigHandler(device: mockDevice);
      // properties['end_run'] is null

      expect(() => handler.endRun(), returnsNormally);
    });

    test('should handle null property in resumeRun', () {
      final handler = ConfigHandler(device: mockDevice);
      // properties['resume'] is null

      expect(() => handler.resumeRun(), returnsNormally);
    });

    test('should handle null property in setEnableCoolDown', () {
      final handler = ConfigHandler(device: mockDevice);
      // properties['enable_cooldown'] is null

      expect(() => handler.setEnableCoolDown(true), returnsNormally);
    });

    test('should handle invalid string in setBatchSize', () {
      final handler = ConfigHandler(device: mockDevice);
      handler.properties['batch_size'] = mockProperty;

      expect(() => handler.setBatchSize('invalid'), returnsNormally);
    });

    test('should handle invalid string in setTemperature', () {
      final handler = ConfigHandler(device: mockDevice);
      handler.properties['set_temp'] = mockProperty;

      expect(() => handler.setTemperature('invalid'), returnsNormally);
    });

    test('should handle invalid string in setTempVariance', () {
      final handler = ConfigHandler(device: mockDevice);
      handler.properties['temp_thresh'] = mockProperty;

      expect(() => handler.setTempVariance('invalid'), returnsNormally);
    });

    test('should handle invalid string in setMinFlowRate', () {
      final handler = ConfigHandler(device: mockDevice);
      handler.properties['flow_thresh'] = mockProperty;

      expect(() => handler.setMinFlowRate('invalid'), returnsNormally);
    });

    test('should handle invalid string in setMinPressure', () {
      final handler = ConfigHandler(device: mockDevice);
      handler.properties['pressure_thresh'] = mockProperty;

      expect(() => handler.setMinPressure('invalid'), returnsNormally);
    });

    test('should handle invalid string in setCooldownTemp', () {
      final handler = ConfigHandler(device: mockDevice);
      handler.properties['cool_down_temp'] = mockProperty;

      expect(() => handler.setCooldownTemp('invalid'), returnsNormally);
    });
  });
}
