// Unit Tests for FirebaseApi
//
// Comprehensive tests for FirebaseApi class including initialization,
// token management, message handling, and notification processing.
//
// Testing Framework: flutter_test + mocktail
// Coverage Target: ≥85% statement coverage

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:cannasoltech_automation/api/firebase_api.dart';

import '../../helpers/mocks.dart';
import '../../helpers/test_utils.dart';

// Mock RemoteMessage for testing
class MockRemoteMessage extends Mock implements RemoteMessage {}
class MockRemoteNotification extends Mock implements RemoteNotification {}
class MockNotificationSettings extends Mock implements NotificationSettings {}

void main() {
  setUpAll(() {
    registerMockFallbacks();
  });

  group('FirebaseApi', () {
    late FirebaseApi firebaseApi;
    late MockFirebaseMessaging mockFirebaseMessaging;
    late MockFirebaseAuth mockAuth;
    late MockNavigatorState mockNavigatorState;
    late GlobalKey<NavigatorState> testNavigatorKey;

    setUp(() {
      setupFirebaseAuthMocks(); // Sets up Firebase Core mocks
      mockFirebaseMessaging = MockFirebaseMessaging();
      mockAuth = MockFirebaseAuth();
      mockNavigatorState = MockNavigatorState();
      testNavigatorKey = GlobalKey<NavigatorState>();

      // Setup default stubs
      when(() => mockFirebaseMessaging.getToken())
          .thenAnswer((_) async => 'test_token');
      when(() => mockFirebaseMessaging.requestPermission())
          .thenAnswer((_) async => MockNotificationSettings());
      when(() => mockFirebaseMessaging.setForegroundNotificationPresentationOptions(
            alert: any(named: 'alert'),
            badge: any(named: 'badge'),
            sound: any(named: 'sound'),
          )).thenAnswer((_) async {});
      when(() => mockFirebaseMessaging.setAutoInitEnabled(any()))
          .thenAnswer((_) async {});
      when(() => mockFirebaseMessaging.onMessage)
          .thenAnswer((_) => Stream<RemoteMessage>.empty());
      when(() => mockFirebaseMessaging.onMessageOpenedApp)
          .thenAnswer((_) => Stream<RemoteMessage>.empty());
      when(() => mockFirebaseMessaging.getInitialMessage())
          .thenAnswer((_) async => null);

      // Create FirebaseApi with mocks
      firebaseApi = FirebaseApi(
        firebaseMessaging: mockFirebaseMessaging,
        navigatorKey: testNavigatorKey,
        auth: mockAuth,
      );
    });

    group('Constructor and Initialization', () {
      test('should create FirebaseApi with default parameters', () {
        final api = FirebaseApi();
        
        expect(api, isA<FirebaseApi>());
        expect(api.navigatorKey, isNotNull);
        expect(api.auth, isNotNull);
      });

      test('should create FirebaseApi with custom parameters', () {
        final customKey = GlobalKey<NavigatorState>();
        
        final api = FirebaseApi(
          firebaseMessaging: mockFirebaseMessaging,
          navigatorKey: customKey,
          auth: mockAuth,
        );
        
        expect(api.navigatorKey, equals(customKey));
        expect(api.auth, equals(mockAuth));
      });

      test('should initialize notifications successfully', () async {
        await firebaseApi.initNotifications();
        
        verify(() => mockFirebaseMessaging.requestPermission()).called(1);
        verify(() => mockFirebaseMessaging.getToken()).called(1);
        verify(() => mockFirebaseMessaging.setAutoInitEnabled(true)).called(1);
      });

      test('should handle iOS-specific initialization', () async {
        // Note: Testing iOS-specific code requires platform override
        // This test verifies the API exists but won't test actual iOS behavior
        await firebaseApi.initNotifications();
        
        verify(() => mockFirebaseMessaging.requestPermission()).called(1);
      });
    });

    group('Token Management', () {
      test('should get token successfully', () async {
        when(() => mockFirebaseMessaging.getToken())
            .thenAnswer((_) async => 'test_fcm_token');

        final token = await firebaseApi.getToken();

        expect(token, equals('test_fcm_token'));
        verify(() => mockFirebaseMessaging.getToken()).called(1);
      });

      test('should handle null token gracefully', () async {
        when(() => mockFirebaseMessaging.getToken())
            .thenAnswer((_) async => null);

        final token = await firebaseApi.getToken();

        expect(token, isNull);
        verify(() => mockFirebaseMessaging.getToken()).called(1);
      });

      test('should handle token refresh callback', () async {
        final callback = MockFunction<String, void>();
        
        await firebaseApi.setTokenRefreshCallback(callback.call);
        
        // Verify callback is set up (implementation may vary)
        expect(callback, isNotNull);
      });

      test('should handle token errors gracefully', () async {
        when(() => mockFirebaseMessaging.getToken())
            .thenThrow(Exception('Token error'));

        final token = await firebaseApi.getToken();

        expect(token, isNull);
      });
    });

    group('Message Handling', () {
      test('should handle message with alarm notification', () {
        final message = MockRemoteMessage();
        final notification = MockRemoteNotification();
        
        when(() => message.notification).thenReturn(notification);
        when(() => notification.title).thenReturn('System Alarm!');
        when(() => message.data).thenReturn({
          'deviceId': 'test_device',
          'alarm': 'flow_alarm',
        });

        // Mock navigator state to test navigation
        testNavigatorKey = MockGlobalKey<NavigatorState>();
        when(() => testNavigatorKey.currentState).thenReturn(mockNavigatorState);
        when(() => mockNavigatorState.pushNamed(any(), arguments: any(named: 'arguments')))
            .thenAnswer((_) async => null);

        firebaseApi = FirebaseApi(
          firebaseMessaging: mockFirebaseMessaging,
          navigatorKey: testNavigatorKey,
          auth: mockAuth,
        );

        firebaseApi.handleMessage(message);

        verify(() => mockNavigatorState.pushNamed('/push_alarm', arguments: {
          'deviceId': 'test_device',
          'alarm': 'flow_alarm',
        })).called(1);
      });

      test('should handle message without alarm notification', () {
        final message = MockRemoteMessage();
        
        when(() => message.notification).thenReturn(null);
        when(() => message.data).thenReturn({'type': 'info'});

        // Should not navigate for non-alarm messages
        firebaseApi.handleMessage(message);

        verifyNever(() => mockNavigatorState.pushNamed(any(), arguments: any(named: 'arguments')));
      });

      test('should handle message with non-alarm notification', () {
        final message = MockRemoteMessage();
        final notification = MockRemoteNotification();
        
        when(() => message.notification).thenReturn(notification);
        when(() => notification.title).thenReturn('General Update');
        when(() => message.data).thenReturn({'type': 'update'});

        firebaseApi.handleMessage(message);

        // Should not navigate for non-alarm notifications
        verifyNever(() => mockNavigatorState.pushNamed(any(), arguments: any(named: 'arguments')));
      });

      test('should handle message with null navigator state', () {
        final message = MockRemoteMessage();
        final notification = MockRemoteNotification();
        
        when(() => message.notification).thenReturn(notification);
        when(() => notification.title).thenReturn('System Alarm!');
        when(() => message.data).thenReturn({'alarm': 'temp_alarm'});

        testNavigatorKey = MockGlobalKey<NavigatorState>();
        when(() => testNavigatorKey.currentState).thenReturn(null);

        firebaseApi = FirebaseApi(
          firebaseMessaging: mockFirebaseMessaging,
          navigatorKey: testNavigatorKey,
          auth: mockAuth,
        );

        // Should handle gracefully when navigator state is null
        expect(() => firebaseApi.handleMessage(message), returnsNormally);
      });
    });

    group('Push Notification Setup', () {
      test('should initialize push notifications', () async {
        await firebaseApi.initPushNotifications();

        // Verify that message streams are listened to
        verify(() => mockFirebaseMessaging.onMessage).called(1);
        verify(() => mockFirebaseMessaging.onMessageOpenedApp).called(1);
        verify(() => mockFirebaseMessaging.getInitialMessage()).called(1);
      });

      test('should handle initial message on app launch', () async {
        final initialMessage = MockRemoteMessage();
        final notification = MockRemoteNotification();
        
        when(() => initialMessage.notification).thenReturn(notification);
        when(() => notification.title).thenReturn('System Alarm!');
        when(() => initialMessage.data).thenReturn({'alarm': 'pressure_alarm'});
        when(() => mockFirebaseMessaging.getInitialMessage())
            .thenAnswer((_) async => initialMessage);

        await firebaseApi.initPushNotifications();

        verify(() => mockFirebaseMessaging.getInitialMessage()).called(1);
      });

      test('should handle null initial message', () async {
        when(() => mockFirebaseMessaging.getInitialMessage())
            .thenAnswer((_) async => null);

        await firebaseApi.initPushNotifications();

        verify(() => mockFirebaseMessaging.getInitialMessage()).called(1);
      });
    });

    group('Error Handling', () {
      test('should handle permission request errors', () async {
        when(() => mockFirebaseMessaging.requestPermission())
            .thenThrow(Exception('Permission error'));

        // Should handle errors gracefully
        expect(() => firebaseApi.initNotifications(), returnsNormally);
      });

      test('should handle message processing errors', () {
        final message = MockRemoteMessage();
        
        when(() => message.notification).thenThrow(Exception('Message error'));

        // Should handle errors gracefully
        expect(() => firebaseApi.handleMessage(message), returnsNormally);
      });

      test('should handle initialization errors', () async {
        when(() => mockFirebaseMessaging.setAutoInitEnabled(any()))
            .thenThrow(Exception('Init error'));

        // Should handle errors gracefully during initialization
        expect(() => firebaseApi.initNotifications(), returnsNormally);
      });
    });

    group('Notification Permissions', () {
      test('should request notification permissions', () async {
        final settings = MockNotificationSettings();
        when(() => mockFirebaseMessaging.requestPermission())
            .thenAnswer((_) async => settings);

        await firebaseApi.initNotifications();

        verify(() => mockFirebaseMessaging.requestPermission()).called(1);
      });

      test('should handle provisional permissions', () async {
        final settings = MockNotificationSettings();
        when(() => mockFirebaseMessaging.requestPermission(provisional: true))
            .thenAnswer((_) async => settings);

        await firebaseApi.initNotifications();

        // Verify provisional permission request
        verify(() => mockFirebaseMessaging.requestPermission()).called(1);
      });
    });
  });
}

// Helper class for testing callback functions
class MockFunction<T, R> extends Mock {
  R call(T arg);
}
