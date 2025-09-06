// Centralized Mock Definitions
//
// This file contains all mock classes used throughout the test suite.
// Centralizing mocks ensures consistency and reduces duplication.
//
// Testing Framework: mocktail
// Standards: Follow TESTING-STANDARDS.md guidelines

import 'package:flutter/material.dart';
import 'package:mocktail/mocktail.dart';

// Firebase & Authentication
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_sign_in/google_sign_in.dart';

// App-specific imports
import 'package:cannasoltech_automation/handlers/user_handler.dart';
import 'package:cannasoltech_automation/providers/system_data_provider.dart';
import 'package:cannasoltech_automation/providers/display_data_provider.dart';
import 'package:cannasoltech_automation/providers/transform_provider.dart';
import 'package:cannasoltech_automation/api/firebase_api.dart';

// =============================================================================
// Firebase & Authentication Mocks
// =============================================================================

/// Mock Firebase Auth instance
class MockFirebaseAuth extends Mock implements FirebaseAuth {}

/// Mock Firebase App instance
class MockFirebaseApp extends Mock implements FirebaseApp {}

/// Mock Firebase Database instance
class MockFirebaseDatabase extends Mock implements FirebaseDatabase {}

/// Mock Firebase Storage instance
class MockFirebaseStorage extends Mock implements FirebaseStorage {}

/// Mock Firebase Messaging instance
class MockFirebaseMessaging extends Mock implements FirebaseMessaging {}

/// Mock User instance
class MockUser extends Mock implements User {}

/// Mock UserCredential instance
class MockUserCredential extends Mock implements UserCredential {}

/// Mock Google Sign-In instance
class MockGoogleSignIn extends Mock implements GoogleSignIn {}

/// Mock Google Sign-In Account
class MockGoogleSignInAccount extends Mock implements GoogleSignInAccount {}

/// Mock Google Sign-In Authentication
class MockGoogleSignInAuthentication extends Mock
    implements GoogleSignInAuthentication {}

// =============================================================================
// Fake Classes for Complex Types
// =============================================================================

/// Fake AuthCredential for fallback values
class FakeAuthCredential extends Fake implements AuthCredential {}

/// Fake DatabaseReference for fallback values
class FakeDatabaseReference extends Fake implements DatabaseReference {}

/// Fake Reference for Firebase Storage
class FakeReference extends Fake implements Reference {}

// =============================================================================
// App-Specific Mocks
// =============================================================================

/// Mock UserHandler
class MockUserHandler extends Mock implements UserHandler {}

/// Mock SystemDataModel provider
class MockSystemDataModel extends Mock implements SystemDataModel {}

/// Mock DisplayDataModel provider
class MockDisplayDataModel extends Mock implements DisplayDataModel {}

/// Mock TransformModel provider
class MockTransformModel extends Mock implements TransformModel {}

/// Mock SystemIdx
class MockSystemIdx extends Mock implements SystemIdx {}

/// Mock FirebaseApi
class MockFirebaseApi extends Mock implements FirebaseApi {}

// =============================================================================
// HTTP & Network Mocks
// =============================================================================

/// Mock HTTP Client for network requests (using http package)
class MockHttpClient extends Mock {}

// =============================================================================
// Platform-Specific Mocks
// =============================================================================

/// Mock for platform-specific functionality
class MockPlatform extends Mock {}

// =============================================================================
// Flutter Framework Mocks
// =============================================================================

/// Mock BuildContext for widget testing
class MockBuildContext extends Mock implements BuildContext {}

/// Mock MediaQueryData for screen size testing
class MockMediaQueryData extends Mock implements MediaQueryData {}

/// Mock NavigatorState for navigation testing
class MockNavigatorState extends Mock implements NavigatorState {
  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return super.toString();
  }
}

/// Mock ScaffoldMessengerState for snackbar testing
class MockScaffoldMessengerState extends Mock
    implements ScaffoldMessengerState {
  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return super.toString();
  }
}

// =============================================================================
// Mock Registration Helper
// =============================================================================

/// Registers all required fallback values for Mocktail
///
/// Call this in your test's setUpAll() method:
/// ```dart
/// void main() {
///   setUpAll(() {
///     registerMockFallbacks();
///   });
/// }
/// ```
void registerMockFallbacks() {
  // Register fallback values for complex types
  registerFallbackValue(FakeAuthCredential());
  registerFallbackValue(FakeDatabaseReference());
  registerFallbackValue(FakeReference());

  // Register common primitive fallbacks
  registerFallbackValue('');
  registerFallbackValue(0);
  registerFallbackValue(false);
  registerFallbackValue(<String>[]);
  registerFallbackValue(<String, dynamic>{});
}

// =============================================================================
// Mock Factory Methods
// =============================================================================

/// Creates a configured MockFirebaseAuth with common stubs
MockFirebaseAuth createMockFirebaseAuth({
  User? currentUser,
  bool signInSuccess = true,
}) {
  final mock = MockFirebaseAuth();

  when(() => mock.currentUser).thenReturn(currentUser);

  if (signInSuccess) {
    when(() => mock.signInWithEmailAndPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
        )).thenAnswer((_) async => MockUserCredential());

    when(() => mock.signInWithCredential(any()))
        .thenAnswer((_) async => MockUserCredential());
  } else {
    when(() => mock.signInWithEmailAndPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
        )).thenThrow(FirebaseAuthException(code: 'user-not-found'));
  }

  return mock;
}

/// Creates a configured MockGoogleSignIn
MockGoogleSignIn createMockGoogleSignIn({
  bool signInSuccess = true,
  GoogleSignInAccount? account,
}) {
  final mock = MockGoogleSignIn();

  if (signInSuccess && account != null) {
    when(() => mock.signIn()).thenAnswer((_) async => account);
  } else if (!signInSuccess) {
    when(() => mock.signIn()).thenThrow(Exception('Google Sign-In failed'));
  } else {
    when(() => mock.signIn()).thenAnswer((_) async => null);
  }

  return mock;
}

/// Creates a configured MockUserHandler
MockUserHandler createMockUserHandler({
  bool initialized = false,
  String? fcmToken,
}) {
  final mock = MockUserHandler();

  when(() => mock.initialized).thenReturn(initialized);
  when(() => mock.initialize()).thenAnswer((_) async {});

  if (fcmToken != null) {
    when(() => mock.setFCMToken(fcmToken)).thenReturn(null);
  }

  return mock;
}

// =============================================================================
// Test Data Helpers
// =============================================================================

/// Creates mock Google Sign-In authentication data
MockGoogleSignInAuthentication createMockGoogleAuth({
  String accessToken = 'mock_google_access_token',
  String idToken = 'mock_google_id_token',
}) {
  final mock = MockGoogleSignInAuthentication();
  when(() => mock.accessToken).thenReturn(accessToken);
  when(() => mock.idToken).thenReturn(idToken);
  return mock;
}

/// Creates mock Google Sign-In account
MockGoogleSignInAccount createMockGoogleAccount({
  String email = 'test@example.com',
  String displayName = 'Test User',
}) {
  final mock = MockGoogleSignInAccount();
  final mockAuth = createMockGoogleAuth();

  when(() => mock.email).thenReturn(email);
  when(() => mock.displayName).thenReturn(displayName);
  when(() => mock.authentication).thenAnswer((_) async => mockAuth);

  return mock;
}
