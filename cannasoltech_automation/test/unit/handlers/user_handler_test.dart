/**
 * @file user_handler_test.dart
 * @author Stephen Boyett
 * @date 2025-09-10
 * @brief Comprehensive unit tests for UserHandler class
 * @details Tests all public methods, edge cases, and error conditions
 *          using flutter_test and mocktail for external dependencies
 * @version 1.0
 * @since 1.0
 */

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import 'package:cannasoltech_automation/handlers/user_handler.dart';
import 'package:cannasoltech_automation/api/firebase_api.dart';
import '../../helpers/mocks.dart';

// Add missing mock classes that aren't in the mocks.dart file
class MockUserCredential extends Mock implements UserCredential {}

class FakeAppleIDCredential extends Fake
    implements AuthorizationCredentialAppleID {}

void main() {
  late MockFirebaseAuth mockAuth;
  late MockFirebaseDatabase mockDatabase;
  late MockDatabaseReference mockUserRef;
  late MockDatabaseReference mockDevicesRef;
  late MockDatabaseReference mockRootRef;
  late MockDataSnapshot mockSnapshot;
  late MockDatabaseEvent mockEvent;
  late MockUser mockUser;
  late MockFirebaseApi mockFirebaseApi;
  late MockGoogleSignIn mockGoogleSignIn;
  late MockGoogleSignInAccount mockGoogleAccount;
  late MockGoogleSignInAuthentication mockGoogleAuth;
  late MockBuildContext mockContext;

  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    registerMockFallbacks();
  });

  setUp(() async {
    mockAuth = MockFirebaseAuth();
    mockDatabase = MockFirebaseDatabase();
    mockUserRef = MockDatabaseReference();
    mockDevicesRef = MockDatabaseReference();
    mockRootRef = MockDatabaseReference();
    mockSnapshot = MockDataSnapshot();
    mockEvent = MockDatabaseEvent();
    mockUser = MockUser();
    mockFirebaseApi = MockFirebaseApi();
    mockGoogleSignIn = MockGoogleSignIn();
    mockGoogleAccount = MockGoogleSignInAccount();
    mockGoogleAuth = MockGoogleSignInAuthentication();
    mockContext = MockBuildContext();

    // Initialize Firebase for testing
    await Firebase.initializeApp();

    // Setup default mock behaviors
    when(() => mockAuth.currentUser).thenReturn(mockUser);
    when(() => mockUser.uid).thenReturn('test-uid');
    when(() => mockUser.displayName).thenReturn('Test User');
    when(() => mockUser.email).thenReturn('test@example.com');
    when(() => mockUser.emailVerified).thenReturn(true);

    when(() => mockDatabase.ref(any())).thenReturn(mockRootRef);
    when(() => mockRootRef.child(any())).thenReturn(mockUserRef);
    when(() => mockUserRef.child(any())).thenReturn(mockUserRef);
    when(() => mockUserRef.update(any())).thenAnswer((_) async {});
    when(() => mockUserRef.get()).thenAnswer((_) async => mockSnapshot);
    when(() => mockUserRef.onValue).thenAnswer((_) => Stream.value(mockEvent));

    when(() => mockSnapshot.value).thenReturn('test-value');
    when(() => mockSnapshot.exists).thenReturn(true);
    when(() => mockEvent.snapshot).thenReturn(mockSnapshot);

    when(() => mockFirebaseApi.getToken())
        .thenAnswer((_) async => 'test-token');
    when(() => mockFirebaseApi.setTokenRefreshCallback(any()))
        .thenAnswer((_) async {});
  });

  group('UserHandler Constructor and Initialization', () {
    test('should create UserHandler with custom auth and database', () {
      final handler =
          UserHandler.uninitialized(auth: mockAuth, db: mockDatabase);

      expect(handler.auth, equals(mockAuth));
      expect(handler.initialized, isFalse);
    });

    test('should create UserHandler with default instances', () {
      final handler = UserHandler.uninitialized();

      expect(handler.auth, isNotNull);
      expect(handler.initialized, isFalse);
    });

    test('should initialize successfully with valid user', () async {
      when(() => mockAuth.currentUser).thenReturn(mockUser);
      when(() => mockDatabase.ref('/users/test-uid')).thenReturn(mockUserRef);
      when(() => mockDatabase.ref('/users/test-uid/watched_devices'))
          .thenReturn(mockDevicesRef);
      when(() => mockDevicesRef.get()).thenAnswer((_) async => mockSnapshot);
      when(() => mockSnapshot.children).thenReturn([]);

      final handler =
          UserHandler.uninitialized(auth: mockAuth, db: mockDatabase);
      await handler.initialize();

      expect(handler.initialized, isTrue);
      expect(handler.uid, equals('test-uid'));
      expect(handler.name, equals('Test User'));
      expect(handler.email, equals('test@example.com'));
    });

    test('should handle initialization with null user', () async {
      when(() => mockAuth.currentUser).thenReturn(null);

      final handler =
          UserHandler.uninitialized(auth: mockAuth, db: mockDatabase);
      await handler.initialize();

      expect(handler.initialized, isFalse);
      expect(handler.uid, isNull);
      expect(handler.name, isNull);
      expect(handler.email, isNull);
    });
  });

  group('Authentication Methods', () {
    test('should sign in with email and password successfully', () async {
      when(() => mockAuth.signInWithEmailAndPassword(
            email: 'test@example.com',
            password: 'password123',
          )).thenAnswer((_) async => MockUserCredential());

      final handler =
          UserHandler.uninitialized(auth: mockAuth, db: mockDatabase);

      final result = await handler.signInWithEmailAndPassword(
          'test@example.com', 'password123');

      expect(result, isTrue);
      verify(() => mockAuth.signInWithEmailAndPassword(
            email: 'test@example.com',
            password: 'password123',
          )).called(1);
    });

    test('should handle sign in with email and password failure', () async {
      when(() => mockAuth.signInWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          )).thenThrow(FirebaseAuthException(code: 'user-not-found'));

      final handler =
          UserHandler.uninitialized(auth: mockAuth, db: mockDatabase);

      expect(
        () => handler.signInWithEmailAndPassword(
            'invalid@example.com', 'password'),
        throwsA(isA<FirebaseAuthException>()),
      );
    });

    test('should sign in with Google successfully', () async {
      when(() => mockGoogleSignIn.signIn())
          .thenAnswer((_) async => mockGoogleAccount);
      when(() => mockGoogleAccount.authentication)
          .thenAnswer((_) async => mockGoogleAuth);
      when(() => mockGoogleAuth.accessToken).thenReturn('access-token');
      when(() => mockGoogleAuth.idToken).thenReturn('id-token');
      when(() => mockAuth.signInWithCredential(any()))
          .thenAnswer((_) async => MockUserCredential());

      final handler =
          UserHandler.uninitialized(auth: mockAuth, db: mockDatabase);

      final result = await handler.signInWithGoogle();

      expect(result, isTrue);
      verify(() => mockGoogleSignIn.signIn()).called(1);
      verify(() => mockAuth.signInWithCredential(any())).called(1);
    });

    test('should handle Google sign in cancellation', () async {
      when(() => mockGoogleSignIn.signIn()).thenAnswer((_) async => null);

      final handler =
          UserHandler.uninitialized(auth: mockAuth, db: mockDatabase);

      final result = await handler.signInWithGoogle();

      expect(result, isFalse);
      verify(() => mockGoogleSignIn.signIn()).called(1);
      verifyNever(() => mockAuth.signInWithCredential(any()));
    });

    test('should handle Apple Sign In unavailability', () async {
      when(() => SignInWithApple.isAvailable()).thenAnswer((_) async => false);

      final handler =
          UserHandler.uninitialized(auth: mockAuth, db: mockDatabase);

      expect(
        () async => await handler.signInWithApple(),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('User Profile Management', () {
    test('should set username successfully', () async {
      when(() => mockUser.updateDisplayName('New Name'))
          .thenAnswer((_) async {});
      when(() => mockAuth.currentUser).thenReturn(mockUser);

      final handler =
          UserHandler.uninitialized(auth: mockAuth, db: mockDatabase);
      handler.uid = 'test-uid';

      await handler.setUsername('New Name');

      verify(() => mockUser.updateDisplayName('New Name')).called(1);
      verify(() => mockUserRef.update({'name': 'New Name'})).called(1);
    });

    test('should set email alert preference', () {
      final handler =
          UserHandler.uninitialized(auth: mockAuth, db: mockDatabase);
      handler.uid = 'test-uid';

      handler.emailAlertOnAlarm(true);

      verify(() => mockUserRef.update({'email_on_alarm': true})).called(1);
    });

    test('should set selected device ID', () async {
      final handler =
          UserHandler.uninitialized(auth: mockAuth, db: mockDatabase);
      handler.uid = 'test-uid';

      await handler.setSelectedDeviceId('device-123');

      verify(() => mockUserRef.update({'selected_device': 'device-123'}))
          .called(1);
    });

    test('should remove selected device', () async {
      final handler =
          UserHandler.uninitialized(auth: mockAuth, db: mockDatabase);
      handler.uid = 'test-uid';

      await handler.removeSelectedDevice();

      verify(() => mockUserRef.update({'selected_device': 'None'})).called(1);
    });
  });

  group('Device Management', () {
    test('should watch device successfully', () async {
      final handler =
          UserHandler.uninitialized(auth: mockAuth, db: mockDatabase);
      handler.uid = 'test-uid';

      await handler.watchDevice(mockContext, 'device-123');

      verify(() =>
              mockUserRef.child('watched_devices').update({'device-123': true}))
          .called(1);
    });

    test('should unwatch device', () async {
      final handler =
          UserHandler.uninitialized(auth: mockAuth, db: mockDatabase);
      handler.uid = 'test-uid';

      await handler.unWatchDevice('device-123');

      verify(() => mockUserRef.child('/watched_devices/device-123').remove())
          .called(1);
    });

    test('should add device to current user', () {
      final handler =
          UserHandler.uninitialized(auth: mockAuth, db: mockDatabase);
      handler.uid = 'test-uid';

      handler.addDeviceToCurrentUser('device-456');

      verify(() => mockDevicesRef.update({'device-456': true})).called(1);
    });

    test('should remove device from current user', () {
      final handler =
          UserHandler.uninitialized(auth: mockAuth, db: mockDatabase);
      handler.uid = 'test-uid';

      handler.removeDeviceFromCurrentUser('device-456');

      verify(() => mockDevicesRef.child('device-456').remove()).called(1);
    });
  });

  group('Email and Verification', () {
    test('should return true when email is verified', () {
      when(() => mockAuth.currentUser).thenReturn(mockUser);
      when(() => mockUser.emailVerified).thenReturn(true);

      final handler =
          UserHandler.uninitialized(auth: mockAuth, db: mockDatabase);

      final result = handler.isEmailVerified();

      expect(result, isTrue);
    });

    test('should return false when email is not verified', () {
      when(() => mockAuth.currentUser).thenReturn(mockUser);
      when(() => mockUser.emailVerified).thenReturn(false);

      final handler =
          UserHandler.uninitialized(auth: mockAuth, db: mockDatabase);

      final result = handler.isEmailVerified();

      expect(result, isFalse);
    });

    test('should return false when currentUser is null', () {
      when(() => mockAuth.currentUser).thenReturn(null);

      final handler =
          UserHandler.uninitialized(auth: mockAuth, db: mockDatabase);

      final result = handler.isEmailVerified();

      expect(result, isFalse);
    });

    test('should send email verification', () async {
      when(() => mockAuth.currentUser).thenReturn(mockUser);
      when(() => mockUser.emailVerified).thenReturn(false);
      when(() => mockUser.sendEmailVerification()).thenAnswer((_) async {});

      final handler =
          UserHandler.uninitialized(auth: mockAuth, db: mockDatabase);

      await handler.verifyEmail();

      verify(() => mockUser.sendEmailVerification()).called(1);
    });

    test('should not send email verification when already verified', () async {
      when(() => mockAuth.currentUser).thenReturn(mockUser);
      when(() => mockUser.emailVerified).thenReturn(true);

      final handler =
          UserHandler.uninitialized(auth: mockAuth, db: mockDatabase);

      await handler.verifyEmail();

      verifyNever(() => mockUser.sendEmailVerification());
    });
  });

  group('Terms and Conditions', () {
    test('should accept terms and conditions', () async {
      final handler =
          UserHandler.uninitialized(auth: mockAuth, db: mockDatabase);
      handler.uid = 'test-uid';

      await handler.acceptTaC();

      verify(() => mockUserRef.update({'does_accept_tac': true})).called(1);
    });

    test('should decline terms and conditions', () async {
      final handler =
          UserHandler.uninitialized(auth: mockAuth, db: mockDatabase);
      handler.uid = 'test-uid';

      await handler.declineTaC();

      verify(() => mockUserRef.update({'does_accept_tac': false})).called(1);
    });
  });

  group('FCM Token Management', () {
    test('should set FCM token', () {
      final handler =
          UserHandler.uninitialized(auth: mockAuth, db: mockDatabase);
      handler.uid = 'test-uid';

      handler.setFCMToken('test-token');

      verify(() => mockUserRef
          .child('notification_tokens')
          .update({'test-token': true})).called(1);
    });

    test('should not set null FCM token', () {
      final handler =
          UserHandler.uninitialized(auth: mockAuth, db: mockDatabase);

      handler.setFCMToken(null);

      verifyNever(() => mockUserRef.child('notification_tokens').update(any()));
    });
  });

  group('User Information Retrieval', () {
    test('should get user name by UID', () async {
      when(() => mockDatabase.ref('/users/test-uid/name'))
          .thenReturn(mockUserRef);
      when(() => mockUserRef.get()).thenAnswer((_) async => mockSnapshot);
      when(() => mockSnapshot.exists).thenReturn(true);
      when(() => mockSnapshot.value).thenReturn('Retrieved User');

      final handler =
          UserHandler.uninitialized(auth: mockAuth, db: mockDatabase);

      final result = handler.getUserName('test-uid');

      expect(result, equals('Retrieved User'));
    });

    test('should reload user', () {
      when(() => mockAuth.currentUser).thenReturn(mockUser);
      when(() => mockUser.reload()).thenAnswer((_) async {});

      final handler =
          UserHandler.uninitialized(auth: mockAuth, db: mockDatabase);

      handler.reloadUser();

      verify(() => mockUser.reload()).called(1);
    });
  });

  group('Error Handling and Edge Cases', () {
    test('should handle database errors during initialization', () async {
      when(() => mockAuth.currentUser).thenReturn(mockUser);
      when(() => mockDatabase.ref('/users/test-uid')).thenReturn(mockUserRef);
      when(() => mockDatabase.ref('/users/test-uid/watched_devices'))
          .thenReturn(mockDevicesRef);
      when(() => mockDevicesRef.get()).thenThrow(Exception('Database error'));

      final handler =
          UserHandler.uninitialized(auth: mockAuth, db: mockDatabase);

      await handler.initialize();

      expect(handler.initialized, isFalse);
    });

    test('should handle authentication errors during sign in', () async {
      when(() => mockAuth.signInWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          )).thenThrow(FirebaseAuthException(code: 'invalid-credential'));

      final handler =
          UserHandler.uninitialized(auth: mockAuth, db: mockDatabase);

      expect(
        () => handler.signInWithEmailAndPassword(
            'test@example.com', 'wrong-password'),
        throwsA(isA<FirebaseAuthException>()),
      );
    });

    test('should handle Google sign in errors', () async {
      when(() => mockGoogleSignIn.signIn())
          .thenThrow(Exception('Google Sign-In failed'));

      final handler =
          UserHandler.uninitialized(auth: mockAuth, db: mockDatabase);

      expect(
        () => handler.signInWithGoogle(),
        throwsA(isA<Exception>()),
      );
    });
  });
}
