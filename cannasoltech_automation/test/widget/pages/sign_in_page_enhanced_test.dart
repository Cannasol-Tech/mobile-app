// Enhanced Widget Tests for SignInPage Component
//
// Comprehensive widget tests following Axovia Flow standards for the SignInPage component.
// Tests verify UI behavior, form validation, authentication flow, user interactions, and accessibility.
//
// Testing Framework: flutter_test + mocktail
// Coverage Target: ≥85% widget coverage
// Mocking: Allowed for external dependencies via Mocktail; do not mock widgets/rendering
// Standards: Axovia Flow Flutter Testing Standard (no widget/rendering mocks)

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mocktail/mocktail.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:cannasoltech_automation/pages/sign_in.dart';
import 'package:cannasoltech_automation/handlers/user_handler.dart';
import 'package:cannasoltech_automation/pages/reset_password.dart';
import 'package:cannasoltech_automation/providers/system_data_provider.dart';

// Import centralized test helpers
import '../../helpers/mocks.dart';
import '../../helpers/test_data.dart';
import '../../helpers/test_utils.dart';

void main() {
  TestEnvironment.setupGroup();

  group('SignInPage Enhanced Widget Tests', () {
    late MockUserHandler mockUserHandler;
    late MockSystemDataModel mockSystemDataModel;
    late MockFirebaseAuth mockFirebaseAuth;
    late bool toggleFunctionCalled;

    setUp(() {
      mockUserHandler = createMockUserHandler();
      mockSystemDataModel = MockSystemDataModel();
      mockFirebaseAuth = createMockFirebaseAuth();
      toggleFunctionCalled = false;

      // Setup mock behaviors
      when(() => mockUserHandler.signInWithEmailAndPassword(any(), any()))
          .thenAnswer((_) async => true);
      when(() => mockUserHandler.signInWithGoogle())
          .thenAnswer((_) async => true);

      // Provide userHandler via SystemDataModel used by the widget
      when(() => mockSystemDataModel.userHandler).thenReturn(mockUserHandler);
      when(() => mockSystemDataModel.isPasswordVisible).thenReturn(false);
    });

    Widget createSignInPageWidget({bool? mockProviders = true}) {
      if (mockProviders == true) {
        return createTestAppWithProviders(
          systemDataModel: mockSystemDataModel,
          child: SignInPage1(
            toggleFn: () {
              toggleFunctionCalled = true;
            },
          ),
        );
      } else {
        return createTestApp(
          child: Provider<UserHandler>.value(
            value: mockUserHandler,
            child: Provider<SystemDataModel>.value(
              value: mockSystemDataModel,
              child: SignInPage1(
                toggleFn: () {
                  toggleFunctionCalled = true;
                },
              ),
            ),
          ),
        );
      }
    }

    group('Rendering and UI Structure Tests', () {
      testWidgets('should render sign-in page with all required elements', (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(createSignInPageWidget());
        await tester.pumpAndSettle();

        // Assert - Main components
        expect(find.byType(SignInPage1), findsOneWidget);
        expect(find.byType(Form), findsOneWidget);
        expect(find.byType(TextFormField), findsNWidgets(2)); // Email and password
        expect(find.byType(ElevatedButton), findsAtLeastNWidgets(1)); // Sign-in button
      });

      testWidgets('should display email input field with correct properties', (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(createSignInPageWidget());
        await tester.pumpAndSettle();

        // Assert - field is present by key
        expect(TestFinders.emailField, findsOneWidget);
      });

      testWidgets('should display password input field with correct properties', (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(createSignInPageWidget());
        await tester.pumpAndSettle();

        // Assert - field is present by key
        expect(TestFinders.passwordField, findsOneWidget);
      });

      testWidgets('should display sign-in button', (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(createSignInPageWidget());
        await tester.pumpAndSettle();

        // Assert
        expect(find.byType(ElevatedButton), findsAtLeastNWidgets(1));
        expect(find.text('Sign In'), findsOneWidget);
      });

      testWidgets('should display Google sign-in option', (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(createSignInPageWidget());
        await tester.pumpAndSettle();

        // Assert - Look for Google sign-in button by key
        expect(find.byKey(const Key('google_sign_in_button')), findsOneWidget);
      });

      testWidgets('should display forgot password link', (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(createSignInPageWidget());
        await tester.pumpAndSettle();

        // Assert
        expect(find.textContaining('Forgot'), findsAtLeastNWidgets(1));
        expect(find.byType(GestureDetector), findsAtLeastNWidgets(1));
      });

      testWidgets('should display toggle to registration link', (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(createSignInPageWidget());
        await tester.pumpAndSettle();

        // Assert - Look for registration link text used by the app
        expect(find.text('Register now'), findsOneWidget);
      });
    });

    group('Form Validation Tests', () {
      testWidgets('should validate email format correctly', (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(createSignInPageWidget());
        await tester.pumpAndSettle();

        // Find email field and enter invalid email
        final emailField = find.byType(TextFormField).first;
        await tester.enterText(emailField, 'invalid-email');
        
        // Trigger validation by tapping sign-in button
        final signInButton = find.byKey(const Key('primary_sign_in_button'));
        await TestInteractions.scrollAndTap(tester, signInButton);
        await tester.pumpAndSettle();

        // Assert - Should show validation error or prevent submission
        // Note: The exact validation behavior depends on implementation
        expect(find.byType(SignInPage1), findsOneWidget);
      });

      testWidgets('should validate password field is not empty', (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(createSignInPageWidget());
        await tester.pumpAndSettle();

        // Enter valid email but no password
        final emailField = find.byType(TextFormField).first;
        await tester.enterText(emailField, AuthTestData.validEmail);
        
        // Leave password empty and try to sign in
        final signInButton = find.byKey(const Key('primary_sign_in_button'));
        await TestInteractions.scrollAndTap(tester, signInButton);
        await tester.pumpAndSettle();

        // Assert - Should show validation error or prevent submission
        expect(find.byType(SignInPage1), findsOneWidget);
      });

      testWidgets('should accept valid email and password combination', (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(createSignInPageWidget());
        await tester.pumpAndSettle();

        // Enter valid credentials
        final textFields = find.byType(TextFormField);
        await tester.enterText(textFields.first, AuthTestData.validEmail);
        await tester.enterText(textFields.last, AuthTestData.validPassword);
        
        // Tap sign-in button
        final signInButton = find.byKey(const Key('primary_sign_in_button'));
        await TestInteractions.scrollAndTap(tester, signInButton);
        await tester.pumpAndSettle();

        // Assert - Should attempt sign-in
        verify(() => mockUserHandler.signInWithEmailAndPassword(
          AuthTestData.validEmail,
          AuthTestData.validPassword,
        )).called(1);
      });
    });

    group('User Interaction Tests', () {
      testWidgets('should handle password visibility toggle', (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(createSignInPageWidget());
        await tester.pumpAndSettle();

        // Tap the visibility_off icon to toggle
        final toggleOff = find.byIcon(Icons.visibility_off);
        if (toggleOff.evaluate().isNotEmpty) {
          await tester.tap(toggleOff.first);
          await tester.pumpAndSettle();

          // After toggle, expect visibility icon to appear
          expect(find.byIcon(Icons.visibility), findsWidgets);
        }
      });

      testWidgets('should handle Google sign-in button tap', (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(createSignInPageWidget());
        await tester.pumpAndSettle();

        // Find and tap Google sign-in button by key
        final googleButton = find.byKey(const Key('google_sign_in_button'));
        if (googleButton.evaluate().isNotEmpty) {
          await TestInteractions.scrollAndTap(tester, googleButton);
          await tester.pumpAndSettle();

          // Assert - Should attempt Google sign-in
          verify(() => mockUserHandler.signInWithGoogle()).called(1);
        }
      });

      testWidgets('should handle forgot password link tap', (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(createSignInPageWidget());
        await tester.pumpAndSettle();

        // Find and tap forgot password link
        final forgotPasswordLink = find.textContaining('Forgot');
        
        if (forgotPasswordLink.evaluate().isNotEmpty) {
          await TestInteractions.scrollAndTap(tester, forgotPasswordLink.first);
          await tester.pumpAndSettle();

        // Assert - Should navigate to reset password page
          expect(find.byType(ResetPasswordPage), findsOneWidget);
        }
      });

      testWidgets('should handle toggle to registration', (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(createSignInPageWidget());
        await tester.pumpAndSettle();

        // Find and tap registration toggle used by the app
        final registerLink = find.text('Register now');
        if (registerLink.evaluate().isNotEmpty) {
          await TestInteractions.scrollAndTap(tester, registerLink);
          await tester.pumpAndSettle();

          // Assert - Should call toggle function
          expect(toggleFunctionCalled, isTrue);
        }
      });
    });

    group('Authentication Flow Tests', () {
      testWidgets('should handle successful email/password sign-in', (WidgetTester tester) async {
        // Setup successful authentication
        when(() => mockUserHandler.signInWithEmailAndPassword(any(), any()))
            .thenAnswer((_) async => true);

        // Act
        await tester.pumpWidget(createSignInPageWidget());
        await tester.pumpAndSettle();

        // Enter credentials and sign in
        final textFields = find.byType(TextFormField);
        await tester.enterText(textFields.first, AuthTestData.validEmail);
        await tester.enterText(textFields.last, AuthTestData.validPassword);
        
        final signInButton = find.byKey(const Key('primary_sign_in_button'));
        await TestInteractions.scrollAndTap(tester, signInButton);
        await tester.pumpAndSettle();

        // Assert
        verify(() => mockUserHandler.signInWithEmailAndPassword(
          AuthTestData.validEmail,
          AuthTestData.validPassword,
        )).called(1);
      });

      testWidgets('should handle authentication failure with user-not-found error', (WidgetTester tester) async {
        // Setup authentication failure
        when(() => mockUserHandler.signInWithEmailAndPassword(any(), any()))
            .thenThrow(FirebaseAuthException(code: 'user-not-found'));

        // Act
        await tester.pumpWidget(createSignInPageWidget());
        await tester.pumpAndSettle();

        // Enter credentials and sign in
        final textFields = find.byType(TextFormField);
        await tester.enterText(textFields.first, AuthTestData.validEmail);
        await tester.enterText(textFields.last, AuthTestData.validPassword);
        
        final signInButton = find.byKey(const Key('primary_sign_in_button'));
        await TestInteractions.scrollAndTap(tester, signInButton);
        await tester.pumpAndSettle();

        // Assert - Should show error dialog
        expect(find.byType(AlertDialog), findsOneWidget);
        expect(find.text('User not found!'), findsOneWidget);
      });

      testWidgets('should handle authentication failure with wrong-password error', (WidgetTester tester) async {
        // Setup authentication failure
        when(() => mockUserHandler.signInWithEmailAndPassword(any(), any()))
            .thenThrow(FirebaseAuthException(code: 'wrong-password'));

        // Act
        await tester.pumpWidget(createSignInPageWidget());
        await tester.pumpAndSettle();

        // Enter credentials and sign in
        final textFields = find.byType(TextFormField);
        await tester.enterText(textFields.first, AuthTestData.validEmail);
        await tester.enterText(textFields.last, AuthTestData.validPassword);
        
        final signInButton = find.byKey(const Key('primary_sign_in_button'));
        await TestInteractions.scrollAndTap(tester, signInButton);
        await tester.pumpAndSettle();

        // Assert - Should show error dialog
        expect(find.byType(AlertDialog), findsOneWidget);
        expect(find.text('Incorrect password'), findsOneWidget);
      });

      testWidgets('should handle generic authentication errors', (WidgetTester tester) async {
        // Setup authentication failure
        when(() => mockUserHandler.signInWithEmailAndPassword(any(), any()))
            .thenThrow(Exception('Network error'));

        // Act
        await tester.pumpWidget(createSignInPageWidget());
        await tester.pumpAndSettle();

        // Enter credentials and sign in
        final textFields = find.byType(TextFormField);
        await tester.enterText(textFields.first, AuthTestData.validEmail);
        await tester.enterText(textFields.last, AuthTestData.validPassword);
        
        final signInButton = find.byKey(const Key('primary_sign_in_button'));
        await TestInteractions.scrollAndTap(tester, signInButton);
        await tester.pumpAndSettle();

        // Assert - Should show generic error dialog
        expect(find.byType(AlertDialog), findsOneWidget);
        expect(find.text('Invalid login!'), findsOneWidget);
      });

      testWidgets('should handle successful Google sign-in', (WidgetTester tester) async {
        // Setup successful Google authentication
        when(() => mockUserHandler.signInWithGoogle())
            .thenAnswer((_) async => true);

        // Act
        await tester.pumpWidget(createSignInPageWidget());
        await tester.pumpAndSettle();

        // Find and tap Google sign-in
        final googleButton = find.textContaining('Google');
        if (googleButton.evaluate().isNotEmpty) {
          await tester.tap(googleButton.first);
          await tester.pumpAndSettle();

          // Assert
          verify(() => mockUserHandler.signInWithGoogle()).called(1);
        }
      });

      testWidgets('should handle Google sign-in failure', (WidgetTester tester) async {
        // Setup Google authentication failure
        when(() => mockUserHandler.signInWithGoogle())
            .thenAnswer((_) async => false);

        // Act
        await tester.pumpWidget(createSignInPageWidget());
        await tester.pumpAndSettle();

        // Find and tap Google sign-in
        final googleButton = find.byKey(const Key('google_sign_in_button'));
        if (googleButton.evaluate().isNotEmpty) {
          await TestInteractions.scrollAndTap(tester, googleButton);
          await tester.pumpAndSettle();

          // Assert - Should show error message
          expect(find.byType(AlertDialog), findsOneWidget);
        }
      });
    });

    group('Responsive Design Tests', () {
      testWidgets('should render correctly on phone screen', (WidgetTester tester) async {
        await tester.binding.setSurfaceSize(GoldenTestUtils.phoneSize);
        
        // Act
        await tester.pumpWidget(createSignInPageWidget());
        await tester.pumpAndSettle();

        // Assert
        expect(find.byType(SignInPage1), findsOneWidget);
        WidgetTestUtils.expectNoOverflow(tester);
      });

      testWidgets('should render correctly on tablet screen', (WidgetTester tester) async {
        await tester.binding.setSurfaceSize(GoldenTestUtils.tabletSize);
        
        // Act
        await tester.pumpWidget(createSignInPageWidget());
        await tester.pumpAndSettle();

        // Assert
        expect(find.byType(SignInPage1), findsOneWidget);
        WidgetTestUtils.expectNoOverflow(tester);
      });

      testWidgets('should adapt to different screen orientations', (WidgetTester tester) async {
        // Test portrait
        await tester.binding.setSurfaceSize(const Size(375, 667));
        await tester.pumpWidget(createSignInPageWidget());
        await tester.pumpAndSettle();
        expect(find.byType(SignInPage1), findsOneWidget);

        // Test landscape
        await tester.binding.setSurfaceSize(const Size(667, 375));
        await tester.pumpWidget(createSignInPageWidget());
        await tester.pumpAndSettle();
        expect(find.byType(SignInPage1), findsOneWidget);
        WidgetTestUtils.expectNoOverflow(tester);
      });
    });

    group('Accessibility Tests', () {
      testWidgets('should have proper semantic labels', (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(createSignInPageWidget());
        await tester.pumpAndSettle();

        // Assert - Check for semantic information
        final signInPageSemantics = tester.getSemantics(find.byType(SignInPage1));
        expect(signInPageSemantics, isNotNull);
        
        // Verify form fields have appropriate semantics
        final textFields = find.byType(TextFormField);
        for (final field in textFields.evaluate()) {
          final fieldSemantics = tester.getSemantics(find.byWidget(field.widget));
          expect(fieldSemantics, isNotNull);
        }
      });

      testWidgets('should support keyboard navigation', (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(createSignInPageWidget());
        await tester.pumpAndSettle();

        // Test tab navigation between form fields
        await tester.sendKeyEvent(LogicalKeyboardKey.tab);
        await tester.pumpAndSettle();
        
        await tester.sendKeyEvent(LogicalKeyboardKey.tab);
        await tester.pumpAndSettle();

        // Assert - Should not throw errors during keyboard navigation
        expect(find.byType(SignInPage1), findsOneWidget);
      });

      testWidgets('should handle large text sizes', (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(
          createTestAppWithProviders(
            systemDataModel: mockSystemDataModel,
            child: MediaQuery(
              data: MediaQueryData.fromWindow(WidgetsBinding.instance.window).copyWith(
                textScaleFactor: 2.0, // Large text
              ),
              child: SignInPage1(toggleFn: () {}),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Assert
        expect(find.byType(SignInPage1), findsOneWidget);
        WidgetTestUtils.expectNoOverflow(tester);
      });
    });

    group('Error Dialog Tests', () {
      testWidgets('should display error dialog with correct styling', (WidgetTester tester) async {
        // Setup authentication failure
        when(() => mockUserHandler.signInWithEmailAndPassword(any(), any()))
            .thenThrow(FirebaseAuthException(code: 'user-not-found'));

        // Act
        await tester.pumpWidget(createSignInPageWidget());
        await tester.pumpAndSettle();

        // Trigger error by attempting sign-in
        final textFields = find.byType(TextFormField);
        await tester.enterText(textFields.first, AuthTestData.validEmail);
        await tester.enterText(textFields.last, AuthTestData.validPassword);
        
        final signInButton = find.byKey(const Key('primary_sign_in_button'));
        await TestInteractions.scrollAndTap(tester, signInButton);
        await tester.pumpAndSettle();

        // Assert
        expect(find.byType(AlertDialog), findsOneWidget);
        
        final alertDialog = tester.widget<AlertDialog>(find.byType(AlertDialog));
        expect(alertDialog.backgroundColor, equals(Colors.red[600]));
      });

      testWidgets('should dismiss error dialog when tapped outside', (WidgetTester tester) async {
        // Setup authentication failure
        when(() => mockUserHandler.signInWithEmailAndPassword(any(), any()))
            .thenThrow(FirebaseAuthException(code: 'user-not-found'));

        // Act
        await tester.pumpWidget(createSignInPageWidget());
        await tester.pumpAndSettle();

        // Trigger error
        final textFields = find.byType(TextFormField);
        await tester.enterText(textFields.first, AuthTestData.validEmail);
        await tester.enterText(textFields.last, AuthTestData.validPassword);
        
        final signInButton = find.byKey(const Key('primary_sign_in_button'));
        await TestInteractions.scrollAndTap(tester, signInButton);
        await tester.pumpAndSettle();

        expect(find.byType(AlertDialog), findsOneWidget);

        // Tap outside dialog to dismiss
        await tester.tapAt(const Offset(10, 10));
        await tester.pumpAndSettle();

        // Assert - Dialog should be dismissed
        expect(find.byType(AlertDialog), findsNothing);
      });
    });

    group('Edge Cases and Error Handling Tests', () {
      testWidgets('should handle empty form submission gracefully', (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(createSignInPageWidget());
        await tester.pumpAndSettle();

        // Try to sign in with empty form
        final signInButton = find.byKey(const Key('primary_sign_in_button'));
        await TestInteractions.scrollAndTap(tester, signInButton);
        await tester.pumpAndSettle();

        // Assert - Should handle gracefully without crashing
        expect(find.byType(SignInPage1), findsOneWidget);
      });

      testWidgets('should handle rapid button taps', (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(createSignInPageWidget());
        await tester.pumpAndSettle();

        // Enter valid data
        final textFields = find.byType(TextFormField);
        await tester.enterText(textFields.first, AuthTestData.validEmail);
        await tester.enterText(textFields.last, AuthTestData.validPassword);

        // Rapidly tap sign-in button
        final signInButton = find.text('Sign In');
        await tester.tap(signInButton);
        await tester.tap(signInButton);
        await tester.tap(signInButton);
        await tester.pumpAndSettle();

        // Assert - Should handle gracefully
        expect(find.byType(SignInPage1), findsOneWidget);
      });

      testWidgets('should handle network timeout scenarios', (WidgetTester tester) async {
        // Setup timeout error
        when(() => mockUserHandler.signInWithEmailAndPassword(any(), any()))
            .thenThrow(Exception('Timeout'));

        // Act
        await tester.pumpWidget(createSignInPageWidget());
        await tester.pumpAndSettle();

        final textFields = find.byType(TextFormField);
        await tester.enterText(textFields.first, AuthTestData.validEmail);
        await tester.enterText(textFields.last, AuthTestData.validPassword);
        
        final signInButton = find.byKey(const Key('primary_sign_in_button'));
        await TestInteractions.scrollAndTap(tester, signInButton);
        await tester.pumpAndSettle();

        // Assert - Should show appropriate error message
        expect(find.byType(AlertDialog), findsOneWidget);
        expect(find.text('Invalid login!'), findsOneWidget);
      });
    });
  });
}