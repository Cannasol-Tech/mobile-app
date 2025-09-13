// signOutButton Tests
//
// Verifies that tapping sign out shows confirmation dialog and dismisses on No.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cannasoltech_automation/components/sign_out_button.dart';

import '../../helpers/test_utils.dart';

void main() {
  TestEnvironment.setupGroup();

  testWidgets('shows confirm dialog and dismisses with No', (tester) async {
    await tester.pumpWidget(createTestApp(
      child: Scaffold(
        body: Center(child: signOutButton(null, Colors.blueGrey, 'Sign Out', 'hero')),
      ),
    ));

    // Tap the sign-out button
    await tester.tap(find.text('Sign Out'));
    await tester.pumpAndSettle();

    expect(find.text('Notice!'), findsOneWidget);
    expect(find.text('Are you sure you want to sign out?'), findsOneWidget);

    // Tap No to dismiss
    await tester.tap(find.text('No'));
    await tester.pumpAndSettle();

    expect(find.text('Notice!'), findsNothing);
  });
}

