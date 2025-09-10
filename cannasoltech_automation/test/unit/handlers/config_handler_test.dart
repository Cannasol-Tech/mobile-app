// Unit Tests for ConfigHandler
//
// This file contains unit tests for the ConfigHandler class.
//
// Testing Framework: flutter_test + mocktail
// Coverage Target: ≥85% statement coverage

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:cannasoltech_automation/handlers/config_handler.dart';

import '../../helpers/mocks.dart';

void main() {
  group('ConfigHandler', () {
    late ConfigHandler configHandler;
    late MockDevice mockDevice;

    // Mocks for property references
    late MockDatabaseReference setHoursRef;
    late MockDatabaseReference setMinutesRef;
    late MockDatabaseReference setTempRef;
    late MockDatabaseReference batchSizeRef;

    // Helper to create a mock snapshot with config data
    MockDataSnapshot createMockConfigSnapshot(Map<String, dynamic> data, Map<String, MockDatabaseReference> refs) {
      final snapshot = MockDataSnapshot();
      when(() => snapshot.value).thenReturn(data);

      data.forEach((key, value) {
        final childSnapshot = MockDataSnapshot();
        when(() => childSnapshot.ref).thenReturn(refs[key]!);
        when(() => snapshot.child(key)).thenReturn(childSnapshot);
      });

      return snapshot;
    }

    setUp(() {
      mockDevice = MockDevice();
      setHoursRef = MockDatabaseReference();
      setMinutesRef = MockDatabaseReference();
      setTempRef = MockDatabaseReference();
      batchSizeRef = MockDatabaseReference();

      // Stub the set method on all mock references
      when(() => setHoursRef.set(any())).thenAnswer((_) async {});
      when(() => setMinutesRef.set(any())).thenAnswer((_) async {});
      when(() => setTempRef.set(any())).thenAnswer((_) async {});
      when(() => batchSizeRef.set(any())).thenAnswer((_) async {});

      final configData = {
        'set_hours': 5,
        'set_minutes': 30,
        'set_temp': 25.0,
        'batch_size': 10.0,
      };

      final refs = {
        'set_hours': setHoursRef,
        'set_minutes': setMinutesRef,
        'set_temp': setTempRef,
        'batch_size': batchSizeRef,
      };

      final mockSnapshot = createMockConfigSnapshot(configData, refs);
      configHandler = ConfigHandler.fromDatabase(mockSnapshot, mockDevice);
    });

    test('fromDatabase should correctly parse snapshot data', () {
      expect(configHandler.properties.length, 4);
      expect(configHandler.setHours, 5);
      expect(configHandler.setMinutes, 30);
      expect(configHandler.setTemp, 25.0);
      expect(configHandler.batchSize, 10.0);
    });

    test('setTime getter should format time correctly', () {
      expect(configHandler.setTime, '5:30');
    });

    test('setHours setter should update the correct property', () {
      // Act
      configHandler.setHours = 8;

      // Assert
      verify(() => setHoursRef.set(8)).called(1);
      verifyNever(() => setTempRef.set(any()));
    });

    test('setMinutes setter should update the correct property', () {
      // Act
      configHandler.setMinutes = 45;

      // Assert
      verify(() => setMinutesRef.set(45)).called(1);
      verifyNever(() => batchSizeRef.set(any()));
    });
  });
}
