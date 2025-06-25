import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:cannasoltech_automation/components/bottom_nav_bar.dart';
import 'package:cannasoltech_automation/providers/display_data_provider.dart';
import 'package:cannasoltech_automation/providers/system_data_provider.dart';

void main() {
  group('BottomNavBar Widget Tests', () {
    testWidgets('Renders with navigation items', (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => DisplayDataModel()),
            ChangeNotifierProvider(create: (_) => SystemDataModel()),
          ],
          child: MaterialApp(
            home: Scaffold(
              bottomNavigationBar: BottomNavBar(),
            ),
          ),
        ),
      );

      expect(find.byType(BottomNavBar), findsOneWidget);
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Configuration'), findsOneWidget);
    });
  });
}
