// Unit Tests for AlarmHandler Models
//
// This file contains unit tests for the models within the alarm_handler.dart file,
// including IgnoredAlarmsModel, WarningsModel, and AlarmsModel.
//
// Testing Framework: flutter_test + mocktail
// Coverage Target: ≥85% statement coverage

import 'package:flutter_test/flutter_test.dart';
import 'package:cannasoltech_automation/handlers/alarm_handler.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/mocks.dart';

void main() {
  group('IgnoredAlarmsModel', () {
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
  });

  group('WarningsModel', () {
    test('fromDatabase should correctly parse data', () {
      // Arrange
      final data = {
        'flow': true,
        'pressure': false,
        'temp': true,
      };

      // Act
      final model = WarningsModel.fromDatabase(data);

      // Assert
      expect(model.flow, isTrue);
      expect(model.pressure, isFalse);
      expect(model.temp, isTrue);
    });

    test('fromDatabase should handle missing keys gracefully', () {
      // Arrange
      final data = {
        'flow': true,
        'temp': true,
      };

      // Act & Assert
      expect(() => WarningsModel.fromDatabase(data), throwsA(isA<TypeError>()));
    });

    test('fromDatabase should correctly parse data with all false values', () {
      // Arrange
      final data = {
        'flow': false,
        'pressure': false,
        'temp': false,
      };

      // Act
      final model = WarningsModel.fromDatabase(data);

      // Assert
      expect(model.flow, isFalse);
      expect(model.pressure, isFalse);
      expect(model.temp, isFalse);
    });
    });

  group('AlarmsModel', () {
    late MockDataSnapshot mockSnapshot;

    // Helper to create a mock snapshot with alarm data
    MockDataSnapshot createMockAlarmSnapshot(Map<String, dynamic> data) {
      final snapshot = MockDataSnapshot();
      when(() => snapshot.value).thenReturn(data);

      // Mock the .child() method for the factory
      data.forEach((key, value) {
        final childSnapshot = MockDataSnapshot();
        when(() => childSnapshot.ref).thenReturn(MockDatabaseReference());
        when(() => snapshot.child(key)).thenReturn(childSnapshot);
      });

      return snapshot;
    }

    test('fromDatabase should correctly parse snapshot data', () {
      // Arrange
      final alarmData = {
        'flow_alarm': true,
        'temp_alarm': false,
        'pressure_alarm': true,
      };
      mockSnapshot = createMockAlarmSnapshot(alarmData);

      // Act
      final model = AlarmsModel.fromDatabase(mockSnapshot);

      // Assert
      expect(model.properties.length, 3);
      expect(model.flowAlarm, isTrue);
      expect(model.tempAlarm, isFalse);
      expect(model.pressureAlarm, isTrue);
    });

    test('computed properties should calculate correctly', () {
      // Arrange
      final alarmData = {
        'flow_alarm': true,
        'ign_flow_alarm': false,
        'temp_alarm': true,
        'ign_temp_alarm': true, // Ignored
        'pressure_alarm': true,
        'ign_pressure_alarm': false,
        'overload_alarm': false,
        'freq_lock_alarm': true,
        'ign_freqlock_alarm': false,
      };
      mockSnapshot = createMockAlarmSnapshot(alarmData);
      final model = AlarmsModel.fromDatabase(mockSnapshot);

      // Act & Assert
      expect(model.pumpAlarmActive, isTrue); // flowAlarm is active and not ignored
      expect(model.tankAlarmActive, isFalse); // tempAlarm is active but ignored
      expect(model.sonicAlarmActive, isTrue); // pressure and freqLock are active and not ignored
      expect(model.getActiveSonicAlarmCount(), 2);
    });
  });
}
