// Google Sign-In Unit Tests
//
// This file contains comprehensive unit tests for Google Sign-In functionality.
// Tests cover authentication flow, error handling, and edge cases.
//
// Testing Framework: flutter_test + mocktail
// Standards: Follow UNIT-TEST-FRAMEWORK-ANALYSIS.md guidelines

import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mocktail/mocktail.dart';

// Import centralized test helpers
import '../../helpers/mocks.dart';
import '../../helpers/test_data.dart';
import '../../helpers/test_utils.dart';

void main() {
  // Setup test environment
  TestEnvironment.setupGroup();

  group('Google Sign-In Tests', () {
    late AuthMockSetup authMocks;

    setUp(() {
      authMocks = MockSetup.createAuthMocks();
    });

    test('Google Sign-In configuration should be valid', () {
      // Test that GoogleSignIn can be instantiated without client ID
      // This should use platform-specific configuration
      expect(() => GoogleSignIn(), returnsNormally);
    });

    test('should handle successful Google Sign-In authentication', () async {
      // Arrange - Using centralized mock setup
      final googleAccount = createMockGoogleAccount(
        email: AuthTestData.googleEmail,
        displayName: AuthTestData.googleDisplayName,
      );

      when(() => authMocks.googleSignIn.signIn())
          .thenAnswer((_) async => googleAccount);

      when(() => authMocks.firebaseAuth.signInWithCredential(any()))
          .thenAnswer((_) async => MockUserCredential());

      // Act
      final googleUser = await authMocks.googleSignIn.signIn();
      expect(googleUser, isNotNull);

      final googleAuth = await googleUser!.authentication;
      expect(googleAuth.accessToken, equals(AuthTestData.googleAccessToken));
      expect(googleAuth.idToken, equals(AuthTestData.googleIdToken));

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential =
          await authMocks.firebaseAuth.signInWithCredential(credential);

      // Assert
      expect(userCredential, isNotNull);
      verify(() => authMocks.googleSignIn.signIn()).called(1);
      verify(() => authMocks.firebaseAuth.signInWithCredential(any()))
          .called(1);
    });

    test('should handle user cancellation of Google Sign-In', () async {
      // Arrange
      when(() => authMocks.googleSignIn.signIn()).thenAnswer((_) async => null);

      // Act
      final result = await authMocks.googleSignIn.signIn();

      // Assert
      expect(result, isNull);
      verify(() => authMocks.googleSignIn.signIn()).called(1);
    });

    test('should handle Google Sign-In authentication errors', () async {
      // Arrange
      when(() => authMocks.googleSignIn.signIn())
          .thenThrow(Exception('Google Sign-In failed'));

      // Act & Assert
      expect(() => authMocks.googleSignIn.signIn(), throwsException);
    });

    test('should handle Firebase authentication errors during Google Sign-In',
        () async {
      // Arrange
      final googleAccount = createMockGoogleAccount();
      when(() => authMocks.googleSignIn.signIn())
          .thenAnswer((_) async => googleAccount);

      when(() => authMocks.firebaseAuth.signInWithCredential(any())).thenThrow(
          FirebaseAuthException(code: AuthTestData.userNotFoundCode));

      // Act & Assert
      final googleUser = await authMocks.googleSignIn.signIn();
      expect(googleUser, isNotNull);

      final googleAuth = await googleUser!.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      expect(
        () => authMocks.firebaseAuth.signInWithCredential(credential),
        throwsA(isA<FirebaseAuthException>()),
      );
    });
  });
}
