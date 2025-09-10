// Unit Tests for StateHandler
//
// This file contains unit tests for the StateHandler class.
//
// Testing Framework: flutter_test + mocktail
// Coverage Target: ≥85% statement coverage

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:cannasoltech_automation/handlers/state_handler.dart';
import 'package:cannasoltech_automation/data_models/device.dart';

import '../../helpers/mocks.dart';

void main() {
  group('StateHandler', () {
    late StateHandler stateHandler;
    late MockDevice mockDevice;
    late MockDataSnapshot mockSnapshot;

    // Helper to create a mock snapshot with state data
    MockDataSnapshot createMockStateSnapshot(Map<String, dynamic> data) {
      final snapshot = MockDataSnapshot();
      when(() => snapshot.value).thenReturn(data);

      data.forEach((key, value) {
        final childSnapshot = MockDataSnapshot();
        final mockRef = MockDatabaseReference();
        when(() => childSnapshot.ref).thenReturn(mockRef);
        when(() => snapshot.child(key)).thenReturn(childSnapshot);
      });

      return snapshot;
    }

    setUp(() {
      mockDevice = MockDevice();
      final stateData = {
        'state': 1,
        'run_hours': 2,
        'run_minutes': 30,
        'run_seconds': 15,
        'flow': 10.5,
        'pressure': 20.5,
        'temperature': 25.5,
      };
      mockSnapshot = createMockStateSnapshot(stateData);
      stateHandler = StateHandler.fromDatabase(mockSnapshot, mockDevice);
    });

    test('fromDatabase should correctly parse snapshot data', () {
      expect(stateHandler.properties.length, 7);
      expect(stateHandler.state, 1);
      expect(stateHandler.runHours, 2);
      expect(stateHandler.runMinutes, 30);
      expect(stateHandler.runSeconds, 15);
      expect(stateHandler.flow, 10.5);
      expect(stateHandler.pressure, 20.5);
      expect(stateHandler.temperature, 25.5);
    });

    test('runTime getter should format time correctly', () {
      expect(stateHandler.runTime, '2:30:15');
    });

    test('isOnline getter should reflect device status', () {
      when(() => mockDevice.isOnline()).thenReturn(true);
      expect(stateHandler.isOnline, isTrue);

      when(() => mockDevice.isOnline()).thenReturn(false);
      expect(stateHandler.isOnline, isFalse);
    });
  });
}
