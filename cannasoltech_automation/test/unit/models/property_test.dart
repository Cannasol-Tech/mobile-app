/**
 * @file property_test.dart
 * @author Assistant
 * @date 2025-01-05
 * @brief Comprehensive unit tests for FireProperty class
 * @details Tests all public methods, edge cases, and error conditions
 *          using flutter_test and mocktail for external dependencies
 * @version 1.0
 * @since 1.0
 */

import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:cannasoltech_automation/data_models/property.dart';

import '../../helpers/mocks.dart';

void main() {
  setUpAll(() {
    registerMockFallbacks();
  });

  group('FireProperty', () {
    late MockDatabaseReference mockRef;
    late MockDataSnapshot mockSnapshot;
    late MockDatabaseEvent mockEvent;
    late FireProperty property;

    setUp(() {
      mockRef = MockDatabaseReference();
      mockSnapshot = MockDataSnapshot();
      mockEvent = MockDatabaseEvent();

      property = FireProperty(
        name: 'test_property',
        value: 'initial_value',
        ref: mockRef,
      );

      // Setup default behaviors
      when(() => mockEvent.snapshot).thenReturn(mockSnapshot);
      when(() => mockSnapshot.exists).thenReturn(true);
      when(() => mockSnapshot.value).thenReturn('test_value');
      when(() => mockRef.set(any())).thenAnswer((_) async {});
      when(() => mockRef.once()).thenAnswer((_) async => mockEvent);
    });

    test('should create FireProperty with required parameters', () {
      expect(property.name, equals('test_property'));
      expect(property.value, equals('initial_value'));
      expect(property.ref, equals(mockRef));
    });

    test('should create FireProperty from data entry', () {
      const entry = MapEntry('prop_name', 'prop_value');
      
      final propertyFromData = FireProperty.fromData(entry, mockRef);
      
      expect(propertyFromData.name, equals('prop_name'));
      expect(propertyFromData.value, equals('prop_value'));
      expect(propertyFromData.ref, equals(mockRef));
    });

    test('should set value to Firebase database', () {
      const newValue = 'updated_value';
      
      property.setValue(newValue);
      
      verify(() => mockRef.set(newValue)).called(1);
    });

    test('should set different value types', () {
      // Test with integer
      property.setValue(42);
      verify(() => mockRef.set(42)).called(1);

      // Test with boolean
      property.setValue(true);
      verify(() => mockRef.set(true)).called(1);

      // Test with double
      property.setValue(3.14);
      verify(() => mockRef.set(3.14)).called(1);

      // Test with null
      property.setValue(null);
      verify(() => mockRef.set(null)).called(1);
    });

    test('should get value from Firebase database', () async {
      var capturedValue;
      
      property.getValue(capturedValue);
      
      verify(() => mockRef.once()).called(1);
    });

    test('should listen for changes and update value', () async {
      // Create a stream controller to simulate Firebase events
      final streamController = StreamController<DatabaseEvent>();
      when(() => mockRef.onValue).thenAnswer((_) => streamController.stream);

      bool callbackCalled = false;
      dynamic callbackValue;
      
      final subscription = property.listenForChanges((value) {
        callbackCalled = true;
        callbackValue = value;
      });

      // Simulate a Firebase value change
      const newValue = 'changed_value';
      when(() => mockSnapshot.value).thenReturn(newValue);
      streamController.add(mockEvent);

      // Wait for the stream event to be processed
      await Future.delayed(Duration.zero);

      expect(property.value, equals(newValue));
      expect(callbackCalled, isTrue);
      expect(callbackValue, equals(newValue));

      await subscription.cancel();
      await streamController.close();
    });

    test('should listen for changes without callback', () async {
      final streamController = StreamController<DatabaseEvent>();
      when(() => mockRef.onValue).thenAnswer((_) => streamController.stream);

      final subscription = property.listenForChanges();

      // Simulate a Firebase value change
      const newValue = 'changed_without_callback';
      when(() => mockSnapshot.value).thenReturn(newValue);
      streamController.add(mockEvent);

      // Wait for the stream event to be processed
      await Future.delayed(Duration.zero);

      expect(property.value, equals(newValue));

      await subscription.cancel();
      await streamController.close();
    });

    test('should handle non-existent snapshot in listener', () async {
      final streamController = StreamController<DatabaseEvent>();
      when(() => mockRef.onValue).thenAnswer((_) => streamController.stream);
      when(() => mockSnapshot.exists).thenReturn(false);

      bool callbackCalled = false;
      dynamic callbackValue;
      
      final subscription = property.listenForChanges((value) {
        callbackCalled = true;
        callbackValue = value;
      });

      // Simulate a Firebase event with non-existent snapshot
      streamController.add(mockEvent);

      // Wait for the stream event to be processed
      await Future.delayed(Duration.zero);

      expect(property.value, isNull);
      expect(callbackCalled, isTrue);
      expect(callbackValue, isNull);

      await subscription.cancel();
      await streamController.close();
    });

    test('should handle multiple value changes in listener', () async {
      final streamController = StreamController<DatabaseEvent>();
      when(() => mockRef.onValue).thenAnswer((_) => streamController.stream);

      final receivedValues = <dynamic>[];
      
      final subscription = property.listenForChanges((value) {
        receivedValues.add(value);
      });

      // Simulate multiple Firebase value changes
      final values = ['value1', 'value2', 'value3'];
      
      for (final value in values) {
        when(() => mockSnapshot.value).thenReturn(value);
        streamController.add(mockEvent);
        await Future.delayed(Duration.zero);
      }

      expect(property.value, equals('value3'));
      expect(receivedValues, equals(values));

      await subscription.cancel();
      await streamController.close();
    });

    test('should handle different data types in value changes', () async {
      final streamController = StreamController<DatabaseEvent>();
      when(() => mockRef.onValue).thenAnswer((_) => streamController.stream);

      final receivedValues = <dynamic>[];
      
      final subscription = property.listenForChanges((value) {
        receivedValues.add(value);
      });

      // Test different data types
      final testValues = [
        'string_value',
        42,
        3.14,
        true,
        false,
        {'key': 'value'},
        ['item1', 'item2']
      ];
      
      for (final value in testValues) {
        when(() => mockSnapshot.value).thenReturn(value);
        streamController.add(mockEvent);
        await Future.delayed(Duration.zero);
      }

      expect(receivedValues, equals(testValues));

      await subscription.cancel();
      await streamController.close();
    });
  });
}