/// @file user_handler.dart
/// @author Stephen Boyett
/// @date 2025-09-06
/// @brief User authentication and profile management handler.
/// @details Manages user authentication, profile data, device associations,
///          and user preferences including email notifications and device selection.
/// @version 1.0
/// @since 1.0

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'dart:math';

import '../shared/methods.dart';
import '../shared/snacks.dart';
import '../api/firebase_api.dart';

/// @brief Handles user authentication and profile management.
/// @details Manages user authentication state, profile information, device associations,
///          and user preferences with Firebase integration.
/// @since 1.0
class UserHandler {
  /// User's unique identifier from Firebase Auth
  String? uid;

  /// Firebase Authentication instance
  final FirebaseAuth auth;

  /// Device token for push notifications
  dynamic _deviceToken;

  /// Flag indicating if the handler is initialized
  bool initialized = false;

  /// Firebase database instance
  final FirebaseDatabase database;

  /// Firebase database reference for user data
  late DatabaseReference _uidReference;

  /// Firebase database reference for devices
  late DatabaseReference _devicesReference;

  /// Private field for current user email
  dynamic _currentEmail;

  /// Getter for current user email
  dynamic get email => _currentEmail;

  /// Private field for current username
  dynamic _currentUserName;

  /// Getter for current username
  dynamic get name => _currentUserName;

  /// Private field for email notification preference
  bool _emailOnAlarm = true;

  /// Getter for email notification preference
  bool get emailOnAlarm => _emailOnAlarm;

  /// Private field for selected device ID
  String _selectedDevice = 'null';

  /// Getter for selected device ID
  String get selectedDevice => _selectedDevice;

  /// Private field for list of watched device IDs
  List<String> _watchedDevices = [];

  /// Getter for list of watched device IDs
  List<String> get watchedDevices => _watchedDevices;

  /// Private field for Terms and Conditions acceptance
  bool _doesAcceptTaC = false;

  /// Getter for Terms and Conditions acceptance status
  bool get doesAcceptTaC => _doesAcceptTaC;

  UserHandler.uninitialized({FirebaseAuth? auth, FirebaseDatabase? db})
      : auth = auth ?? FirebaseAuth.instance,
        database = db ?? FirebaseDatabase.instance {
    initialized = false;
  }

  Future<void> initialize() async {
    dynamic currentUser = auth.currentUser;
    if (currentUser != null) {
      uid = currentUser.uid;
      _currentUserName = currentUser.displayName;
      _currentEmail = currentUser.email;
      _uidReference = database.ref('/users/$uid');
      await _initName();
      await _initEmail();
      await _initSelectedDevice();
      await _initEmailAlertOnAlarm();
      await _initDevices();
      await _initDoesAcceptTaC();
      initialized = true;
    } else {
      /* User == null */
      _clear();
    }
  }

  Future<void> _initName() async {
    _uidReference.update({"name": _currentUserName});
    _uidReference.child('/name').onValue.listen((DatabaseEvent event) {
      _currentUserName = event.snapshot.value.toString();
    });
  }

  Future<void> _initEmail() async {
    _uidReference.update({"email": _currentEmail});
    _uidReference.child('/email').onValue.listen((DatabaseEvent event) {
      _currentEmail = event.snapshot.value.toString();
    });
  }

  Future<void> _initSelectedDevice() async {
    _uidReference
        .child('/selected_device')
        .onValue
        .listen((DatabaseEvent event) {
      _selectedDevice = event.snapshot.value.toString();
    });
  }

  Future<void> _initEmailAlertOnAlarm() async {
    _uidReference
        .child('/email_on_alarm')
        .onValue
        .listen((DatabaseEvent event) {
      String check = event.snapshot.value.toString();
      if (check == "true") {
        _emailOnAlarm = true;
      } else {
        _emailOnAlarm = false;
      }
    });
  }

  Future<void> _initDoesAcceptTaC() async {
    _uidReference
        .child('/does_accept_tac')
        .onValue
        .listen((DatabaseEvent event) {
      String check = event.snapshot.value.toString();
      if (check == "true") {
        _doesAcceptTaC = true;
      } else {
        _doesAcceptTaC = false;
      }
    });
  }

  Future<bool> getDoesAcceptTaC() async {
    _uidReference.child('/does_accept_tac').get().then((event) {
      if (event.value.toString() == "true") {
        return true;
      } else {
        return false;
      }
    });
    return false;
  }

  Future<void> _initDevices() async {
    _devicesReference = database.ref('/users/$uid/watched_devices');
    await _devicesReference.get().then(
        (snap) => {
              for (final child in snap.children)
                {_watchedDevices.add(child.key.toString())}
            },
        onError: ((error) => {
              initialized = false,
            }));

    _devicesReference.onValue.listen((DatabaseEvent event) {
      _watchedDevices = [];
      for (final child in event.snapshot.children) {
        _watchedDevices.add(child.key.toString());
      }
    },
        onError: ((error) => {
              initialized = false,
            }));
  }

  void _clear() {
    _currentUserName = null;
    _currentEmail = null;
    _watchedDevices = [];
    _selectedDevice = 'null';
    _emailOnAlarm = true;
    _deviceToken = null;
    _doesAcceptTaC = false;
    initialized = false;
  }

  bool isEmailVerified() {
    if (auth.currentUser != null) {
      auth.currentUser?.reload();
      return auth.currentUser?.emailVerified ?? false;
    }
    return false;
  }

  Future<bool> doesEmailExist(String email) async {
    dynamic userReference = database.ref('/users');
    if (userReference != null) {
      dynamic userSnapshot = await userReference.get();
      for (dynamic user in userSnapshot.children) {
        dynamic emailSnapshot = await user.child('/email').ref.get();
        if (emailSnapshot != null) {
          if (emailSnapshot.value.toString().toLowerCase() ==
              email.toLowerCase()) {
            return true;
          }
        }
      }
    }
    return false;
  }

  Future<void> acceptTaC() async {
    await _uidReference.update({"does_accept_tac": true});
  }

  Future<void> declineTaC() async {
    await _uidReference.update({"does_accept_tac": false});
  }

  Future<void> verifyEmail() async {
    if (auth.currentUser != null &&
        !(auth.currentUser?.emailVerified ?? true)) {
      await auth.currentUser?.sendEmailVerification();
    }
  }

  Future<void> setUsername(String userName) async {
    await auth.currentUser?.updateDisplayName(userName);
    await _uidReference.update({"name": userName});
  }

  void emailAlertOnAlarm(bool value) {
    _uidReference.update({"email_on_alarm": value});
  }

  Future<void> setSelectedDeviceId(String selection) async {
    await _uidReference.update({"selected_device": selection});
  }

  Future<void> watchDevice(BuildContext context, String deviceId) async {
    if (_uidReference.parent?.key == 'users') {
      if (!_watchedDevices.contains(deviceId)) {
        showSnack(context, deviceRegisteredSnack(deviceId));
        _uidReference.child('watched_devices').update({deviceId: true});
      } else {
        showSnack(context, deviceAlreadyRegisteredSnack(deviceId));
      }
    }
  }

  setFCMToken(String? token) {
    if (token != null) {
      _deviceToken = token;
      _uidReference.child('notification_tokens').update({token: true});
    }
  }

  updateFCMToken(String? token) {
    if (token != null) {
      _uidReference.child('/notification_tokens/$_deviceToken').remove();
      _uidReference.child('notification_tokens').update({token: true});
    }
  }

  Future<void> unWatchDevice(String deviceId) async {
    _watchedDevices.remove(deviceId);
    await _uidReference.child('/watched_devices/$deviceId').remove();
  }

  void addDeviceToCurrentUser(String deviceId) {
    _devicesReference.update({deviceId: true});
  }

  void removeDeviceFromCurrentUser(String deviceId) {
    _watchedDevices.remove(deviceId);
    _devicesReference.child(deviceId).remove();
  }

  Future<void> removeSelectedDevice() async {
    _selectedDevice = 'None';
    await setSelectedDeviceId('None');
  }

  void reloadUser() {
    auth.currentUser?.reload();
  }

  String getUserName(String uid) {
    DatabaseReference userReference = database.ref('/users/$uid/name');
    userReference.get().then((snapshot) => {
          if (snapshot.exists) {_currentUserName = snapshot.value.toString()}
        });
    return _currentUserName;
  }

  /// @brief Sign in with email and password
  /// @details Authenticates user with email and password, then initializes user data
  /// @param email User's email address
  /// @param password User's password
  /// @return Future<bool> true if sign in successful, false otherwise
  /// @since 1.0
  Future<bool> signInWithEmailAndPassword(String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      initialized = false;
      await initialize();
      FirebaseApi fbApi = FirebaseApi();
      String? token = await fbApi.getToken();
      setFCMToken(token);
      fbApi.setTokenRefreshCallback(setFCMToken);
      return true;
    } on FirebaseAuthException catch (e) {
      // Let the UI handle the specific error display
      rethrow;
    } catch (error) {
      // Let the UI handle the generic error display
      rethrow;
    }
  }

  /// @brief Sign in with Google
  /// @details Authenticates user with Google OAuth, then initializes user data
  /// @return `Future<bool>` true if sign in successful, false otherwise
  /// @since 1.0
  Future<bool> signInWithGoogle() async {
    try {
      // Configure GoogleSignIn - let it use platform-specific client IDs from configuration
      final GoogleSignIn googleSignIn = GoogleSignIn();

      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        return false; // User cancelled sign-in
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await auth.signInWithCredential(credential);
      initialized = false;
      await initialize();
      FirebaseApi fbApi = FirebaseApi();
      String? token = await fbApi.getToken();
      setFCMToken(token);
      fbApi.setTokenRefreshCallback(setFCMToken);
      return true;
    } catch (error) {
      // Let the UI handle the error display
      rethrow;
    }
  }

  /// @brief Generate a cryptographically secure random nonce
  /// @details Creates a random string for Apple Sign In security
  /// @param length Length of the nonce (default: 32)
  /// @return String The generated nonce
  /// @since 1.0
  String _generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  /// @brief Create SHA256 hash of a string
  /// @details Helper method for Apple Sign In nonce hashing
  /// @param input String to hash
  /// @return String SHA256 hash
  /// @since 1.0
  String _sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// @brief Sign in with Apple
  /// @details Authenticates user with Apple ID, then initializes user data
  /// @return Future<bool> true if sign in successful, false otherwise
  /// @since 1.0
  Future<bool> signInWithApple() async {
    try {
      // Check if Apple Sign In is available
      final isAvailable = await SignInWithApple.isAvailable();
      if (!isAvailable) {
        throw Exception('Apple Sign In is not available on this device');
      }

      // Generate nonce
      final rawNonce = _generateNonce();
      final nonce = _sha256ofString(rawNonce);

      // Request Apple ID credential
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );

      // Create Firebase credential
      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
      );

      // Sign in with Firebase
      await auth.signInWithCredential(oauthCredential);
      initialized = false;
      await initialize();
      FirebaseApi fbApi = FirebaseApi();
      String? token = await fbApi.getToken();
      setFCMToken(token);
      fbApi.setTokenRefreshCallback(setFCMToken);
      return true;
    } catch (error) {
      // Let the UI handle the error display
      rethrow;
    }
  }
}
