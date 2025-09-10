// LoginOrRegisterPage Tests
//
// Verifies toggling between sign-in and registration pages.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cannasoltech_automation/pages/login_or_reg_page.dart';

import '../../helpers/test_utils.dart';

void main() {
  TestEnvironment.setupGroup();

  testWidgets('toggles between sign-in and register views', (tester) async {
    await tester.pumpWidget(createTestApp(child: const LoginOrRegisterPage()));

    // Initially sign-in page content should be visible
    expect(find.text('Sign In'), findsWidgets);

    // Tap the "Register now" link to toggle
    await tester.tap(find.text('Register now'));
    await tester.pumpAndSettle();

    // Register page visible (Sign Up button)
    expect(find.text('Sign Up'), findsWidgets);

    // Toggle back to sign-in
    await tester.tap(find.text('Login now'));
    await tester.pumpAndSettle();
    expect(find.text('Sign In'), findsWidgets);
  });
}

