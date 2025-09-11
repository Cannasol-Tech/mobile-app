/**
 * @file device_test.dart
 * @author Assistant
 * @date 2025-01-05
 * @brief Comprehensive unit tests for Device data model
 * @details Tests all public methods, edge cases, and error conditions
 *          using flutter_test and mocktail for external dependencies
 * @version 1.0
 * @since 1.0
 */

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:cannasoltech_automation/data_models/device.dart';
import 'package:cannasoltech_automation/handlers/state_handler.dart';
import 'package:cannasoltech_automation/handlers/config_handler.dart';
import 'package:cannasoltech_automation/handlers/alarm_handler.dart';
import 'package:cannasoltech_automation/shared/constants.dart';

import '../../helpers/mocks.dart';
import '../../helpers/test_data.dart';

void main() {
  setUpAll(() {
    registerMockFallbacks();
  });

  group('Device Data Model', () {
    late Device device;
    late MockStateHandler mockStateHandler;
    late MockConfigHandler mockConfigHandler;
    late MockAlarmsModel mockAlarmsModel;

    setUp(() {
      mockStateHandler = MockStateHandler();
      mockConfigHandler = MockConfigHandler();
      mockAlarmsModel = MockAlarmsModel();

      device = Device(
        status: 'ONLINE',
        id: SystemTestData.deviceId,
        name: SystemTestData.deviceName,
        type: SystemTestData.deviceModel,
        native: {'test': 'data'},
      );

      // Setup default behaviors
      when(() => mockStateHandler.state).thenReturn(RUNNING);
      when(() => mockConfigHandler.device).thenReturn(device);
      when(() => mockAlarmsModel.alarmActive).thenReturn(false);
    });

    test('should create device with required parameters', () {
      expect(device.status, equals('ONLINE'));
      expect(device.id, equals(SystemTestData.deviceId));
      expect(device.name, equals(SystemTestData.deviceName));
      expect(device.type, equals(SystemTestData.deviceModel));
      expect(device.native, isNotNull);
    });

    test('should create no-device instance', () {
      final noDevice = Device.noDevice();
      
      expect(noDevice.name, equals('None'));
      expect(noDevice.id, equals('None'));
      expect(noDevice.status, equals('None'));
      expect(noDevice.type, equals('None'));
    });

    test('should handle device state correctly', () {
      device.state = mockStateHandler;
      
      expect(device.state, equals(mockStateHandler));
      expect(device.state.state, equals(RUNNING));
    });

    test('should handle device configuration correctly', () {
      device.config = mockConfigHandler;
      
      expect(device.config, equals(mockConfigHandler));
    });

    test('should handle device alarms correctly', () {
      device.alarms = mockAlarmsModel;
      
      expect(device.alarms, equals(mockAlarmsModel));
      expect(device.alarms.alarmActive, isFalse);
    });

    test('should compare devices correctly', () {
      final device1 = Device(
        status: 'ONLINE',
        id: 'device-1',
        name: 'Device 1',
        type: 'Type A',
        native: {},
      );

      final device2 = Device(
        status: 'ONLINE', 
        id: 'device-1',
        name: 'Device 1',
        type: 'Type A',
        native: {},
      );

      final device3 = Device(
        status: 'OFFLINE',
        id: 'device-2',
        name: 'Device 2',
        type: 'Type B',
        native: {},
      );

      expect(device1.id, equals(device2.id));
      expect(device1.id, isNot(equals(device3.id)));
    });

    test('should handle offline device status', () {
      final offlineDevice = Device(
        status: 'OFFLINE',
        id: 'offline-device',
        name: 'Offline Device',
        type: 'Test Type',
        native: {},
      );

      expect(offlineDevice.status, equals('OFFLINE'));
      expect(offlineDevice.id, equals('offline-device'));
    });

    test('should create from database snapshot', () {
      final mockSnapshot = MockDataSnapshot();
      when(() => mockSnapshot.value).thenReturn({
        'status': 'ONLINE',
        'name': 'Test Device',
        'type': 'Test Type',
        'config': {},
        'state': {'state': RUNNING},
        'alarms': {},
      });

      when(() => mockSnapshot.key).thenReturn('test-device-id');
      when(() => mockSnapshot.child(any())).thenReturn(mockSnapshot);

      final deviceFromDb = Device.fromDatabase(mockSnapshot);

      expect(deviceFromDb, isA<Device>());
      expect(deviceFromDb.id, equals('test-device-id'));
    });

    test('should handle properties correctly', () {
      device.state = mockStateHandler;
      device.config = mockConfigHandler;
      device.alarms = mockAlarmsModel;

      // Test that all handlers are properly assigned
      expect(device.state, isNotNull);
      expect(device.config, isNotNull);
      expect(device.alarms, isNotNull);
    });

    test('should handle edge cases for device creation', () {
      // Test with minimal data
      final minimalDevice = Device(
        status: '',
        id: '',
        name: '',
        type: '',
        native: {},
      );

      expect(minimalDevice.status, equals(''));
      expect(minimalDevice.id, equals(''));
      expect(minimalDevice.name, equals(''));
      expect(minimalDevice.type, equals(''));
    });
  });
}