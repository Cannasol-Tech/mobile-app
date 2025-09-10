// System Images Tests
//
// Verifies PumpImage, SonicatorImage, and TankImage render with provider setup.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:cannasoltech_automation/components/system_images/pump_image.dart';
import 'package:cannasoltech_automation/components/system_images/sonicator_image.dart';
import 'package:cannasoltech_automation/components/system_images/tank_image.dart';
import 'package:cannasoltech_automation/shared/constants.dart';

import '../../helpers/mocks.dart';
import '../../helpers/test_utils.dart';

void main() {
  TestEnvironment.setupGroup();

  group('SystemImage widgets', () {
    late MockSystemDataModel systemDataModel;
    late MockDevice device;
    late MockAlarmsModel alarms;
    late MockStateHandler state;

    setUp(() {
      systemDataModel = MockSystemDataModel();
      device = MockDevice();
      alarms = MockAlarmsModel();
      state = MockStateHandler();

      when(() => systemDataModel.alarmFlash).thenReturn(false);
      when(() => systemDataModel.activeDevice).thenReturn(device);
      when(() => device.alarms).thenReturn(alarms);
      when(() => device.state).thenReturn(state);
      when(() => state.state).thenReturn(INIT);

      // Default alarms off
      when(() => alarms.pumpAlarmActive).thenReturn(false);
      when(() => alarms.sonicAlarmActive).thenReturn(false);
      when(() => alarms.tankAlarmActive).thenReturn(false);
    });

    Future<void> _pumpWithProviders(WidgetTester tester, Widget child) async {
      await tester.pumpWidget(createTestAppWithProviders(
        child: Scaffold(body: Center(child: child)),
        systemDataModel: systemDataModel,
      ));
    }

    testWidgets('PumpImage renders without error', (tester) async {
      await _pumpWithProviders(tester, const PumpImage());
      expect(find.byType(PumpImage), findsOneWidget);
    });

    testWidgets('SonicatorImage renders without error', (tester) async {
      await _pumpWithProviders(tester, const SonicatorImage());
      expect(find.byType(SonicatorImage), findsOneWidget);
    });

    testWidgets('TankImage renders without error', (tester) async {
      await _pumpWithProviders(tester, const TankImage());
      expect(find.byType(TankImage), findsOneWidget);
    });
  });
}

