// Arrow Buttons Tests
//
// Verifies that tapping arrow buttons updates SystemIdx as expected.

import 'package:cannasoltech_automation/providers/system_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:cannasoltech_automation/components/icons/arrows.dart';

import '../../helpers/test_utils.dart';
import '../../helpers/mocks.dart';

void main() {
  TestEnvironment.setupGroup();

  group('Arrow buttons', () {
    late MockSystemDataModel systemDataModel;
    late MockAlarmsModel alarms;

    setUp(() {
      systemDataModel = MockSystemDataModel();
      alarms = MockAlarmsModel();
      when(() => systemDataModel.activeDevice).thenReturn(MockDevice());
      when(() => systemDataModel.activeDevice!.alarms).thenReturn(alarms);
      when(() => alarms.tankAlarmActive).thenReturn(false);
      when(() => alarms.pumpAlarmActive).thenReturn(false);
      when(() => alarms.sonicAlarmActive).thenReturn(false);
    });

    Future<(SystemIdx,)> _pump(WidgetTester tester, Widget child) async {
      final realIdx = SystemIdx();
      await tester.binding.setSurfaceSize(const Size(400, 800)); // Portrait
      await tester.pumpWidget(createTestAppWithProviders(
        child: Scaffold(body: Center(child: child)),
        systemDataModel: systemDataModel,
        systemIdx: realIdx,
      ));
      return (realIdx,);
    }

    testWidgets('RightPumpArrow increments SystemIdx', (tester) async {
      final (idx,) = await _pump(tester, RightPumpArrow());
      expect(idx.value, equals(0));
      await tester.tap(find.byType(RightPumpArrow));
      await tester.pumpAndSettle();
      expect(idx.value, equals(1));
    });

    testWidgets('LeftPumpArrow decrements SystemIdx when > min',
        (tester) async {
      final (idx,) = await _pump(tester, LeftPumpArrow());
      idx.set(1);
      await tester.pump();
      await tester.tap(find.byType(LeftPumpArrow));
      await tester.pumpAndSettle();
      expect(idx.value, equals(0));
    });
  });
}
