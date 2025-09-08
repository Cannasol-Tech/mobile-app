/**
 * @file user_handler.dart
 * @author Stephen Boyett
 * @date 2025-09-06
 * @brief User authentication and profile management handler.
 * @details Manages user authentication, profile data, device associations,
 *          and user preferences including email notifications and device selection.
 * @version 1.0
 * @since 1.0
 */

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../shared/methods.dart';
import '../shared/snacks.dart';

/**
 * @brief Handles user authentication and profile management.
 * @details Manages user authentication state, profile information, device associations,
 *          and user preferences with Firebase integration.
 * @since 1.0
 */
class UserHandler{

  /// User's unique identifier from Firebase Auth
  String? uid;

  /// Firebase Authentication instance
  dynamic auth = FirebaseAuth.instance;

  /// Device token for push notifications
  dynamic _deviceToken;

  /// Flag indicating if the handler is initialized
  bool initialized = false;

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

  UserHandler.uninitialized(){
    initialized = false;
  }

  Future<void> initialize() async {
    dynamic currentUser = auth.currentUser;
    if (currentUser != null){
      uid = currentUser.uid;
      _currentUserName = currentUser.displayName;
      _currentEmail = currentUser.email;
      _uidReference = FirebaseDatabase.instance.ref('/users/$uid');
      await _initName();
      await _initEmail();
      await _initSelectedDevice();
      await _initEmailAlertOnAlarm();
      await _initDevices();
      await _initDoesAcceptTaC();
      initialized = true;
    }
    else {
      /* User == null */
      _clear();
    }
  }

  Future<void> _initName() async {
    _uidReference.update({"name" : _currentUserName});
    _uidReference.child('/name').onValue.listen((DatabaseEvent event){
      _currentUserName = event.snapshot.value.toString();
    });
  }

  Future<void> _initEmail() async {
    _uidReference.update({"email" : _currentEmail});
    _uidReference.child('/email').onValue.listen((DatabaseEvent event){
      _currentEmail = event.snapshot.value.toString();
    });
  }

  Future<void> _initSelectedDevice() async {
    _uidReference.child('/selected_device').onValue.listen((DatabaseEvent event) {
      _selectedDevice = event.snapshot.value.toString();
    });
  }
  
  Future<void> _initEmailAlertOnAlarm() async {
    _uidReference.child('/email_on_alarm').onValue.listen((DatabaseEvent event) {
      String check = event.snapshot.value.toString();
      if (check == "true"){
        _emailOnAlarm = true;
      }
      else {
        _emailOnAlarm = false;
      }
    });
  }

  Future<void> _initDoesAcceptTaC() async {
    _uidReference.child('/does_accept_tac').onValue.listen((DatabaseEvent event) {
    String check = event.snapshot.value.toString();
    if (check == "true"){
      _doesAcceptTaC = true;
    }
    else {
      _doesAcceptTaC = false;
    }
  });
}

  Future<bool> getDoesAcceptTaC() async {
    _uidReference.child('/does_accept_tac').get().then((event) {
      if (event.value.toString() == "true"){
        return true;
      }
      else {
        return false;
      }
    });
    return false;
  }

  Future<void> _initDevices() async {
    _devicesReference = FirebaseDatabase.instance.ref('/users/$uid/watched_devices');
    await _devicesReference.get().then((snap) => {
      for (final child in snap.children) {
        _watchedDevices.add(child.key.toString())
      } 
     }, onError: ((error) => {
        initialized = false,
      }));

    _devicesReference.onValue.listen((DatabaseEvent event){
      _watchedDevices = [];
      for (final child in event.snapshot.children) {
        _watchedDevices.add(child.key.toString());
      }
    }, onError: ((error) => {
        initialized = false,
    }));
  }

  void _clear(){
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
    if (auth.currentUser != null){
      auth.currentUser.reload();
      return auth.currentUser.emailVerified;
    }
    return false;
  }

  Future<bool> doesEmailExist(String email) async {
    dynamic userReference = FirebaseDatabase.instance.ref('/users');
    if (userReference != null){
      dynamic userSnapshot = await userReference.get();
      for (dynamic user in userSnapshot.children){
        dynamic emailSnapshot = await user.child('/email').ref.get();
        if (emailSnapshot != null){
          if (emailSnapshot.value.toString().toLowerCase() == email.toLowerCase()){
            return true;
          }
        }
      }
    }
    return false;
  }

  Future<void> acceptTaC() async {
    await _uidReference.update({
      "does_accept_tac" : true
    });
  }

    Future<void> declineTaC() async {
    await _uidReference.update({
      "does_accept_tac" : false
    });
  }

  Future<void> verifyEmail() async {
    if (auth.currentUser!= null && !auth.currentUser.emailVerified) {
      await auth.currentUser.sendEmailVerification();
    }
  }

  Future<void> setUsername(String userName) async {
    auth.currentUser.updateDisplayName(userName);
    await _uidReference.update({
      "name" : userName
    });
  }

  void emailAlertOnAlarm(bool value){
    _uidReference.update({
      "email_on_alarm" : value
    });
  }

  Future<void> setSelectedDeviceId(String selection) async {
    await _uidReference.update({
      "selected_device" : selection
    });
  }

  Future<void> watchDevice(BuildContext context, String deviceId) async {
    if (_uidReference.parent?.key == 'users'){
      if (!_watchedDevices.contains(deviceId)){
        showSnack(context, deviceRegisteredSnack(deviceId));
        _uidReference.child('watched_devices').update({deviceId: true});
      }
      else {
        showSnack(context, deviceAlreadyRegisteredSnack(deviceId));
      }
    }
  }

  setFCMToken(String? token) {
    if (token != null){
      _deviceToken = token;
      _uidReference.child('notification_tokens').update({token: true});
    }
  }

  updateFCMToken(String? token) {
    if (token != null){
      _uidReference.child('/notification_tokens/$_deviceToken').remove();
      _uidReference.child('notification_tokens').update({token: true});
    }
  }

  Future<void> unWatchDevice(String deviceId) async {
    _watchedDevices.remove(deviceId);
    await _uidReference.child('/watched_devices/$deviceId').remove();
  }

  void addDeviceToCurrentUser(String deviceId){
    _devicesReference.update({deviceId : true});
  }

  void removeDeviceFromCurrentUser(String deviceId) {
    _watchedDevices.remove(deviceId);
    _devicesReference.child(deviceId).remove();
  }

  Future<void> removeSelectedDevice() async {
    _selectedDevice = 'None';
    await setSelectedDeviceId('None');
  }

  void reloadUser(){
    auth.currentUser.reload();
  }

  String getUserName(String uid) {
    DatabaseReference userReference = FirebaseDatabase.instance.ref('/users/$uid/name');
    userReference.get().then((snapshot) => {
      if (snapshot.exists){
        _currentUserName = snapshot.value.toString()
      }
    });
    return _currentUserName;
  }
}
