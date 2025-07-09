// Test helper utilities for main.dart testing
// Provides mock classes and test utilities for comprehensive testing

import 'package:flutter/material.dart';
import 'package:mocktail/mocktail.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:cannasoltech_automation/providers/system_data_provider.dart';
import 'package:cannasoltech_automation/providers/display_data_provider.dart';
import 'package:cannasoltech_automation/providers/transform_provider.dart';
import 'package:cannasoltech_automation/data_models/device.dart';
import 'package:cannasoltech_automation/handlers/alarm_handler.dart';
import 'package:cannasoltech_automation/handlers/config_handler.dart';
import 'package:cannasoltech_automation/handlers/state_handler.dart';

/// Mock Firebase Auth for testing authentication flows
class MockFirebaseAuth extends Mock implements FirebaseAuth {}

/// Mock User for testing authenticated states
class MockUser extends Mock implements User {
  @override
  String get uid => 'test-user-id';
  
  @override
  String? get email => 'test@example.com';
  
  @override
  String? get displayName => 'Test User';
}

/// Mock SystemDataModel with common test behaviors
class MockSystemDataModel extends Mock implements SystemDataModel {
  final MockDevices _devices = MockDevices();
  
  @override
  MockDevices get devices => _devices;
  
  @override
  Device? get activeDevice => MockDevice();
}

/// Mock DisplayDataModel with common test behaviors
class MockDisplayDataModel extends Mock implements DisplayDataModel {
  int _selectedItem = 0;
  
  @override
  int get bottomNavSelectedItem => _selectedItem;
  
  @override
  void setBottomNavSelectedItem(int index) {
    _selectedItem = index;
  }
}

/// Mock TransformModel with rotation functionality
class MockTransformModel extends Mock implements TransformModel {
  int _rotateFactor = 0;
  
  @override
  int get rotateFactor => _rotateFactor;
  
  @override
  void init() {
    // Mock initialization
  }
  
  @override
  void dispose() {
    // Mock disposal
  }
}

/// Mock SystemIdx for system element navigation
class MockSystemIdx extends Mock implements SystemIdx {
  int _value = 0;
  
  @override
  int get value => _value;
  
  @override
  void set(int index) {
    _value = index;
  }
  
  @override
  void init() {
    // Mock initialization
  }
}

/// Mock Devices collection for device management testing
class MockDevices extends Mock {
  final Map<String, String> _idNameMap = {
    'device-1': 'Test Device 1',
    'device-2': 'Test Device 2',
    'device-3': 'Test Device 3',
  };
  
  String? getNameFromId(String id) {
    return _idNameMap[id] ?? 'Unknown Device';
  }
  
  Map<String, String> get idNameMap => _idNameMap;
}

/// Mock Device for device-specific testing
class MockDevice extends Mock implements Device {
  @override
  String get id => 'test-device-id';
  
  @override
  String get name => 'Test Device';
  
  @override
  String get status => 'online';
  
  @override
  String get type => 'test-type';
  
  @override
  ConfigHandler get config => MockConfigHandler();
  
  @override
  StateHandler get state => MockStateHandler();
  
  @override
  AlarmsModel get alarms => MockAlarmsModel();
}

/// Mock ConfigHandler for device configuration testing
class MockConfigHandler extends Mock implements ConfigHandler {
  @override
  bool get pumpControl => false;
  
  @override
  void setPumpControl(bool value) {
    // Mock implementation
  }
  
  @override
  double get setTemp => 25.0;
  
  @override
  double get batchSize => 100.0;
}

/// Mock StateHandler for device state testing
class MockStateHandler extends Mock implements StateHandler {
  @override
  int get state => 0; // INIT state
  
  @override
  double get temperature => 20.0;
  
  @override
  double get flow => 50.0;
  
  @override
  double get pressure => 1.0;
  
  @override
  String get runTime => "00:00:00";
}

/// Mock AlarmsModel for alarm testing
class MockAlarmsModel extends Mock implements AlarmsModel {
  @override
  bool get tempAlarmActive => false;
  
  @override
  bool get flowAlarmActive => false;
  
  @override
  bool get pressureAlarmActive => false;
  
  @override
  bool get freqLockAlarmActive => false;
  
  @override
  bool get overloadAlarmActive => false;
}

/// Test utility class for creating test widgets with providers
class TestWidgetFactory {
  /// Creates a MaterialApp with all required providers for testing
  static Widget createTestApp({
    required Widget child,
    User? currentUser,
    SystemDataModel? systemDataModel,
    DisplayDataModel? displayDataModel,
    TransformModel? transformModel,
    SystemIdx? systemIdx,
  }) {
    return MaterialApp(
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider<SystemDataModel>.value(
            value: systemDataModel ?? MockSystemDataModel(),
          ),
          ChangeNotifierProvider<DisplayDataModel>.value(
            value: displayDataModel ?? MockDisplayDataModel(),
          ),
          ChangeNotifierProvider<TransformModel>.value(
            value: transformModel ?? MockTransformModel(),
          ),
          ChangeNotifierProvider<SystemIdx>.value(
            value: systemIdx ?? MockSystemIdx(),
          ),
          StreamProvider<User?>.value(
            value: Stream.value(currentUser),
            initialData: currentUser,
          ),
        ],
        child: child,
      ),
    );
  }
  
  /// Creates a test route settings for navigation testing
  static RouteSettings createPushRouteSettings({
    required String deviceId,
    required String alarm,
    required String active,
  }) {
    return RouteSettings(
      name: 'push_notification',
      arguments: {
        'deviceId': deviceId,
        'alarm': alarm,
        'active': active,
      },
    );
  }
}

/// Test data factory for creating consistent test data
class TestDataFactory {
  static const String testDeviceId = 'test-device-123';
  static const String testAlarmName = 'Flow';
  static const String testUserId = 'test-user-456';
  
  /// Creates test alarm data for push notifications
  static Map<String, dynamic> createAlarmData({
    String? deviceId,
    String? alarm,
    String? active,
  }) {
    return {
      'deviceId': deviceId ?? testDeviceId,
      'alarm': alarm ?? testAlarmName,
      'active': active ?? 'True',
    };
  }
  
  /// Creates test user data
  static MockUser createTestUser({
    String? uid,
    String? email,
    String? displayName,
  }) {
    final user = MockUser();
    when(() => user.uid).thenReturn(uid ?? testUserId);
    when(() => user.email).thenReturn(email ?? 'test@example.com');
    when(() => user.displayName).thenReturn(displayName ?? 'Test User');
    return user;
  }
}

/// Mock setup utility for consistent mock configurations
class MockSetup {
  /// Sets up all mocks with default behaviors
  static void setupDefaultMocks({
    required MockSystemDataModel systemDataModel,
    required MockDisplayDataModel displayDataModel,
    required MockTransformModel transformModel,
    required MockSystemIdx systemIdx,
  }) {
    // Setup SystemDataModel mocks
    when(() => systemDataModel.setSelectedDeviceFromName(any())).thenReturn(null);
    when(() => systemDataModel.devices).thenReturn(MockDevices());
    
    // Setup DisplayDataModel mocks
    when(() => displayDataModel.setBottomNavSelectedItem(any())).thenReturn(null);
    
    // Setup TransformModel mocks
    when(() => transformModel.init()).thenReturn(null);
    when(() => transformModel.dispose()).thenReturn(null);
    
    // Setup SystemIdx mocks
    when(() => systemIdx.init()).thenReturn(null);
    when(() => systemIdx.set(any())).thenReturn(null);
  }
  
  /// Sets up Firebase Auth mock with authentication state changes
  static MockFirebaseAuth setupFirebaseAuthMock({User? user}) {
    final mockAuth = MockFirebaseAuth();
    when(() => mockAuth.authStateChanges()).thenAnswer(
      (_) => Stream<User?>.value(user),
    );
    return mockAuth;
  }
}

/// Verification utilities for test assertions
class TestVerifications {
  /// Verifies that navigation setup was called correctly
  static void verifyNavigationSetup(
    MockDisplayDataModel displayDataModel,
    MockSystemDataModel systemDataModel,
    String expectedDeviceName,
  ) {
    verify(() => displayDataModel.setBottomNavSelectedItem(0)).called(1);
    verify(() => systemDataModel.setSelectedDeviceFromName(expectedDeviceName)).called(1);
  }
  
  /// Verifies that provider initialization was called
  static void verifyProviderInitialization(
    MockTransformModel transformModel,
    MockSystemIdx systemIdx,
  ) {
    verify(() => transformModel.init()).called(1);
    verify(() => systemIdx.init()).called(1);
  }
}
