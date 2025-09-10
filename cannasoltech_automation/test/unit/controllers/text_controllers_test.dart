// Unit Tests for Text Controllers
//
// This file contains unit tests for SetTimeController and TextControllers.
//
// Testing Framework: flutter_test + mocktail
// Coverage Target: ≥85% statement coverage

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:cannasoltech_automation/controllers/text_controllers.dart';

import '../../helpers/mocks.dart';

void main() {
  group('SetTimeController', () {
    late SetTimeController controller;

    setUp(() {
      controller = SetTimeController();
    });

    test('should initialize with updateBlock as false', () {
      expect(controller.updateBlock, isFalse);
    });

    test('lock should set updateBlock to true', () {
      controller.lock();
      expect(controller.updateBlock, isTrue);
    });

    test('unlock should set updateBlock to false', () {
      controller.lock(); // Lock it first
      controller.unlock();
      expect(controller.updateBlock, isFalse);
    });

    test('updateText should not update text when blocked', () {
      controller.text = 'initial';
      controller.lock();
      controller.updateText('updated');
      expect(controller.text, 'initial');
    });

    test('updateText should update text when not blocked', () {
      controller.text = 'initial';
      controller.updateText('updated');
      expect(controller.text, 'updated');
    });
  });

  group('TextControllers', () {
    late TextControllers controllers;
    late MockDevice mockDevice;
    late MockConfigHandler mockConfig;
    late MockStateHandler mockState;

    setUp(() {
      controllers = TextControllers();
      mockDevice = MockDevice();
      mockConfig = MockConfigHandler();
      mockState = MockStateHandler();

      // Mock the device properties
      when(() => mockDevice.config).thenReturn(mockConfig);
      when(() => mockDevice.state).thenReturn(mockState);
      when(() => mockDevice.id).thenReturn('test_device_id');

      // Mock config properties
      when(() => mockConfig.setTime).thenReturn('12:30');
      when(() => mockConfig.batchSize).thenReturn(10.5);
      when(() => mockConfig.setTemp).thenReturn(25.5);
      when(() => mockConfig.tempThresh).thenReturn(1.50);
      when(() => mockConfig.flowThresh).thenReturn(5.5);
      when(() => mockConfig.pressureThresh).thenReturn(15.5);
      when(() => mockConfig.cooldownTemp).thenReturn(20.5);

      // Mock state properties
      when(() => mockState.state).thenReturn(1);
    });

    test('init should set all controller values from device data', () {
      // Act
      controllers.init(mockDevice);

      // Assert
      expect(controllers.stateController.text, '1');
      expect(controllers.setTimeController.text, '12:30');
      expect(controllers.batchSizeController.text, '10.5');
      expect(controllers.setTempController.text, '25.5');
      expect(controllers.tempThreshController.text, '1.50');
      expect(controllers.flowThreshController.text, '5.5');
      expect(controllers.pressureThreshController.text, '15.5');
      expect(controllers.coolDownTempController.text, '20.5');
    });

    test('clear should clear all controllers', () {
      // Arrange
      controllers.init(mockDevice);

      // Act
      controllers.clear();

      // Assert
      expect(controllers.stateController.text, '');
      expect(controllers.setTimeController.text, '');
      expect(controllers.batchSizeController.text, '');
    });
  });
}
