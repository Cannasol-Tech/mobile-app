import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:cannasoltech_automation/components/bottom_nav_bar.dart';
import 'package:cannasoltech_automation/providers/display_data_provider.dart';

import '../../helpers/golden_utils.dart';

void main() {
  group('BottomNavBar golden', () {
    testWidgets('light theme - 4 tabs default selection', (tester) async {
      final widget = MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => DisplayDataModel()),
        ],
        child: GoldenUtils.appWrapper(
          child: SizedBox(
            width: 400,
            height: 120,
            child: BottomNavBar(),
          ),
          themeMode: ThemeMode.light,
        ),
      );

      await tester.pumpWidget(widget);
      await GoldenUtils.settleAnimations(tester);

      await expectLater(
        find.byType(BottomNavBar),
        matchesGoldenFile('test/golden/screenshots/bottom_nav_bar_light.png'),
      );
    });
  });
}

