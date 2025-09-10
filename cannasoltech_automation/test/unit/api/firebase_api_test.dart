// Unit Tests for FirebaseApi
//
// This file contains unit tests for the FirebaseApi class.
//
// Testing Framework: flutter_test + mocktail
// Coverage Target: ≥85% statement coverage

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:cannasoltech_automation/api/firebase_api.dart';

import '../../helpers/mocks.dart';
import '../../helpers/test_utils.dart';

// Mock RemoteMessage for testing
class MockRemoteMessage extends Mock implements RemoteMessage {}

void main() {
  group('FirebaseApi', () {
    late FirebaseApi firebaseApi;
    late MockFirebaseMessaging mockFirebaseMessaging;
    late MockNavigatorState mockNavigatorState;
    late GlobalKey<NavigatorState> mockNavigatorKey;

    setUp(() {
      setupFirebaseAuthMocks(); // Sets up Firebase Core mocks
      mockFirebaseMessaging = MockFirebaseMessaging();
      mockNavigatorState = MockNavigatorState();
      mockNavigatorKey =
          MockGlobalKey<NavigatorState>(); // Use a mock GlobalKey
      final mockAuth = MockFirebaseAuth();

      // Inject mocks into FirebaseApi
      firebaseApi = FirebaseApi(
        firebaseMessaging: mockFirebaseMessaging,
        navigatorKey: mockNavigatorKey,
        auth: mockAuth,
      );

      // Stub the currentState of the mock key
      when(() => mockNavigatorKey.currentState).thenReturn(mockNavigatorState);
    });

    test('getToken should return a token on success', () async {
      // Arrange
      when(() => mockFirebaseMessaging.getToken())
          .thenAnswer((_) async => 'test_token');

      // Act
      final token = await firebaseApi.getToken();

      // Assert
      expect(token, 'test_token');
    });

    test('handleMessage should navigate on alarm notification', () {
      // Arrange
      final message = MockRemoteMessage();
      when(() => message.notification)
          .thenReturn(const RemoteNotification(title: 'System Alarm!'));
      when(() => message.data)
          .thenReturn({'deviceId': 'test_device', 'alarm': 'flow_alarm'});
      when(() => mockNavigatorState.pushNamed(any(),
          arguments: any(named: 'arguments'))).thenAnswer((_) async => null);

      // Act
      firebaseApi.handleMessage(message);

      // Assert
      verify(() => mockNavigatorState.pushNamed('/push_alarm',
          arguments: message.data)).called(1);
    });
  });
}
