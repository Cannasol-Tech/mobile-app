// Save/Load Pages Tests
//
// Verifies that pages render the "No Device Selected!" state when there is no active device.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:cannasoltech_automation/pages/save_page.dart';
import 'package:cannasoltech_automation/pages/load_page.dart';

import '../../helpers/mocks.dart';
import '../../helpers/test_utils.dart';

void main() {
  TestEnvironment.setupGroup();

  group('Save/Load Pages (no device)', () {
    late MockSystemDataModel systemDataModel;

    setUp(() {
      systemDataModel = MockSystemDataModel();
      when(() => systemDataModel.activeDevice).thenReturn(null);
    });

    Future<void> _pump(WidgetTester tester, Widget child) async {
      await tester.pumpWidget(createTestAppWithProviders(
        child: child,
        systemDataModel: systemDataModel,
      ));
    }

    testWidgets('SavePage shows no device message', (tester) async {
      await _pump(tester, const SavePage());
      expect(find.text('No Device Selected!'), findsOneWidget);
    });

    testWidgets('LoadPage shows no device message', (tester) async {
      await _pump(tester, const LoadPage());
      expect(find.text('No Device Selected!'), findsOneWidget);
    });
  });
}

