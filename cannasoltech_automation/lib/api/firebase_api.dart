/**
 * @file firebase_api.dart
 * @author Stephen Boyett
 * @date 2025-09-06
 * @brief Firebase API service for handling Firebase Cloud Messaging and authentication.
 * @details Provides comprehensive Firebase integration including push notifications,
 *          background message handling, token management, and alarm notification processing.
 * @version 1.0
 * @since 1.0
 */

import 'dart:io';
import '../objects/logger.dart';
import '../firebase_options.dart';
import '../objects/alarm_notification.dart';
import 'package:cannasoltech_automation/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

/**
 * @brief Background message handler for Firebase Cloud Messaging.
 * @details Handles incoming FCM messages when the app is in the background.
 *          Initializes Firebase and logs message processing.
 * @param message The remote message received from FCM
 * @throws Exception if Firebase initialization fails
 * @since 1.0
 */
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  try {
    await Firebase.initializeApp(
        name: "cannasoltech", options: DefaultFirebaseOptions.currentPlatform);
    log.info("Handling a background message: ${message.messageId}");
  } catch (e) {
    log.info("Error initializing Firebase in background: $e");
  }
}

/**
 * @brief Firebase API service class for handling Firebase Cloud Messaging operations.
 * @details Provides comprehensive Firebase integration including:
 *          - Initializing Firebase notifications and push notifications
 *          - Handling foreground and background message processing
 *          - Managing FCM tokens and token refresh callbacks
 *          - Processing alarm notifications and navigation
 * @since 1.0
 */
class FirebaseApi {
  /// Firebase Cloud Messaging instance for handling push notifications
  final _firebaseMessaging = FirebaseMessaging.instance;

  /// Firebase Authentication instance for user authentication
  FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> initNotifications() async {
    if (Platform.isIOS) {
      await _firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
      await _firebaseMessaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    } else {
      await _firebaseMessaging.requestPermission();
      // You may set the permission requests to "provisional" which allows the user to choose what type
      // of notifications they would like to receive once the user receives a notification.
      NotificationSettings notificationSettings =
          await FirebaseMessaging.instance.requestPermission(provisional: true);
      log.info("DEBUG -> notification settings = $notificationSettings");
    }

    String? token = await getToken();

    if (token == null) {
      log.info("ERROR -> Error retrieving FCM token.");
    }

    await initPushNotifications();
    await FirebaseMessaging.instance.setAutoInitEnabled(true);
  }

  Future<String?> getToken() async {
    try {
      String? token;
      token = await FirebaseMessaging.instance.getToken();
      log.info("DEBUG -> FCM Token retrieved = $token");
      return token;
    } catch (e) {
      log.info("Error retrieving FCM token: $e");
      return null;
    }
  }

  Future<void> setTokenRefreshCallback(Function function) async {
    _firebaseMessaging.onTokenRefresh.listen((event) => function(event));
  }

  void handleMessage(RemoteMessage? message) {
    if (message == null) return;

    message.notification != null
        ? log.info("debug -> mesage title = ${message.notification?.title}")
        : null;

    if (message.notification != null) {
      if (['System Alarm!', 'Alarm Cleared!']
          .contains(message.notification?.title)) {
        navigatorKey.currentState
            ?.pushNamed('/push_alarm', arguments: message.data);
      }
    }
  }

  void handleForegroundMessage(RemoteMessage? message) {
    if (message == null) return;

    message.notification != null
        ? log.info("debug -> mesage title = ${message.notification?.title}")
        : null;

    if (message.notification != null) {
      if (['System Alarm!'].contains(message.notification?.title)) {
        AlarmNotification(
                deviceId: message.data['deviceId'],
                alarmName: message.data['alarm'])
            .showAlarmBanner();
      } else if (['Alarm Cleared!'].contains(message.notification?.title)) {
        ClearedAlarmNotification(
                deviceId: message.data['deviceId'],
                alarmName: message.data['alarm'])
            .showAlarmBanner();
      }
    }
  }

  Future<void> initPushNotifications() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
            alert: true, badge: true, sound: true);

    //handle notification if the app was terminated and now opened
    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);

    /// attach event listeners for when a notification opens the app
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);

    // Listen to messages when app is closed
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    FirebaseMessaging.onMessage.listen(handleForegroundMessage);
  }
}
