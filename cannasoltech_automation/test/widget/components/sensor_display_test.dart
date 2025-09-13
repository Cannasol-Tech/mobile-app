// Sensor Display Widgets Tests
//
// Verifies TemperatureDisplay, PressureDisplay, and FlowDisplay show formatted values and units.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:cannasoltech_automation/components/sensor_display/temp_display.dart';
import 'package:cannasoltech_automation/components/sensor_display/pressure_display.dart';
import 'package:cannasoltech_automation/components/sensor_display/flow_display.dart';

import '../../helpers/mocks.dart';
import '../../helpers/test_utils.dart';

void main() {
  TestEnvironment.setupGroup();

  group('SensorDisplay widgets', () {
    late MockSystemDataModel systemDataModel;
    late MockDevice device;
    late MockAlarmsModel alarms;
    late MockStateHandler state;

    setUp(() {
      systemDataModel = MockSystemDataModel();
      device = MockDevice();
      alarms = MockAlarmsModel();
      state = MockStateHandler();

      // Provider tree stubs
      when(() => systemDataModel.activeDevice).thenReturn(device);
      when(() => device.alarms).thenReturn(alarms);
      when(() => device.state).thenReturn(state);

      // Default: no alarms/warns
      when(() => alarms.tempWarn).thenReturn(false);
      when(() => alarms.tempAlarm).thenReturn(false);
      when(() => alarms.pressureWarn).thenReturn(false);
      when(() => alarms.sonicAlarmActive).thenReturn(false);
      when(() => alarms.flowWarn).thenReturn(false);
      when(() => alarms.flowAlarm).thenReturn(false);
    });

    Future<void> _pump(WidgetTester tester, Widget child) async {
      await tester.pumpWidget(createTestAppWithProviders(
        child: Scaffold(body: Center(child: child)),
        systemDataModel: systemDataModel,
      ));
    }

    testWidgets('TemperatureDisplay shows value and units', (tester) async {
      when(() => state.temperature).thenReturn(25.5);

      await _pump(tester, const TemperatureDisplay());
      expect(find.textContaining('25.5'), findsOneWidget);
      expect(find.textContaining('℃'), findsOneWidget);
    });

    testWidgets('PressureDisplay shows value and units', (tester) async {
      when(() => state.pressure).thenReturn(2.3);

      await _pump(tester, const PressureDisplay());
      expect(find.textContaining('2.3'), findsOneWidget);
      expect(find.textContaining('psi'), findsOneWidget);
    });

    testWidgets('FlowDisplay shows value and units', (tester) async {
      when(() => state.flow).thenReturn(1.2);

      await _pump(tester, const FlowDisplay());
      expect(find.textContaining('1.2'), findsOneWidget);
      expect(find.textContaining('L/min'), findsOneWidget);
    });
  });
}

