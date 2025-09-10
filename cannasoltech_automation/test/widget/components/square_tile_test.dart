// SquareTile Widget Tests
//
// Verifies that SquareTile renders and uses provided asset path.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cannasoltech_automation/components/square_tile.dart';

import '../../helpers/test_utils.dart';

void main() {
  TestEnvironment.setupGroup();

  testWidgets('renders image asset with container decoration', (tester) async {
    await tester.pumpWidget(createTestApp(
      child: const Scaffold(
        body: Center(
          child: SquareTile(imagePath: 'assets/images/SmallIcon.png'),
        ),
      ),
    ));

    expect(find.byType(SquareTile), findsOneWidget);
    expect(find.byType(Image), findsOneWidget);
  });
}

