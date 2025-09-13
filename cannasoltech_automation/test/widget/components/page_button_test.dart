// PageButton Tests
//
// Verifies that tapping PageButton navigates to the provided page and optionally pops.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cannasoltech_automation/components/buttons/page_button.dart';

import '../../helpers/test_utils.dart';

class _DestPage extends StatelessWidget {
  const _DestPage();
  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('Destination')));
}

void main() {
  TestEnvironment.setupGroup();

  testWidgets('navigates to new page when tapped', (tester) async {
    await tester.pumpWidget(createTestApp(
      child: Scaffold(
        body: Center(
          child: PageButton(
            hero: 'test',
            color: Colors.blueGrey,
            buttonText: 'Go',
            newPage: const _DestPage(),
            pop: false,
          ),
        ),
      ),
    ));

    await tester.tap(find.text('Go'));
    await tester.pumpAndSettle();
    expect(find.text('Destination'), findsOneWidget);
  });
}

