import 'package:flutter/material.dart';

/// Device state enumeration
/// Replaces the global state constants (RESET, INIT, WARM_UP, etc.)
enum DeviceState {
  reset(100),
  init(0),
  warmUp(1),
  running(2),
  alarm(3),
  finished(4),
  coolDown(5);
  
  const DeviceState(this.value);
  final int value;
  
  /// Get DeviceState from integer value
  static DeviceState fromValue(int value) {
    for (DeviceState state in DeviceState.values) {
      if (state.value == value) {
        return state;
      }
    }
    throw ArgumentError('Invalid device state value: $value');
  }
}

/// Display elements enumeration
/// Replaces the display element constants (NO_ELEMENT, SHOW_SONICATOR, etc.)
enum DisplayElement {
  noElement(-1),
  showSonicator(0),
  showPump(1),
  showTank(2);
  
  const DisplayElement(this.value);
  final int value;
  
  /// Get DisplayElement from integer value
  static DisplayElement fromValue(int value) {
    for (DisplayElement element in DisplayElement.values) {
      if (element.value == value) {
        return element;
      }
    }
    throw ArgumentError('Invalid display element value: $value');
  }
}

/// Asset paths class
/// Replaces the global asset path constants
class AssetPaths {
  static const String logFilePath = "log.txt";
  
  // System Elements
  static const String tankPath = "assets/images/Tank.png";
  static const String pumpPath = "assets/images/pump.png";
  static const String largeIcon = "assets/images/BigIcon2.png";
  static const String sonicPath = "assets/images/sonicator2.png";
  
  // Icons
  static const String warnIcon = "assets/images/warn.jpg";
  static const String lockOpen = "assets/images/padlock_open.avif";
  
  // Documents
  static const String privacyPolicyPath = "assets/documents/privacy_policy.md";
  static const String termsAndConditionsPath = "assets/documents/terms_and_conditions.md";
}

/// Page titles and other UI constants
class UIConstants {
  static const String runTitle = "System Running";
  static const int freqLockWidth = 52;
  
  // Colors
  static Color originalConfirmButtonColor = Colors.blueGrey.withAlpha(20);
}

/// Backward compatibility constants
/// These maintain the original constant names for existing code
/// TODO: Replace these with enum usage throughout the codebase
const int RESET = 100;
const int INIT = 0;
const int WARM_UP = 1;
const int RUNNING = 2;
const int ALARM = 3;
const int FINISHED = 4;
const int COOL_DOWN = 5;

const int NO_ELEMENT = -1;
const int SHOW_SONICATOR = 0;
const int SHOW_PUMP = 1;
const int SHOW_TANK = 2;

const String RUN_TITLE = "System Running";
const String LOG_FILE_PATH = "log.txt";
const String TANK_PATH = "assets/images/Tank.png";
const String PUMP_PATH = "assets/images/pump.png";
const String LARGE_ICON = "assets/images/BigIcon2.png";
const String SONIC_PATH = "assets/images/sonicator2.png";
const String WARN_ICON = "assets/images/warn.jpg";
const String LOCK_OPEN = "assets/images/padlock_open.avif";
const String PP_PATH = "assets/documents/privacy_policy.md";
const String TAC_PATH = "assets/documents/terms_and_conditions.md";

Color originalConfirmButtonColor = Colors.blueGrey.withAlpha(20);
const freqLockWidth = 52;