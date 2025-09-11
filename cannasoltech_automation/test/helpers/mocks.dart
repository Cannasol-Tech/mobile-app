// Centralized Mock Definitions
//
// This file contains all mock classes used throughout the test suite.
// Centralizing mocks ensures consistency and reduces duplication.
//
// Testing Framework: mocktail
// Standards: Follow TESTING-STANDARDS.md guidelines

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
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
import 'package:cannasoltech_automation/data_models/device.dart';
import 'package:cannasoltech_automation/handlers/config_handler.dart';
import 'package:cannasoltech_automation/handlers/state_handler.dart';
import 'package:cannasoltech_automation/handlers/alarm_handler.dart';
import 'package:cannasoltech_automation/data_models/property.dart';
import 'package:cannasoltech_automation/data_classes/status_message.dart';

// =============================================================================
// Firebase & Authentication Mocks
// =============================================================================

/// Mock Firebase Auth instance
class MockFirebaseAuth extends Mock implements FirebaseAuth {}

/// Mock Firebase App instance
class MockFirebaseApp extends Mock implements FirebaseApp {}

/// Mock Firebase Database instance
class MockFirebaseDatabase extends Mock implements FirebaseDatabase {}

/// Mock DatabaseReference for Firebase Realtime Database
class MockDatabaseReference extends Mock implements DatabaseReference {}

/// Mock DataSnapshot for Firebase Realtime Database
class MockDataSnapshot extends Mock implements DataSnapshot {}

/// Mock DatabaseEvent for Firebase Realtime Database
class MockDatabaseEvent extends Mock implements DatabaseEvent {}

/// Mock User for Firebase Auth
class MockUser extends Mock implements User {}

/// Mock UserCredential for Firebase Auth
class MockUserCredential extends Mock implements UserCredential {}

/// Mock Firebase Storage instance
class MockFirebaseStorage extends Mock implements FirebaseStorage {}

/// Mock Reference for Firebase Storage
class MockReference extends Mock implements Reference {}

/// Mock FirebaseMessaging for push notifications
class MockFirebaseMessaging extends Mock implements FirebaseMessaging {}

/// Mock GoogleSignIn for Google authentication
class MockGoogleSignIn extends Mock implements GoogleSignIn {}

/// Mock GoogleSignInAccount
class MockGoogleSignInAccount extends Mock implements GoogleSignInAccount {}

/// Mock GoogleSignInAuthentication
class MockGoogleSignInAuthentication extends Mock implements GoogleSignInAuthentication {}

// =============================================================================
// App-Specific Handler Mocks
// =============================================================================

/// Mock UserHandler for testing user management
class MockUserHandler extends Mock implements UserHandler {}

/// Mock SystemDataModel for testing system state
class MockSystemDataModel extends Mock implements SystemDataModel {}

/// Mock DisplayDataModel for testing display data
class MockDisplayDataModel extends Mock implements DisplayDataModel {}

/// Mock TransformModel for testing data transformation
class MockTransformModel extends Mock implements TransformModel {}

/// Mock SystemIdx for testing system indexing
class MockSystemIdx extends Mock implements SystemIdx {}

/// Mock ConfigHandler for testing configuration management
class MockConfigHandler extends Mock implements ConfigHandler {}

/// Mock StateHandler for testing state management
class MockStateHandler extends Mock implements StateHandler {}

/// Mock AlarmHandler for testing alarm management
class MockAlarmHandler extends Mock implements AlarmHandler {}

/// Mock ActiveDeviceHandler for testing device management
class MockActiveDeviceHandler extends Mock implements ActiveDeviceHandler {}

/// Mock RegisteredDeviceHandler for testing device registration
class MockRegisteredDeviceHandler extends Mock implements RegisteredDeviceHandler {}

// =============================================================================
// Data Model Mocks
// =============================================================================

/// Mock Device for testing device data
class MockDevice extends Mock implements Device {}

/// Mock Property for testing device properties
class MockProperty extends Mock implements Property {}

/// Mock StatusMessage for testing status communications
class MockStatusMessage extends Mock implements StatusMessage {}

// =============================================================================
// Firebase API Mock
// =============================================================================

/// Mock FirebaseApi for testing Firebase integration
class MockFirebaseApi extends Mock implements FirebaseApi {}

// =============================================================================
// Flutter Framework Mocks
// =============================================================================

/// Mock BuildContext for widget testing
class MockBuildContext extends Mock implements BuildContext {}

/// Mock MediaQueryData for responsive design testing
class MockMediaQueryData extends Mock implements MediaQueryData {}

/// Mock NavigatorState for navigation testing
class MockNavigatorState extends Mock implements NavigatorState {}

/// Mock TextEditingController for form testing
class MockTextEditingController extends Mock implements TextEditingController {}

// =============================================================================
// Platform Channel Mocks
// =============================================================================

/// Mock MethodChannel for platform communication testing
class MockMethodChannel extends Mock implements MethodChannel {}

// =============================================================================
// HTTP and Network Mocks
// =============================================================================

/// Mock HTTP Client for network testing
class MockHttpClient extends Mock implements HttpClient {}

/// Mock HTTP Response for network testing
class MockHttpResponse extends Mock implements HttpClientResponse {}

// =============================================================================
// Fallback Value Registration
// =============================================================================

/// Registers all fallback values for Mocktail
void registerMockFallbacks() {
  // Firebase Auth fallbacks
  registerFallbackValue(MockUser());
  registerFallbackValue(MockUserCredential());
  registerFallbackValue(const AuthCredential(providerId: 'test', signInMethod: 'test'));
  
  // Firebase Database fallbacks
  registerFallbackValue(MockDataSnapshot());
  registerFallbackValue(MockDatabaseEvent());
  
  // Firebase Storage fallbacks
  registerFallbackValue(MockReference());
  
  // Google Sign-In fallbacks
  registerFallbackValue(MockGoogleSignInAccount());
  registerFallbackValue(MockGoogleSignInAuthentication());
  
  // Flutter framework fallbacks
  registerFallbackValue(MockBuildContext());
  registerFallbackValue(const Size(0, 0));
  registerFallbackValue(const Duration());
  
  // App-specific fallbacks
  registerFallbackValue(MockDevice());
  registerFallbackValue(MockProperty());
  registerFallbackValue(MockStatusMessage());
  
  // Platform fallbacks
  registerFallbackValue(LogicalKeyboardKey.space);
}

// =============================================================================
// Mock Factory Functions
// =============================================================================

/// Creates a mock FirebaseAuth with common setup
MockFirebaseAuth createMockFirebaseAuth({
  bool signInSuccess = true,
  User? user,
}) {
  final mock = MockFirebaseAuth();
  final mockUser = user ?? MockUser();
  
  when(() => mock.currentUser).thenReturn(signInSuccess ? mockUser : null);
  when(() => mock.authStateChanges()).thenAnswer(
    (_) => Stream.value(signInSuccess ? mockUser : null),
  );
  
  if (signInSuccess) {
    when(() => mock.signInWithEmailAndPassword(
      email: any(named: 'email'),
      password: any(named: 'password'),
    )).thenAnswer((_) async => MockUserCredential());
    
    when(() => mock.createUserWithEmailAndPassword(
      email: any(named: 'email'),
      password: any(named: 'password'),
    )).thenAnswer((_) async => MockUserCredential());
  } else {
    when(() => mock.signInWithEmailAndPassword(
      email: any(named: 'email'),
      password: any(named: 'password'),
    )).thenThrow(FirebaseAuthException(code: 'invalid-credentials'));
  }
  
  when(() => mock.signOut()).thenAnswer((_) async {});
  
  return mock;
}

/// Creates a mock GoogleSignIn with common setup
MockGoogleSignIn createMockGoogleSignIn({
  bool signInSuccess = true,
  GoogleSignInAccount? account,
}) {
  final mock = MockGoogleSignIn();
  
  if (signInSuccess && account != null) {
    when(() => mock.signIn()).thenAnswer((_) async => account);
  } else {
    when(() => mock.signIn()).thenAnswer((_) async => null);
  }
  
  when(() => mock.signOut()).thenAnswer((_) async => null);
  
  return mock;
}

/// Creates a mock GoogleSignInAccount with common setup
MockGoogleSignInAccount createMockGoogleAccount({
  String? email,
  String? displayName,
  String? id,
}) {
  final mock = MockGoogleSignInAccount();
  final mockAuth = MockGoogleSignInAuthentication();
  
  when(() => mock.email).thenReturn(email ?? AuthTestData.googleEmail);
  when(() => mock.displayName).thenReturn(displayName ?? AuthTestData.googleDisplayName);
  when(() => mock.id).thenReturn(id ?? 'mock_google_user_id');
  when(() => mock.authentication).thenAnswer((_) async => mockAuth);
  
  when(() => mockAuth.accessToken).thenReturn(AuthTestData.googleAccessToken);
  when(() => mockAuth.idToken).thenReturn(AuthTestData.googleIdToken);
  
  return mock;
}

/// Creates a mock User with common setup
MockUser createMockUser({
  String? uid,
  String? email,
  String? displayName,
  bool emailVerified = true,
}) {
  final mock = MockUser();
  
  when(() => mock.uid).thenReturn(uid ?? AuthTestData.validUserId);
  when(() => mock.email).thenReturn(email ?? AuthTestData.validEmail);
  when(() => mock.displayName).thenReturn(displayName ?? AuthTestData.validDisplayName);
  when(() => mock.emailVerified).thenReturn(emailVerified);
  when(() => mock.reload()).thenAnswer((_) async {});
  when(() => mock.sendEmailVerification()).thenAnswer((_) async {});
  when(() => mock.updateDisplayName(any())).thenAnswer((_) async {});
  when(() => mock.updateEmail(any())).thenAnswer((_) async {});
  
  return mock;
}

/// Creates a mock UserHandler with common setup
MockUserHandler createMockUserHandler({
  bool initialized = true,
  String? uid,
  String? email,
  String? name,
}) {
  final mock = MockUserHandler();
  
  when(() => mock.initialized).thenReturn(initialized);
  when(() => mock.uid).thenReturn(uid ?? AuthTestData.validUserId);
  when(() => mock.email).thenReturn(email ?? AuthTestData.validEmail);
  when(() => mock.name).thenReturn(name ?? AuthTestData.validDisplayName);
  when(() => mock.emailOnAlarm).thenReturn(true);
  when(() => mock.selectedDevice).thenReturn('test-device');
  when(() => mock.watchedDevices).thenReturn(['device1', 'device2']);
  when(() => mock.doesAcceptTaC).thenReturn(true);
  
  when(() => mock.initialize()).thenAnswer((_) async {});
  when(() => mock.signOut()).thenAnswer((_) async {});
  when(() => mock.updateName(any())).thenAnswer((_) async {});
  when(() => mock.updateEmail(any())).thenAnswer((_) async {});
  when(() => mock.acceptTaC()).thenAnswer((_) async {});
  when(() => mock.toggleEmailOnAlarm()).thenAnswer((_) async {});
  when(() => mock.addDevice(any())).thenAnswer((_) async {});
  when(() => mock.removeDevice(any())).thenAnswer((_) async {});
  
  return mock;
}
class MockDataSnapshot extends Mock implements DataSnapshot {}

/// Mock DatabaseEvent for Firebase Realtime Database
class MockDatabaseEvent extends Mock implements DatabaseEvent {}

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

/// Mock Device
class MockDevice extends Mock implements Device {
  @override
  late StateHandler state;
}

/// Mock AlarmsModel
class MockAlarmsModel extends Mock implements AlarmsModel {
  final Map<String, bool> _alarmStates = {};

  void setAlarmState(String key, bool value) {
    _alarmStates[key] = value;
  }

  @override
  bool operator [](String key) {
    return _alarmStates[key] ?? false;
  }
}

/// Mock ConfigHandler
class MockConfigHandler extends Mock implements ConfigHandler {}

/// Mock FireProperty
class MockFireProperty extends Mock implements FireProperty {
  dynamic _value;

  @override
  dynamic get value => _value;

  @override
  set value(dynamic val) => _value = val;

  void setMockValue(dynamic val) {
    _value = val;
  }

  @override
  void setValue(dynamic value) {
    _value = value;
  }
}

/// Mock StateHandler
class MockStateHandler extends Mock implements StateHandler {}

/// Mock StatusMessage
class MockStatusMessage extends Mock implements StatusMessage {}

/// Mock ActiveDeviceHandler
class MockActiveDeviceHandler extends Mock {}

/// Mock RegisteredDeviceHandler
class MockRegisteredDeviceHandler extends Mock {}

/// Mock Devices
class MockDevices extends Mock {}

/// Mock TextControllers
class MockTextControllers extends Mock {}

/// Mock ToggleControllers
class MockToggleControllers extends Mock {}

/// Mock AlarmLogsModel
class MockAlarmLogsModel extends Mock {}

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
class MockBuildContext extends Mock implements BuildContext {
  @override
  Widget get widget => Container(); // Return a simple widget
}

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

/// Mock GlobalKey for testing navigator and other keys
class MockGlobalKey<T extends State<StatefulWidget>> extends Mock
    implements GlobalKey<T> {}

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

// =============================================================================
// Firebase Test Setup Helpers
// =============================================================================

/// Creates a fully configured Firebase test environment with mocks
///
/// This helper sets up all necessary Firebase mocks for testing.
/// Use this when you need a complete Firebase test setup with properly
/// configured mocks that don't require actual Firebase initialization.
///
/// Returns a map containing all configured mocks for easy access in tests.
Map<String, dynamic> setupFirebaseTestEnvironment() {
  // Create and configure mocks
  final mockAuth = createMockFirebaseAuth();
  final mockDatabase = MockFirebaseDatabase();
  final mockStorage = MockFirebaseStorage();
  final mockMessaging = MockFirebaseMessaging();

  // Setup basic database mock behaviors
  when(() => mockDatabase.ref(any())).thenReturn(MockDatabaseReference());
  when(() => mockDatabase.ref()).thenReturn(MockDatabaseReference());

  // Setup basic auth mock behaviors
  when(() => mockAuth.currentUser).thenReturn(null);

  return {
    'auth': mockAuth,
    'database': mockDatabase,
    'storage': mockStorage,
    'messaging': mockMessaging,
  };
}

/// Creates a mock FirebaseAuth with common test behaviors
///
/// This provides a pre-configured MockFirebaseAuth that handles
/// common authentication scenarios without requiring Firebase initialization.
MockFirebaseAuth createMockFirebaseAuth({
  User? currentUser,
  bool signInSuccess = true,
  bool emailVerified = true,
}) {
  final mock = MockFirebaseAuth();
  final mockUser = currentUser ?? MockUser();

  when(() => mock.currentUser).thenReturn(currentUser);

  if (currentUser != null) {
    when(() => mockUser.uid).thenReturn('test-uid');
    when(() => mockUser.displayName).thenReturn('Test User');
    when(() => mockUser.email).thenReturn('test@example.com');
    when(() => mockUser.emailVerified).thenReturn(emailVerified);
    when(() => mockUser.reload()).thenAnswer((_) async {});
    when(() => mockUser.sendEmailVerification()).thenAnswer((_) async {});
    when(() => mockUser.updateDisplayName(any())).thenAnswer((_) async {});
  }

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

/// Creates a mock FirebaseDatabase with common test behaviors
///
/// This provides a pre-configured MockFirebaseDatabase that handles
/// common database operations without requiring Firebase initialization.
MockFirebaseDatabase createMockFirebaseDatabase() {
  final mock = MockFirebaseDatabase();
  final mockRef = MockDatabaseReference();

  when(() => mock.ref(any())).thenReturn(mockRef);
  when(() => mock.ref()).thenReturn(mockRef);

  // Setup common reference behaviors
  when(() => mockRef.child(any())).thenReturn(mockRef);
  when(() => mockRef.update(any())).thenAnswer((_) async => null);
  when(() => mockRef.get()).thenAnswer((_) async => MockDataSnapshot());
  when(() => mockRef.onValue)
      .thenAnswer((_) => Stream.value(MockDatabaseEvent()));
  when(() => mockRef.remove()).thenAnswer((_) async => null);

  return mock;
}
