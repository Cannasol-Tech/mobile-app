// Unit Tests for UserHandler
//
// This file contains unit tests for the UserHandler class, which manages
// user authentication, profile data, and device associations.
//
// Testing Framework: flutter_test + mocktail
// Coverage Target: ≥85% statement coverage
// Mocking: All external dependencies (Firebase) are mocked.

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:cannasoltech_automation/handlers/user_handler.dart';

import '../../helpers/mocks.dart';
import '../../helpers/test_utils.dart';

void main() {
  // Register fallback values for Mocktail and mock Firebase
  setUpAll(() {
    setupFirebaseAuthMocks();
    registerMockFallbacks();
  });

  group('UserHandler Tests', () {
    late UserHandler userHandler;
    late MockFirebaseAuth mockAuth;
    late MockUser mockUser;
    late MockFirebaseDatabase mockDatabase;
    late MockDatabaseReference mockUidRef;

    setUp(() {
      mockAuth = MockFirebaseAuth();
      mockUser = MockUser();
      mockDatabase = MockFirebaseDatabase();
      mockUidRef = MockDatabaseReference();


      userHandler = UserHandler.uninitialized(auth: mockAuth, db: mockDatabase);

      // Default mock behaviors
      when(() => mockAuth.currentUser).thenReturn(mockUser);
      when(() => mockUser.uid).thenReturn('test_uid');
      when(() => mockUser.displayName).thenReturn('Test User');
      when(() => mockUser.email).thenReturn('test@example.com');
      when(() => mockDatabase.ref(any())).thenReturn(mockUidRef);
      when(() => mockUidRef.child(any())).thenReturn(mockUidRef);
      when(() => mockUidRef.update(any())).thenAnswer((_) async {});
      when(() => mockUidRef.onValue).thenAnswer((_) => const Stream.empty());

      // Stub for the .get() method
      final mockDevicesSnapshot = MockDataSnapshot();
      when(() => mockDevicesSnapshot.children).thenReturn([]); // No devices by default
      when(() => mockUidRef.get()).thenAnswer((_) async => mockDevicesSnapshot);
    });

    test('uninitialized constructor should set initialized to false', () {
      expect(userHandler.initialized, isFalse);
    });

    test('initialize should set user data when user is logged in', () async {
      // Arrange
      final nameSnapshot = MockDataSnapshot();
      final nameDbEvent = MockDatabaseEvent();
      when(() => nameSnapshot.value).thenReturn('Test User');
      when(() => nameDbEvent.snapshot).thenReturn(nameSnapshot);

      final emailSnapshot = MockDataSnapshot();
      final emailDbEvent = MockDatabaseEvent();
      when(() => emailSnapshot.value).thenReturn('test@example.com');
      when(() => emailDbEvent.snapshot).thenReturn(emailSnapshot);

      final devicesSnapshot = MockDataSnapshot();
      final devicesDbEvent = MockDatabaseEvent();
      when(() => devicesSnapshot.children).thenReturn([]);
      when(() => devicesDbEvent.snapshot).thenReturn(devicesSnapshot);

      when(() => mockUidRef.child('name').onValue).thenAnswer((_) => Stream.value(nameDbEvent));
      when(() => mockUidRef.child('email').onValue).thenAnswer((_) => Stream.value(emailDbEvent));
      when(() => mockUidRef.child('selected_device').onValue).thenAnswer((_) => Stream.empty());
      when(() => mockUidRef.child('email_on_alarm').onValue).thenAnswer((_) => Stream.empty());
      when(() => mockUidRef.child('does_accept_tac').onValue).thenAnswer((_) => Stream.empty());
      when(() => mockUidRef.child('watched_devices').onValue).thenAnswer((_) => Stream.value(devicesDbEvent));

      // Act
      await userHandler.initialize();

      // Assert
      expect(userHandler.initialized, isTrue);
      expect(userHandler.uid, 'test_uid');
      expect(userHandler.name, 'Test User');
      expect(userHandler.email, 'test@example.com');
    });

    test('initialize should clear data when user is null', () async {
      // Arrange
      when(() => mockAuth.currentUser).thenReturn(null);

      // Act
      await userHandler.initialize();

      // Assert
      expect(userHandler.initialized, isFalse);
      expect(userHandler.uid, isNull);
      expect(userHandler.name, isNull);
      expect(userHandler.email, isNull);
    });

    test('setUsername should update display name and database', () async {
      // Arrange
      when(() => mockUser.updateDisplayName(any())).thenAnswer((_) async {});
      await userHandler.initialize();

      // Act
      await userHandler.setUsername('New Name');

      // Assert
      verify(() => mockUser.updateDisplayName('New Name')).called(1);
      verify(() => mockUidRef.update({'name': 'New Name'})).called(1);
    });

    test('emailAlertOnAlarm should update database', () async {
      // Arrange
      await userHandler.initialize();

      // Act
      userHandler.emailAlertOnAlarm(false);

      // Assert
      verify(() => mockUidRef.update({'email_on_alarm': false})).called(1);
    });
  });
}
