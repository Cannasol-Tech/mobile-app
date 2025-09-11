// Enhanced Unit Tests for UserHandler
//
// Comprehensive tests for user authentication and profile management
// including Firebase integration, device management, and user preferences.
//
// Testing Framework: flutter_test + mocktail
// Coverage Target: ≥85% statement coverage  
// Mocking: Permitted for external dependencies (Firebase, platform services)

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:cannasoltech_automation/handlers/user_handler.dart';
import 'package:cannasoltech_automation/api/firebase_api.dart';
import '../../helpers/mocks.dart';
import '../../helpers/test_data.dart';

void main() {
  late MockFirebaseAuth mockAuth;
  late MockFirebaseDatabase mockDatabase;
  late MockDatabaseReference mockUserRef;
  late MockDatabaseReference mockDevicesRef;
  late MockDataSnapshot mockSnapshot;
  late MockDatabaseEvent mockEvent;
  late MockUser mockUser;
  late MockFirebaseApi mockFirebaseApi;
  late MockGoogleSignIn mockGoogleSignIn;

  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    registerMockFallbacks();
  });

  setUp(() {
    mockAuth = MockFirebaseAuth();
    mockDatabase = MockFirebaseDatabase();
    mockUserRef = MockDatabaseReference();
    mockDevicesRef = MockDatabaseReference();
    mockSnapshot = MockDataSnapshot();
    mockEvent = MockDatabaseEvent();
    mockUser = MockUser();
    mockFirebaseApi = MockFirebaseApi();
    mockGoogleSignIn = MockGoogleSignIn();

    // Setup default mock behaviors for Firebase Auth
    when(() => mockAuth.currentUser).thenReturn(mockUser);
    when(() => mockUser.uid).thenReturn(AuthTestData.validUserId);
    when(() => mockUser.displayName).thenReturn(AuthTestData.validDisplayName);
    when(() => mockUser.email).thenReturn(AuthTestData.validEmail);
    when(() => mockUser.emailVerified).thenReturn(true);
    when(() => mockUser.reload()).thenAnswer((_) async {});

    // Setup default mock behaviors for Firebase Database
    when(() => mockDatabase.ref(any())).thenReturn(mockUserRef);
    when(() => mockUserRef.child(any())).thenReturn(mockUserRef);
    when(() => mockUserRef.update(any())).thenAnswer((_) async => null);
    when(() => mockUserRef.get()).thenAnswer((_) async => mockSnapshot);
    when(() => mockUserRef.onValue).thenAnswer((_) => Stream.value(mockEvent));
    when(() => mockUserRef.remove()).thenAnswer((_) async => null);

    // Setup default mock behaviors for data snapshots
    when(() => mockSnapshot.exists).thenReturn(true);
    when(() => mockSnapshot.value).thenReturn('test-value');
    when(() => mockEvent.snapshot).thenReturn(mockSnapshot);

    // Setup default mock behaviors for Firebase API
    when(() => mockFirebaseApi.getToken()).thenAnswer((_) async => AuthTestData.fcmToken);
    when(() => mockFirebaseApi.setTokenRefreshCallback(any())).thenAnswer((_) async {});
  });

  group('UserHandler Construction and Initialization', () {
    test('should create uninitialized UserHandler with default Firebase instances', () {
      final handler = UserHandler.uninitialized();
      
      expect(handler.initialized, isFalse);
      expect(handler.auth, isNotNull);
      expect(handler.database, isNotNull);
    });

    test('should create uninitialized UserHandler with custom Firebase instances', () {
      final handler = UserHandler.uninitialized(auth: mockAuth, db: mockDatabase);
      
      expect(handler.initialized, isFalse);
      expect(handler.auth, equals(mockAuth));
      expect(handler.database, equals(mockDatabase));
    });

    test('should initialize properly when user is authenticated', () async {
      final handler = UserHandler.uninitialized(auth: mockAuth, db: mockDatabase);
      
      await handler.initialize();
      
      expect(handler.initialized, isTrue);
      expect(handler.uid, equals(AuthTestData.validUserId));
      expect(handler.email, equals(AuthTestData.validEmail));
      expect(handler.name, equals(AuthTestData.validDisplayName));
    });

    test('should clear state when no current user', () async {
      when(() => mockAuth.currentUser).thenReturn(null);
      
      final handler = UserHandler.uninitialized(auth: mockAuth, db: mockDatabase);
      await handler.initialize();
      
      expect(handler.initialized, isFalse);
      expect(handler.uid, isNull);
    });

    test('should handle initialization errors gracefully', () async {
      when(() => mockUserRef.update(any())).thenThrow(Exception('Database error'));
      
      final handler = UserHandler.uninitialized(auth: mockAuth, db: mockDatabase);
      
      // Should not throw exception even if database operations fail
      expect(() => handler.initialize(), returnsNormally);
    });
  });

  group('User Profile Management', () {
    late UserHandler userHandler;

    setUp(() async {
      userHandler = UserHandler.uninitialized(auth: mockAuth, db: mockDatabase);
      await userHandler.initialize();
    });

    test('should update user name in database', () async {
      const newName = 'Updated User Name';
      
      await userHandler.updateName(newName);
      
      verify(() => mockUserRef.update({'name': newName})).called(1);
    });

    test('should update user email in database', () async {
      const newEmail = 'updated@example.com';
      
      await userHandler.updateEmail(newEmail);
      
      verify(() => mockUserRef.update({'email': newEmail})).called(1);
    });

    test('should toggle email notification preference', () async {
      // Initial state should be true (default)
      expect(userHandler.emailOnAlarm, isTrue);
      
      await userHandler.toggleEmailOnAlarm();
      
      verify(() => mockUserRef.update({'email_on_alarm': false})).called(1);
    });

    test('should handle email notification preference updates from database', () async {
      // Simulate database value change to "false"
      when(() => mockSnapshot.value).thenReturn('false');
      
      userHandler = UserHandler.uninitialized(auth: mockAuth, db: mockDatabase);
      await userHandler.initialize();
      
      // The emailOnAlarm should be updated based on database value
      expect(userHandler.emailOnAlarm, isFalse);
    });

    test('should accept Terms and Conditions', () async {
      await userHandler.acceptTaC();
      
      verify(() => mockUserRef.update({'does_accept_tac': true})).called(1);
    });

    test('should handle Terms and Conditions acceptance from database', () async {
      when(() => mockSnapshot.value).thenReturn('true');
      
      userHandler = UserHandler.uninitialized(auth: mockAuth, db: mockDatabase);
      await userHandler.initialize();
      
      expect(userHandler.doesAcceptTaC, isTrue);
    });
  });

  group('Device Management', () {
    late UserHandler userHandler;

    setUp(() async {
      userHandler = UserHandler.uninitialized(auth: mockAuth, db: mockDatabase);
      await userHandler.initialize();
    });

    test('should set selected device ID', () async {
      const deviceId = 'device-123';
      
      userHandler.setSelectedDeviceId(deviceId);
      
      verify(() => mockUserRef.update({'selected_device': deviceId})).called(1);
    });

    test('should add device to user\'s devices', () async {
      const deviceId = 'device-456';
      
      await userHandler.addDevice(deviceId);
      
      verify(() => mockUserRef.child('devices/$deviceId').update({'device_id': deviceId})).called(1);
    });

    test('should remove device from user\'s devices', () async {
      const deviceId = 'device-789';
      
      await userHandler.removeDevice(deviceId);
      
      verify(() => mockUserRef.child('devices/$deviceId').remove()).called(1);
    });

    test('should handle watched devices list updates', () async {
      final mockChildren = [mockSnapshot, mockSnapshot];
      when(() => mockSnapshot.children).thenReturn(mockChildren);
      when(() => mockSnapshot.key).thenReturn('device-1');
      
      userHandler = UserHandler.uninitialized(auth: mockAuth, db: mockDatabase);
      await userHandler.initialize();
      
      expect(userHandler.watchedDevices, isA<List<String>>());
    });

    test('should handle empty watched devices list', () async {
      when(() => mockSnapshot.children).thenReturn([]);
      
      userHandler = UserHandler.uninitialized(auth: mockAuth, db: mockDatabase);
      await userHandler.initialize();
      
      expect(userHandler.watchedDevices, isEmpty);
    });
  });

  group('Authentication Operations', () {
    late UserHandler userHandler;

    setUp(() async {
      userHandler = UserHandler.uninitialized(auth: mockAuth, db: mockDatabase);
    });

    test('should handle sign out operation', () async {
      when(() => mockAuth.signOut()).thenAnswer((_) async {});
      
      await userHandler.signOut();
      
      verify(() => mockAuth.signOut()).called(1);
    });

    test('should handle email verification', () async {
      when(() => mockUser.sendEmailVerification()).thenAnswer((_) async {});
      
      await userHandler.sendEmailVerification();
      
      verify(() => mockUser.sendEmailVerification()).called(1);
    });

    test('should reload user data', () async {
      when(() => mockUser.reload()).thenAnswer((_) async {});
      
      await userHandler.reloadUser();
      
      verify(() => mockUser.reload()).called(1);
    });

    test('should handle authentication errors gracefully', () async {
      when(() => mockAuth.signOut()).thenThrow(FirebaseAuthException(
        code: 'network-request-failed',
        message: 'Network error',
      ));
      
      // Should not throw exception
      expect(() => userHandler.signOut(), returnsNormally);
    });
  });

  group('Data Persistence and Synchronization', () {
    late UserHandler userHandler;

    setUp(() async {
      userHandler = UserHandler.uninitialized(auth: mockAuth, db: mockDatabase);
    });

    test('should handle database listener setup during initialization', () async {
      await userHandler.initialize();
      
      // Verify that database listeners are set up
      verify(() => mockUserRef.child('/name').onValue).called(1);
      verify(() => mockUserRef.child('/email').onValue).called(1);
      verify(() => mockUserRef.child('/selected_device').onValue).called(1);
      verify(() => mockUserRef.child('/email_on_alarm').onValue).called(1);
      verify(() => mockUserRef.child('/does_accept_tac').onValue).called(1);
      verify(() => mockUserRef.child('/devices').onValue).called(1);
    });

    test('should handle real-time updates from database', () async {
      const updatedName = 'Real-time Updated Name';
      
      // Setup stream to emit new value
      final streamController = StreamController<DatabaseEvent>();
      when(() => mockUserRef.child('/name').onValue).thenAnswer((_) => streamController.stream);
      when(() => mockSnapshot.value).thenReturn(updatedName);
      
      await userHandler.initialize();
      
      // Emit new value
      streamController.add(mockEvent);
      
      // Wait for stream processing
      await Future.delayed(Duration.zero);
      
      expect(userHandler.name, equals(updatedName));
      
      streamController.close();
    });

    test('should handle FCM token updates', () async {
      when(() => mockFirebaseApi.getToken()).thenAnswer((_) async => 'new-fcm-token');
      
      await userHandler.updateFCMToken();
      
      verify(() => mockFirebaseApi.getToken()).called(1);
      verify(() => mockUserRef.update({'fcm_token': 'new-fcm-token'})).called(1);
    });

    test('should handle FCM token refresh callback', () async {
      await userHandler.setupFCMTokenRefresh();
      
      verify(() => mockFirebaseApi.setTokenRefreshCallback(any())).called(1);
    });
  });

  group('Edge Cases and Error Handling', () {
    late UserHandler userHandler;

    setUp(() {
      userHandler = UserHandler.uninitialized(auth: mockAuth, db: mockDatabase);
    });

    test('should handle null user data gracefully', () async {
      when(() => mockSnapshot.value).thenReturn(null);
      when(() => mockSnapshot.exists).thenReturn(false);
      
      await userHandler.initialize();
      
      // Should not crash with null values
      expect(() => userHandler.initialize(), returnsNormally);
    });

    test('should handle database connection errors', () async {
      when(() => mockUserRef.update(any())).thenThrow(Exception('Connection failed'));
      
      // Should not throw exception
      expect(() => userHandler.updateName('New Name'), returnsNormally);
    });

    test('should handle invalid email format', () async {
      const invalidEmail = 'invalid-email-format';
      
      await userHandler.updateEmail(invalidEmail);
      
      // Should still attempt to update (validation happens elsewhere)
      verify(() => mockUserRef.update({'email': invalidEmail})).called(1);
    });

    test('should handle empty device operations', () async {
      await userHandler.addDevice('');
      await userHandler.removeDevice('');
      userHandler.setSelectedDeviceId('');
      
      // Should handle empty strings gracefully
      expect(() => userHandler.addDevice(''), returnsNormally);
      expect(() => userHandler.removeDevice(''), returnsNormally);
      expect(() => userHandler.setSelectedDeviceId(''), returnsNormally);
    });

    test('should handle re-initialization without issues', () async {
      await userHandler.initialize();
      expect(userHandler.initialized, isTrue);
      
      // Re-initialize should work without issues
      await userHandler.initialize();
      expect(userHandler.initialized, isTrue);
    });
  });

  group('State Management and Getters', () {
    late UserHandler userHandler;

    setUp(() async {
      userHandler = UserHandler.uninitialized(auth: mockAuth, db: mockDatabase);
      await userHandler.initialize();
    });

    test('should provide correct getter values', () {
      expect(userHandler.uid, equals(AuthTestData.validUserId));
      expect(userHandler.email, equals(AuthTestData.validEmail));
      expect(userHandler.name, equals(AuthTestData.validDisplayName));
      expect(userHandler.emailOnAlarm, isA<bool>());
      expect(userHandler.selectedDevice, isA<String>());
      expect(userHandler.watchedDevices, isA<List<String>>());
      expect(userHandler.doesAcceptTaC, isA<bool>());
    });

    test('should handle state changes correctly', () async {
      // Initial state
      expect(userHandler.initialized, isTrue);
      
      // Simulate sign out
      when(() => mockAuth.currentUser).thenReturn(null);
      await userHandler.initialize();
      
      expect(userHandler.initialized, isFalse);
      expect(userHandler.uid, isNull);
    });

    test('should maintain consistency across property updates', () async {
      const newName = 'Consistent Name';
      const newEmail = 'consistent@example.com';
      
      await userHandler.updateName(newName);
      await userHandler.updateEmail(newEmail);
      
      // Verify database was updated consistently
      verify(() => mockUserRef.update({'name': newName})).called(1);
      verify(() => mockUserRef.update({'email': newEmail})).called(1);
    });
  });

  group('Integration Scenarios', () {
    late UserHandler userHandler;

    setUp(() {
      userHandler = UserHandler.uninitialized(auth: mockAuth, db: mockDatabase);
    });

    test('should handle complete user setup flow', () async {
      // Initialize
      await userHandler.initialize();
      expect(userHandler.initialized, isTrue);
      
      // Update profile
      await userHandler.updateName('Complete User');
      await userHandler.updateEmail('complete@example.com');
      
      // Manage devices
      await userHandler.addDevice('device-complete');
      userHandler.setSelectedDeviceId('device-complete');
      
      // Accept ToC
      await userHandler.acceptTaC();
      
      // Enable notifications
      await userHandler.toggleEmailOnAlarm();
      
      // Verify all operations were called
      verify(() => mockUserRef.update({'name': 'Complete User'})).called(1);
      verify(() => mockUserRef.update({'email': 'complete@example.com'})).called(1);
      verify(() => mockUserRef.child('devices/device-complete').update({'device_id': 'device-complete'})).called(1);
      verify(() => mockUserRef.update({'selected_device': 'device-complete'})).called(1);
      verify(() => mockUserRef.update({'does_accept_tac': true})).called(1);
    });

    test('should handle user cleanup on sign out', () async {
      await userHandler.initialize();
      expect(userHandler.initialized, isTrue);
      
      await userHandler.signOut();
      
      verify(() => mockAuth.signOut()).called(1);
    });

    test('should handle multiple concurrent operations', () async {
      await userHandler.initialize();
      
      // Perform multiple operations concurrently
      final futures = [
        userHandler.updateName('Concurrent User'),
        userHandler.updateEmail('concurrent@example.com'),
        userHandler.addDevice('concurrent-device'),
        userHandler.acceptTaC(),
      ];
      
      await Future.wait(futures);
      
      // All operations should complete successfully
      verify(() => mockUserRef.update({'name': 'Concurrent User'})).called(1);
      verify(() => mockUserRef.update({'email': 'concurrent@example.com'})).called(1);
      verify(() => mockUserRef.child('devices/concurrent-device').update({'device_id': 'concurrent-device'})).called(1);
      verify(() => mockUserRef.update({'does_accept_tac': true})).called(1);
    });
  });
}