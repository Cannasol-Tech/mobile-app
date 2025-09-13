// Unit Tests for SaveSlot and StagedSlot
//
// This file contains unit tests for the classes in `objects/save_slot.dart`.
//
// Testing Framework: flutter_test + mocktail
// Coverage Target: ≥95% statement coverage

import 'package:cannasoltech_automation/data_models/device.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:cannasoltech_automation/objects/save_slot.dart';
import 'package:cannasoltech_automation/handlers/config_handler.dart';

import '../../helpers/mocks.dart';

void main() {
  group('StagedSlot', () {
    test('fromConfig should correctly copy values', () {
      // Arrange
      final mockConfig = MockConfigHandler();
      when(() => mockConfig.setHours).thenReturn(5);
      when(() => mockConfig.setMinutes).thenReturn(30);
      when(() => mockConfig.setTemp).thenReturn(25.0);
      when(() => mockConfig.batchSize).thenReturn(10.0);
      when(() => mockConfig.tempThresh).thenReturn(1.5);
      when(() => mockConfig.flowThresh).thenReturn(5.5);
      when(() => mockConfig.pressureThresh).thenReturn(15.5);
      when(() => mockConfig.enableCooldown).thenReturn(true);
      when(() => mockConfig.cooldownTemp).thenReturn(20.0);

      // Act
      final stagedSlot = StagedSlot.fromConfig(mockConfig);

      // Assert
      expect(stagedSlot.hours, 5);
      expect(stagedSlot.minutes, 30);
      expect(stagedSlot.setTemp, 25.0);
      expect(stagedSlot.cooldownEnabled, isTrue);
    });
  });

  group('SaveSlot', () {
    late TestSaveSlot saveSlot;
    late MockDevice mockDevice;
    late MockConfigHandler mockConfig;

    setUp(() {
      mockDevice = MockDevice();
      mockConfig = MockConfigHandler();
      when(() => mockDevice.config).thenReturn(mockConfig);

      saveSlot = TestSaveSlot(device: mockDevice, idx: 1);
    });

    test('save method should call the correct property setters', () {
      // Arrange
      when(() => mockConfig.setHours).thenReturn(5);
      when(() => mockConfig.setMinutes).thenReturn(30);
      when(() => mockConfig.setTemp).thenReturn(25.0);
      when(() => mockConfig.batchSize).thenReturn(10.0);
      when(() => mockConfig.tempThresh).thenReturn(1.5);
      when(() => mockConfig.flowThresh).thenReturn(5.5);
      when(() => mockConfig.pressureThresh).thenReturn(15.5);
      when(() => mockConfig.enableCooldown).thenReturn(true);
      when(() => mockConfig.cooldownTemp).thenReturn(20.0);

      // Act
      saveSlot.save();

      // Assert
      expect(saveSlot.calls['hours'], 5);
      expect(saveSlot.calls['minutes'], 30);
      expect(saveSlot.calls['set_temp'], 25.0);
      expect(saveSlot.calls['batch_size'], 10.0);
      expect(saveSlot.calls['temp_var'], 1.5);
      expect(saveSlot.calls['min_flow'], 5.5);
      expect(saveSlot.calls['min_pressure'], 15.5);
      expect(saveSlot.calls['enable_cooldown'], true); // This will fail
      expect(saveSlot.calls['cool_down_temp'], 20.0);
    });
  });
}

// Test class to spy on method calls
class TestSaveSlot extends SaveSlot {
  final Map<String, dynamic> calls = {};

  TestSaveSlot({required Device device, required int idx})
      : super(device: device, idx: idx);

  @override
  void setIntPropertyValue(String propertyName, dynamic value) {
    calls[propertyName] = value;
  }

  @override
  void setDoublePropertyValue(String propertyName, dynamic value) {
    calls[propertyName] = value;
  }

  @override
  void setBoolPropertyValue(String name, bool value) {
    calls[name] = value;
  }
}
