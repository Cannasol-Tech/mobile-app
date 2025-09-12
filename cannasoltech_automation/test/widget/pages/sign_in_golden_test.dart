// Golden tests for SignInPage (visual regression)
// Runs only when ENABLE_GOLDEN_TESTS=true

import 'dart:io' show Platform;
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:cannasoltech_automation/pages/sign_in.dart';
import 'package:cannasoltech_automation/providers/system_data_provider.dart';

import '../../helpers/mocks.dart';
import '../../helpers/test_utils.dart';

void main() {
  const enableGoldens = bool.fromEnvironment('ENABLE_GOLDEN_TESTS', defaultValue: false);

  group('Golden - SignInPage', () {
    testWidgets('default view', (tester) async {
      if (!enableGoldens) {
        return; // Skip when goldens disabled
      }

      final systemDataModel = MockSystemDataModel();

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<SystemIdx>.value(value: MockSystemIdx()),
            ChangeNotifierProvider<SystemDataModel>.value(value: systemDataModel),
          ],
          child: const MaterialApp(
            home: Scaffold(body: SignInPage1(toggleFn: null)),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Take golden
      await expectLater(
        find.byType(SignInPage1),
        matchesGoldenFile('test/widget/golden/screenshots/sign_in_page.default.png'),
      );
    });
  });
}
