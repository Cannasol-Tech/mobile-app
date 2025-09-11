// Enhanced Unit Tests for ConfigHandler
//
// Comprehensive tests for device configuration management including
// control operations, save slots, property management, and Firebase integration.
//
// Testing Framework: flutter_test + mocktail
// Coverage Target: ≥85% statement coverage
// Mocking: Permitted for external dependencies (Firebase, Device)

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'package:cannasoltech_automation/handlers/config_handler.dart';
import 'package:cannasoltech_automation/data_models/device.dart';
import 'package:cannasoltech_automation/data_models/property.dart';
import 'package:cannasoltech_automation/objects/save_slot.dart';
import 'package:cannasoltech_automation/shared/constants.dart';
import 'package:cannasoltech_automation/shared/types.dart';
import '../../helpers/mocks.dart';
import '../../helpers/test_data.dart';

// Additional mock classes for config handler testing
class MockSaveSlot extends Mock implements SaveSlot {}
class MockStateHandler extends Mock implements StateHandler {}

void main() {
  late MockDevice mockDevice;
  late MockDatabaseReference mockDatabaseRef;
  late MockDataSnapshot mockSnapshot;
  late MockProperty mockProperty;
  late MockStateHandler mockStateHandler;

  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    registerMockFallbacks();
    
    // Register additional fallbacks
    registerFallbackValue(MockSaveSlot());
    registerFallbackValue(MockStateHandler());
  });

  setUp(() {
    mockDevice = MockDevice();
    mockDatabaseRef = MockDatabaseReference();
    mockSnapshot = MockDataSnapshot();
    mockProperty = MockProperty();
    mockStateHandler = MockStateHandler();

    // Setup device state
    when(() => mockDevice.state).thenReturn(mockStateHandler);
    when(() => mockStateHandler.state).thenReturn(INIT);
    when(() => mockDevice.name).thenReturn('Test Device');
    when(() => mockDevice.id).thenReturn('test-device-123');

    // Setup database mock behaviors
    when(() => mockSnapshot.value).thenReturn({'test': 'data'});
    when(() => mockSnapshot.children).thenReturn([]);
    when(() => mockSnapshot.exists).thenReturn(true);
    when(() => mockDatabaseRef.child(any())).thenReturn(mockDatabaseRef);
    when(() => mockDatabaseRef.update(any())).thenAnswer((_) async => null);
    when(() => mockDatabaseRef.set(any())).thenAnswer((_) async => null);

    // Setup property mock behaviors
    when(() => mockProperty.setValue(any())).thenAnswer((_) async {});
    when(() => mockProperty.value).thenReturn(0);
    when(() => mockProperty.name).thenReturn('test_property');
  });

  group('ConfigHandler Constructor and Initialization', () {
    test('should create ConfigHandler with device', () {
      final handler = ConfigHandler(device: mockDevice);
      
      expect(handler.device, equals(mockDevice));
      expect(handler.saveSlots, isEmpty);
    });

    test('should create ConfigHandler without device', () {
      final handler = ConfigHandler();
      
      expect(handler.device, isNull);
      expect(handler.saveSlots, isEmpty);
    });

    test('should create ConfigHandler from database snapshot', () {
      final testData = {
        'properties': {
          'start': {'value': true},
          'abort_run': {'value': false},
          'set_temp': {'value': 25.5},
          'set_hours': {'value': 2},
          'set_minutes': {'value': 30},
        },
        'save_slots': {
          'slot_1': {'name': 'Test Slot 1'},
          'slot_2': {'name': 'Test Slot 2'},
        }
      };
      
      when(() => mockSnapshot.value).thenReturn(testData);
      when(() => mockSnapshot.children).thenReturn([
        mockSnapshot, // properties
        mockSnapshot, // save_slots
      ]);
      
      final handler = ConfigHandler.fromDatabase(mockSnapshot, mockDevice);
      
      expect(handler.device, equals(mockDevice));
      expect(handler, isNotNull);
    });

    test('should handle null database snapshot gracefully', () {
      when(() => mockSnapshot.value).thenReturn(null);
      when(() => mockSnapshot.children).thenReturn([]);
      
      expect(() => ConfigHandler.fromDatabase(mockSnapshot, mockDevice), returnsNormally);
    });
  });

  group('Control Operations - Start/Stop/Reset', () {
    late ConfigHandler configHandler;

    setUp(() {
      configHandler = ConfigHandler(device: mockDevice);
      // Mock the property getters and setters
      configHandler.properties = {
        'start': mockProperty,
        'abort_run': mockProperty,
        'end_run': mockProperty,
      };
    });

    test('should handle start operation', () {
      when(() => mockProperty.value).thenReturn(true);
      
      configHandler.start = true;
      bool startValue = configHandler.start;
      
      expect(startValue, isTrue);
      verify(() => mockProperty.setValue(true)).called(1);
    });

    test('should handle reset/abort operation', () {
      when(() => mockProperty.value).thenReturn(true);
      
      configHandler.reset = true;
      bool resetValue = configHandler.reset;
      
      expect(resetValue, isTrue);
      verify(() => mockProperty.setValue(true)).called(1);
    });

    test('should handle abort operation through reset property', () {
      when(() => mockProperty.value).thenReturn(false);
      
      configHandler.abort = false;
      bool abortValue = configHandler.abort;
      
      expect(abortValue, isFalse);
    });

    test('should handle end run operation', () {
      when(() => mockProperty.value).thenReturn(true);
      
      configHandler.end = true;
      bool endValue = configHandler.end;
      
      expect(endValue, isTrue);
      verify(() => mockProperty.setValue(true)).called(1);
    });

    test('should handle multiple control operations in sequence', () {
      when(() => mockProperty.value).thenReturn(false);
      
      configHandler.start = true;
      configHandler.reset = false;
      configHandler.end = false;
      
      // Verify that all operations were called
      verify(() => mockProperty.setValue(any())).called(3);
    });
  });

  group('Time Configuration Management', () {
    late ConfigHandler configHandler;

    setUp(() {
      configHandler = ConfigHandler(device: mockDevice);
      configHandler.properties = {
        'set_hours': mockProperty,
        'set_minutes': mockProperty,
      };
    });

    test('should handle hours configuration', () {
      when(() => mockProperty.value).thenReturn(2);
      
      configHandler.setHours = 2;
      int hours = configHandler.setHours;
      
      expect(hours, equals(2));
    });

    test('should handle minutes configuration', () {
      when(() => mockProperty.value).thenReturn(30);
      
      configHandler.setMinutes = 30;
      int minutes = configHandler.setMinutes;
      
      expect(minutes, equals(30));
    });

    test('should format time string correctly', () {
      configHandler.properties = {
        'set_hours': mockProperty,
        'set_minutes': mockProperty,
      };
      
      // Mock individual property values
      final hoursProperty = MockProperty();
      final minutesProperty = MockProperty();
      when(() => hoursProperty.value).thenReturn(2);
      when(() => minutesProperty.value).thenReturn(5);
      
      configHandler.properties['set_hours'] = hoursProperty;
      configHandler.properties['set_minutes'] = minutesProperty;
      
      String timeString = configHandler.setTime;
      
      expect(timeString, equals('2:05')); // Should pad minutes with zero
    });

    test('should handle zero time values correctly', () {
      final hoursProperty = MockProperty();
      final minutesProperty = MockProperty();
      when(() => hoursProperty.value).thenReturn(0);
      when(() => minutesProperty.value).thenReturn(0);
      
      configHandler.properties = {
        'set_hours': hoursProperty,
        'set_minutes': minutesProperty,
      };
      
      String timeString = configHandler.setTime;
      
      expect(timeString, equals('0:00'));
    });

    test('should handle large time values', () {
      final hoursProperty = MockProperty();
      final minutesProperty = MockProperty();
      when(() => hoursProperty.value).thenReturn(24);
      when(() => minutesProperty.value).thenReturn(59);
      
      configHandler.properties = {
        'set_hours': hoursProperty,
        'set_minutes': minutesProperty,
      };
      
      String timeString = configHandler.setTime;
      
      expect(timeString, equals('24:59'));
    });
  });

  group('Boolean Configuration Properties', () {
    late ConfigHandler configHandler;

    setUp(() {
      configHandler = ConfigHandler(device: mockDevice);
      configHandler.properties = {
        'pump_control': mockProperty,
        'enable_cooldown': mockProperty,
      };
    });

    test('should handle pump control configuration', () {
      when(() => mockProperty.value).thenReturn(true);
      
      configHandler.pumpControl = true;
      bool pumpControlValue = configHandler.pumpControl;
      
      expect(pumpControlValue, isTrue);
      verify(() => mockProperty.setValue(true)).called(1);
    });

    test('should handle cooldown enable configuration', () {
      when(() => mockProperty.value).thenReturn(false);
      
      configHandler.enableCooldown = false;
      bool cooldownValue = configHandler.enableCooldown;
      
      expect(cooldownValue, isFalse);
      verify(() => mockProperty.setValue(false)).called(1);
    });

    test('should toggle boolean properties correctly', () {
      when(() => mockProperty.value).thenReturn(false);
      
      // Toggle pump control
      configHandler.pumpControl = !configHandler.pumpControl;
      
      verify(() => mockProperty.setValue(true)).called(1);
    });
  });

  group('Temperature and Threshold Configuration', () {
    late ConfigHandler configHandler;

    setUp(() {
      configHandler = ConfigHandler(device: mockDevice);
      configHandler.properties = {
        'set_temp': mockProperty,
        'temp_thresh': mockProperty,
        'cool_down_temp': mockProperty,
        'flow_thresh': mockProperty,
        'pressure_thresh': mockProperty,
        'batch_size': mockProperty,
      };
    });

    test('should handle temperature setting', () {
      when(() => mockProperty.value).thenReturn(25.5);
      
      configHandler.setTemp = 25.5;
      double tempValue = configHandler.setTemp;
      
      expect(tempValue, equals(25.5));
    });

    test('should handle temperature threshold', () {
      when(() => mockProperty.value).thenReturn(2.0);
      
      configHandler.tempThresh = 2.0;
      double threshValue = configHandler.tempThresh;
      
      expect(threshValue, equals(2.0));
    });

    test('should handle cooldown temperature', () {
      when(() => mockProperty.value).thenReturn(15.0);
      
      configHandler.cooldownTemp = 15.0;
      double cooldownValue = configHandler.cooldownTemp;
      
      expect(cooldownValue, equals(15.0));
    });

    test('should handle flow threshold', () {
      when(() => mockProperty.value).thenReturn(10.5);
      
      configHandler.flowThresh = 10.5;
      double flowValue = configHandler.flowThresh;
      
      expect(flowValue, equals(10.5));
    });

    test('should handle pressure threshold', () {
      when(() => mockProperty.value).thenReturn(50.0);
      
      configHandler.pressureThresh = 50.0;
      double pressureValue = configHandler.pressureThresh;
      
      expect(pressureValue, equals(50.0));
    });

    test('should handle batch size configuration', () {
      when(() => mockProperty.value).thenReturn(100.0);
      
      configHandler.batchSize = 100.0;
      double batchValue = configHandler.batchSize;
      
      expect(batchValue, equals(100.0));
    });

    test('should return correct current set temperature based on state', () {
      final setTempProperty = MockProperty();
      final cooldownTempProperty = MockProperty();
      
      when(() => setTempProperty.value).thenReturn(25.0);
      when(() => cooldownTempProperty.value).thenReturn(15.0);
      
      configHandler.properties = {
        'set_temp': setTempProperty,
        'cool_down_temp': cooldownTempProperty,
      };
      
      // Test normal operation state
      when(() => mockStateHandler.state).thenReturn(RUNNING);
      double currentTemp = configHandler.currSetTemp;
      expect(currentTemp, equals(25.0));
      
      // Test cooldown state
      when(() => mockStateHandler.state).thenReturn(COOL_DOWN);
      currentTemp = configHandler.currSetTemp;
      expect(currentTemp, equals(15.0));
    });
  });

  group('Save Slot Management', () {
    late ConfigHandler configHandler;

    setUp(() {
      configHandler = ConfigHandler(device: mockDevice);
    });

    test('should initialize with empty save slots', () {
      expect(configHandler.saveSlots, isEmpty);
    });

    test('should add save slots', () {
      final mockSaveSlot = MockSaveSlot();
      when(() => mockSaveSlot.name).thenReturn('Test Slot');
      
      configHandler.saveSlots.add(mockSaveSlot);
      
      expect(configHandler.saveSlots.length, equals(1));
      expect(configHandler.saveSlots.first, equals(mockSaveSlot));
    });

    test('should handle save slot operations', () {
      const slotName = 'Test Configuration';
      
      // This would typically call methods like saveConfiguration, loadConfiguration
      // For now, we test that the save slots list can be manipulated
      final saveSlot = MockSaveSlot();
      when(() => saveSlot.name).thenReturn(slotName);
      
      configHandler.saveSlots.add(saveSlot);
      
      expect(configHandler.saveSlots.any((slot) => slot.name == slotName), isTrue);
    });

    test('should handle multiple save slots', () {
      final slot1 = MockSaveSlot();
      final slot2 = MockSaveSlot();
      final slot3 = MockSaveSlot();
      
      when(() => slot1.name).thenReturn('Slot 1');
      when(() => slot2.name).thenReturn('Slot 2');
      when(() => slot3.name).thenReturn('Slot 3');
      
      configHandler.saveSlots.addAll([slot1, slot2, slot3]);
      
      expect(configHandler.saveSlots.length, equals(3));
    });

    test('should handle save slot removal', () {
      final slot1 = MockSaveSlot();
      final slot2 = MockSaveSlot();
      
      when(() => slot1.name).thenReturn('Slot 1');
      when(() => slot2.name).thenReturn('Slot 2');
      
      configHandler.saveSlots.addAll([slot1, slot2]);
      expect(configHandler.saveSlots.length, equals(2));
      
      configHandler.saveSlots.remove(slot1);
      expect(configHandler.saveSlots.length, equals(1));
      expect(configHandler.saveSlots.first, equals(slot2));
    });
  });

  group('Property Management Integration', () {
    late ConfigHandler configHandler;

    setUp(() {
      configHandler = ConfigHandler(device: mockDevice);
    });

    test('should handle property access with null properties', () {
      // Test graceful handling when properties map is not initialized
      expect(() => configHandler.start, returnsNormally);
      expect(() => configHandler.reset, returnsNormally);
      expect(() => configHandler.setTemp, returnsNormally);
    });

    test('should handle property updates', () {
      configHandler.properties = {
        'test_property': mockProperty,
      };
      
      when(() => mockProperty.value).thenReturn(42);
      
      // Test that properties can be accessed through the base class methods
      expect(() => configHandler.getIntPropertyValue('test_property'), returnsNormally);
    });

    test('should handle missing properties gracefully', () {
      configHandler.properties = {};
      
      // Should not crash when accessing non-existent properties
      expect(() => configHandler.getIntPropertyValue('non_existent'), returnsNormally);
      expect(() => configHandler.getBoolPropertyValue('non_existent'), returnsNormally);
      expect(() => configHandler.getDoublePropertyValue('non_existent'), returnsNormally);
    });

    test('should handle property type conversions', () {
      final intProperty = MockProperty();
      final boolProperty = MockProperty();
      final doubleProperty = MockProperty();
      
      when(() => intProperty.value).thenReturn(42);
      when(() => boolProperty.value).thenReturn(true);
      when(() => doubleProperty.value).thenReturn(3.14);
      
      configHandler.properties = {
        'int_prop': intProperty,
        'bool_prop': boolProperty,
        'double_prop': doubleProperty,
      };
      
      expect(configHandler.getIntPropertyValue('int_prop'), equals(42));
      expect(configHandler.getBoolPropertyValue('bool_prop'), isTrue);
      expect(configHandler.getDoublePropertyValue('double_prop'), equals(3.14));
    });
  });

  group('Error Handling and Edge Cases', () {
    late ConfigHandler configHandler;

    setUp(() {
      configHandler = ConfigHandler(device: mockDevice);
    });

    test('should handle device state errors gracefully', () {
      when(() => mockDevice.state).thenThrow(Exception('State error'));
      
      // Should not crash when accessing currSetTemp
      expect(() => configHandler.currSetTemp, returnsNormally);
    });

    test('should handle null device gracefully', () {
      configHandler.device = null;
      
      // Should handle null device without crashing
      expect(() => configHandler.currSetTemp, returnsNormally);
    });

    test('should handle property update errors', () {
      configHandler.properties = {
        'test_property': mockProperty,
      };
      
      when(() => mockProperty.setValue(any())).thenThrow(Exception('Update failed'));
      
      // Should not crash when property update fails
      expect(() => configHandler.setPropertyValue('test_property', 'value'), returnsNormally);
    });

    test('should handle invalid property values', () {
      configHandler.properties = {
        'test_property': mockProperty,
      };
      
      // Test with null values
      expect(() => configHandler.setPropertyValue('test_property', null), returnsNormally);
      
      // Test with empty string
      expect(() => configHandler.setPropertyValue('test_property', ''), returnsNormally);
    });

    test('should handle database errors during initialization', () {
      when(() => mockSnapshot.value).thenThrow(Exception('Database error'));
      
      // Should handle database errors gracefully
      expect(() => ConfigHandler.fromDatabase(mockSnapshot, mockDevice), returnsNormally);
    });

    test('should maintain state consistency during errors', () {
      configHandler.properties = {
        'start': mockProperty,
        'abort_run': mockProperty,
      };
      
      // Simulate property update failure
      when(() => mockProperty.setValue(any())).thenThrow(Exception('Update failed'));
      
      // Even with errors, the handler should remain in a consistent state
      expect(configHandler.device, equals(mockDevice));
      expect(configHandler.saveSlots, isNotNull);
    });
  });

  group('Complex Integration Scenarios', () {
    late ConfigHandler configHandler;

    setUp(() {
      configHandler = ConfigHandler(device: mockDevice);
      
      // Setup comprehensive property map
      configHandler.properties = {
        'start': mockProperty,
        'abort_run': mockProperty,
        'end_run': mockProperty,
        'set_temp': mockProperty,
        'set_hours': mockProperty,
        'set_minutes': mockProperty,
        'pump_control': mockProperty,
        'enable_cooldown': mockProperty,
        'temp_thresh': mockProperty,
        'flow_thresh': mockProperty,
        'pressure_thresh': mockProperty,
        'batch_size': mockProperty,
        'cool_down_temp': mockProperty,
      };
    });

    test('should handle complete configuration workflow', () {
      // Mock property returns
      when(() => mockProperty.value).thenReturn(0);
      
      // Simulate complete configuration setup
      configHandler.setTemp = 25.0;
      configHandler.setHours = 2;
      configHandler.setMinutes = 30;
      configHandler.batchSize = 100.0;
      configHandler.flowThresh = 10.0;
      configHandler.tempThresh = 2.0;
      configHandler.pressureThresh = 50.0;
      configHandler.pumpControl = true;
      configHandler.enableCooldown = true;
      configHandler.cooldownTemp = 15.0;
      
      // Verify all properties were set
      verify(() => mockProperty.setValue(any())).called(greaterThan(5));
    });

    test('should handle state transitions correctly', () {
      when(() => mockProperty.value).thenReturn(false);
      
      // Simulate operational state changes
      configHandler.start = true;
      configHandler.reset = false;
      configHandler.end = false;
      
      // Verify state change operations
      verify(() => mockProperty.setValue(true)).called(1);
      verify(() => mockProperty.setValue(false)).called(2);
    });

    test('should maintain data consistency across operations', () {
      final startProperty = MockProperty();
      final resetProperty = MockProperty();
      final tempProperty = MockProperty();
      
      when(() => startProperty.value).thenReturn(true);
      when(() => resetProperty.value).thenReturn(false);
      when(() => tempProperty.value).thenReturn(25.0);
      
      configHandler.properties = {
        'start': startProperty,
        'abort_run': resetProperty,
        'set_temp': tempProperty,
      };
      
      // Verify that each property maintains its own state
      expect(configHandler.start, isTrue);
      expect(configHandler.reset, isFalse);
      expect(configHandler.setTemp, equals(25.0));
    });
  });
}