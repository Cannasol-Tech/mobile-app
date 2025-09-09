// Sign In Page Widget Tests
//
// This file contains comprehensive widget tests for the SignInPage component.
// Tests verify UI behavior, form validation, authentication flow, and user interactions.
//
// Testing Framework: flutter_test + mocktail
// Standards: Follow Axovia Flow Flutter testing standards

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mocktail/mocktail.dart';

import 'package:cannasoltech_automation/pages/sign_in.dart';
import 'package:cannasoltech_automation/handlers/user_handler.dart';

// Import centralized test helpers
import '../../helpers/mocks.dart';
import '../../helpers/test_data.dart';
import '../../helpers/test_utils.dart';

void main() {
  // Setup test environment
  TestEnvironment.setupGroup();

  group('SignInPage Widget Tests', () {
    late AuthMockSetup authMocks;

    setUp(() {
      authMocks = MockSetup.createAuthMocks();
    });

    group('Rendering Tests', () {
      testWidgets('should render sign in form with all required fields', 
          (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(
          createTestApp(
            child: Provider<UserHandler>.value(
              value: authMocks.userHandler,
              child: const SignInPage(),
            ),
          ),
        );

        // Assert
        TestAssertions.expectVisible(find.byType(SignInPage));
        TestAssertions.expectVisible(TestFinders.emailField);
        TestAssertions.expectVisible(TestFinders.passwordField);
        TestAssertions.expectVisible(TestFinders.signInButton);
      });

      testWidgets('should display app title and branding', 
          (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(
          createTestApp(
            child: Provider<UserHandler>.value(
              value: authMocks.userHandler,
              child: const SignInPage(),
            ),
          ),
        );

        // Assert
        TestAssertions.expectVisible(find.text(UITestData.appTitle));
        TestAssertions.expectVisible(find.text(UITestData.signInTitle));
      });

      testWidgets('should display Google Sign-In button', 
          (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(
          createTestApp(
            child: Provider<UserHandler>.value(
              value: authMocks.userHandler,
              child: const SignInPage(),
            ),
          ),
        );

        // Assert
        TestAssertions.expectVisible(TestFinders.googleSignInButton);
      });

      testWidgets('should display forgot password link', 
          (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(
          createTestApp(
            child: Provider<UserHandler>.value(
              value: authMocks.userHandler,
              child: const SignInPage(),
            ),
          ),
        );

        // Assert
        TestAssertions.expectVisible(TestFinders.forgotPasswordButton);
      });

      testWidgets('should display sign up navigation link', 
          (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(
          createTestApp(
            child: Provider<UserHandler>.value(
              value: authMocks.userHandler,
              child: const SignInPage(),
            ),
          ),
        );

        // Assert
        TestAssertions.expectVisible(find.text('Don\'t have an account?'));
        TestAssertions.expectVisible(find.text('Sign Up'));
      });
    });

    group('Form Validation Tests', () {
      testWidgets('should show error for invalid email format', 
          (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(
          createTestApp(
            child: Provider<UserHandler>.value(
              value: authMocks.userHandler,
              child: const SignInPage(),
            ),
          ),
        );

        // Act
        await TestInteractions.enterText(
          tester, 
          TestFinders.emailField, 
          AuthTestData.invalidEmail,
        );
        await TestInteractions.enterText(
          tester, 
          TestFinders.passwordField, 
          AuthTestData.validPassword,
        );
        await TestInteractions.tap(tester, TestFinders.signInButton);
        await tester.pumpAndSettle();

        // Assert
        TestAssertions.expectErrorMessage(UITestData.invalidEmailError);
      });

      testWidgets('should show error for empty email', 
          (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(
          createTestApp(
            child: Provider<UserHandler>.value(
              value: authMocks.userHandler,
              child: const SignInPage(),
            ),
          ),
        );

        // Act
        await TestInteractions.enterText(
          tester, 
          TestFinders.passwordField, 
          AuthTestData.validPassword,
        );
        await TestInteractions.tap(tester, TestFinders.signInButton);
        await tester.pumpAndSettle();

        // Assert
        TestAssertions.expectErrorMessage('Email is required');
      });

      testWidgets('should show error for empty password', 
          (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(
          createTestApp(
            child: Provider<UserHandler>.value(
              value: authMocks.userHandler,
              child: const SignInPage(),
            ),
          ),
        );

        // Act
        await TestInteractions.enterText(
          tester, 
          TestFinders.emailField, 
          AuthTestData.validEmail,
        );
        await TestInteractions.tap(tester, TestFinders.signInButton);
        await tester.pumpAndSettle();

        // Assert
        TestAssertions.expectErrorMessage(UITestData.emptyPasswordError);
      });

      testWidgets('should validate form before submission', 
          (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(
          createTestApp(
            child: Provider<UserHandler>.value(
              value: authMocks.userHandler,
              child: const SignInPage(),
            ),
          ),
        );

        // Act - Submit empty form
        await TestInteractions.tap(tester, TestFinders.signInButton);
        await tester.pumpAndSettle();

        // Assert - Should not call authentication
        verifyNever(() => authMocks.firebaseAuth.signInWithEmailAndPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ));
      });
    });

    group('Authentication Flow Tests', () {
      testWidgets('should perform successful email sign in', 
          (WidgetTester tester) async {
        // Arrange
        when(() => authMocks.userHandler.signInWithEmailAndPassword(
          any(), any(),
        )).thenAnswer((_) async => true);

        await tester.pumpWidget(
          createTestApp(
            child: Provider<UserHandler>.value(
              value: authMocks.userHandler,
              child: const SignInPage(),
            ),
          ),
        );

        // Act
        await TestInteractions.performSignIn(tester);

        // Assert
        verify(() => authMocks.userHandler.signInWithEmailAndPassword(
          AuthTestData.validEmail,
          AuthTestData.validPassword,
        )).called(1);
      });

      testWidgets('should handle sign in failure', 
          (WidgetTester tester) async {
        // Arrange
        when(() => authMocks.userHandler.signInWithEmailAndPassword(
          any(), any(),
        )).thenAnswer((_) async => false);

        await tester.pumpWidget(
          createTestApp(
            child: Provider<UserHandler>.value(
              value: authMocks.userHandler,
              child: const SignInPage(),
            ),
          ),
        );

        // Act
        await TestInteractions.performSignIn(tester);

        // Assert
        TestAssertions.expectErrorMessage(UITestData.invalidLoginError);
      });

      testWidgets('should show loading indicator during sign in', 
          (WidgetTester tester) async {
        // Arrange
        when(() => authMocks.userHandler.signInWithEmailAndPassword(
          any(), any(),
        )).thenAnswer((_) async {
          await Future.delayed(const Duration(milliseconds: 100));
          return true;
        });

        await tester.pumpWidget(
          createTestApp(
            child: Provider<UserHandler>.value(
              value: authMocks.userHandler,
              child: const SignInPage(),
            ),
          ),
        );

        // Act
        await TestInteractions.enterText(
          tester, 
          TestFinders.emailField, 
          AuthTestData.validEmail,
        );
        await TestInteractions.enterText(
          tester, 
          TestFinders.passwordField, 
          AuthTestData.validPassword,
        );
        await TestInteractions.tap(tester, TestFinders.signInButton);
        await tester.pump();

        // Assert
        TestAssertions.expectLoading();
      });

      testWidgets('should perform Google sign in', 
          (WidgetTester tester) async {
        // Arrange
        when(() => authMocks.userHandler.signInWithGoogle())
            .thenAnswer((_) async => true);

        await tester.pumpWidget(
          createTestApp(
            child: Provider<UserHandler>.value(
              value: authMocks.userHandler,
              child: const SignInPage(),
            ),
          ),
        );

        // Act
        await TestInteractions.tap(tester, TestFinders.googleSignInButton);
        await tester.pumpAndSettle();

        // Assert
        verify(() => authMocks.userHandler.signInWithGoogle()).called(1);
      });

      testWidgets('should handle Google sign in failure', 
          (WidgetTester tester) async {
        // Arrange
        when(() => authMocks.userHandler.signInWithGoogle())
            .thenAnswer((_) async => false);

        await tester.pumpWidget(
          createTestApp(
            child: Provider<UserHandler>.value(
              value: authMocks.userHandler,
              child: const SignInPage(),
            ),
          ),
        );

        // Act
        await TestInteractions.tap(tester, TestFinders.googleSignInButton);
        await tester.pumpAndSettle();

        // Assert
        TestAssertions.expectErrorMessage(UITestData.googleSignInFailedError);
      });
    });

    group('Navigation Tests', () {
      testWidgets('should navigate to sign up page', 
          (WidgetTester tester) async {
        // Arrange
        bool navigatedToSignUp = false;

        await tester.pumpWidget(
          MaterialApp(
            home: Provider<UserHandler>.value(
              value: authMocks.userHandler,
              child: const SignInPage(),
            ),
            routes: {
              '/signup': (context) {
                navigatedToSignUp = true;
                return const Scaffold(body: Text('Sign Up Page'));
              },
            },
          ),
        );

        // Act
        await TestInteractions.tap(tester, find.text('Sign Up'));
        await tester.pumpAndSettle();

        // Assert
        expect(navigatedToSignUp, isTrue);
      });

      testWidgets('should navigate to forgot password page', 
          (WidgetTester tester) async {
        // Arrange
        bool navigatedToForgotPassword = false;

        await tester.pumpWidget(
          MaterialApp(
            home: Provider<UserHandler>.value(
              value: authMocks.userHandler,
              child: const SignInPage(),
            ),
            routes: {
              '/forgot-password': (context) {
                navigatedToForgotPassword = true;
                return const Scaffold(body: Text('Forgot Password Page'));
              },
            },
          ),
        );

        // Act
        await TestInteractions.tap(tester, TestFinders.forgotPasswordButton);
        await tester.pumpAndSettle();

        // Assert
        expect(navigatedToForgotPassword, isTrue);
      });
    });

    group('Accessibility Tests', () {
      testWidgets('should have proper semantic labels', 
          (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(
          createTestApp(
            child: Provider<UserHandler>.value(
              value: authMocks.userHandler,
              child: const SignInPage(),
            ),
          ),
        );

        // Assert
        final emailField = tester.widget<TextField>(TestFinders.emailField);
        final passwordField = tester.widget<TextField>(TestFinders.passwordField);
        
        expect(emailField.decoration?.labelText, equals(UITestData.emailLabel));
        expect(passwordField.decoration?.labelText, equals(UITestData.passwordLabel));
      });

      testWidgets('should support keyboard navigation', 
          (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(
          createTestApp(
            child: Provider<UserHandler>.value(
              value: authMocks.userHandler,
              child: const SignInPage(),
            ),
          ),
        );

        // Assert - Check that form fields are focusable
        final emailField = tester.widget<TextField>(TestFinders.emailField);
        final passwordField = tester.widget<TextField>(TestFinders.passwordField);
        
        expect(emailField.focusNode, isNotNull);
        expect(passwordField.focusNode, isNotNull);
      });
    });

    group('Edge Cases', () {
      testWidgets('should handle network errors gracefully', 
          (WidgetTester tester) async {
        // Arrange
        when(() => authMocks.userHandler.signInWithEmailAndPassword(
          any(), any(),
        )).thenThrow(Exception('Network error'));

        await tester.pumpWidget(
          createTestApp(
            child: Provider<UserHandler>.value(
              value: authMocks.userHandler,
              child: const SignInPage(),
            ),
          ),
        );

        // Act
        await TestInteractions.performSignIn(tester);

        // Assert
        TestAssertions.expectErrorMessage('Network error');
      });

      testWidgets('should handle rapid form submissions', 
          (WidgetTester tester) async {
        // Arrange
        int signInCallCount = 0;
        when(() => authMocks.userHandler.signInWithEmailAndPassword(
          any(), any(),
        )).thenAnswer((_) async {
          signInCallCount++;
          await Future.delayed(const Duration(milliseconds: 100));
          return true;
        });

        await tester.pumpWidget(
          createTestApp(
            child: Provider<UserHandler>.value(
              value: authMocks.userHandler,
              child: const SignInPage(),
            ),
          ),
        );

        await TestInteractions.enterText(
          tester, 
          TestFinders.emailField, 
          AuthTestData.validEmail,
        );
        await TestInteractions.enterText(
          tester, 
          TestFinders.passwordField, 
          AuthTestData.validPassword,
        );

        // Act - Rapid submissions
        await TestInteractions.tap(tester, TestFinders.signInButton);
        await TestInteractions.tap(tester, TestFinders.signInButton);
        await TestInteractions.tap(tester, TestFinders.signInButton);
        await tester.pumpAndSettle();

        // Assert - Should only call once due to loading state
        expect(signInCallCount, equals(1));
      });
    });
  });
}
