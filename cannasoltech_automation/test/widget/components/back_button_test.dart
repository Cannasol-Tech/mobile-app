// backButton Widget Tests
//
// Verifies that tapping the back button pops the current route.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cannasoltech_automation/components/buttons/back_button.dart' as back;

import '../../helpers/test_utils.dart';

class _FirstPage extends StatelessWidget {
  const _FirstPage();
  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('First')));
}

class _SecondPage extends StatelessWidget {
  const _SecondPage();
  @override
  Widget build(BuildContext context) => Scaffold(body: Center(child: back.backButton(context)));
}

void main() {
  TestEnvironment.setupGroup();

  testWidgets('backButton pops current route', (tester) async {
    await tester.pumpWidget(createTestApp(
      child: Navigator(
        onGenerateRoute: (settings) {
          return MaterialPageRoute<void>(
            settings: settings,
            builder: (_) => const _FirstPage(),
          );
        },
      ),
    ));

    // Push second page
    final navState = tester.state<NavigatorState>(find.byType(Navigator));
    navState.push(MaterialPageRoute(builder: (_) => const _SecondPage()));
    await tester.pumpAndSettle();

    expect(find.text('First'), findsNothing);

    // Tap back button
    await tester.tap(find.text('Back'));
    await tester.pumpAndSettle();

    // We should be back on the first page
    expect(find.text('First'), findsOneWidget);
  });
}

