// SystemDisplay Tests
//
// Verifies PumpDisplay and SonicatorDisplay build without error with providers.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:cannasoltech_automation/components/system_display/pump_display.dart';
import 'package:cannasoltech_automation/components/system_display/sonicator_display.dart';
import 'package:cannasoltech_automation/components/sensor_display/flow_display.dart';
import 'package:cannasoltech_automation/components/sensor_display/pressure_display.dart';
import 'package:cannasoltech_automation/components/system_images/pump_image.dart';
import 'package:cannasoltech_automation/components/system_images/sonicator_image.dart';

import '../../helpers/mocks.dart';
import '../../helpers/test_utils.dart';

void main() {
  TestEnvironment.setupGroup();

  group('SystemDisplay', () {
    late MockSystemDataModel systemDataModel;
    late MockDevice device;
    late MockAlarmsModel alarms;
    late MockStateHandler state;

    setUp(() {
      systemDataModel = MockSystemDataModel();
      device = MockDevice();
      alarms = MockAlarmsModel();
      state = MockStateHandler();

      when(() => systemDataModel.activeDevice).thenReturn(device);
      when(() => device.alarms).thenReturn(alarms);
      when(() => device.state).thenReturn(state);

      when(() => alarms.pumpAlarmActive).thenReturn(false);
      when(() => alarms.sonicAlarmActive).thenReturn(false);
      when(() => alarms.tankAlarmActive).thenReturn(false);

      when(() => state.flow).thenReturn(1.0);
      when(() => state.pressure).thenReturn(1.0);
      when(() => state.temperature).thenReturn(1.0);
    });

    Future<void> _pump(WidgetTester tester, Widget child) async {
      await tester.pumpWidget(createTestAppWithProviders(
        child: Scaffold(body: Center(child: child)),
        systemDataModel: systemDataModel,
      ));
    }

    testWidgets('PumpDisplay renders image and sensor display', (tester) async {
      await _pump(tester, const PumpDisplay());
      expect(find.byType(PumpImage), findsOneWidget);
      expect(find.byType(FlowDisplay), findsOneWidget);
    });

    testWidgets('SonicatorDisplay renders image and sensor display', (tester) async {
      await _pump(tester, const SonicatorDisplay());
      expect(find.byType(SonicatorImage), findsOneWidget);
      expect(find.byType(PressureDisplay), findsOneWidget);
    });
  });
}

