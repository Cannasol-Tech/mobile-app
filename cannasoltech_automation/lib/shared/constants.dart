/**
 * @file constants.dart
 * @author Stephen Boyett
 * @date 2025-09-06
 * @brief Application-wide constants and configuration values.
 * @details Defines system state constants, UI element identifiers, page titles,
 *          file paths, and other application-wide constant values.
 * @version 1.0
 * @since 1.0
 */

import 'package:flutter/material.dart';
import 'app_constants.dart';

// Re-export the new constants for backward compatibility
// TODO: Update all files to import from app_constants.dart directly

// Device state constants (backward compatibility)
const int RESET = 100;

/// System state constant for initialization
const int INIT = 0;

/// System state constant for warm-up phase
const int WARM_UP = 1;

/// System state constant for running operation
const int RUNNING = 2;

/// System state constant for alarm condition
const int ALARM = 3;

/// System state constant for finished operation
const int FINISHED = 4;

const int COOL_DOWN = 5;

// Display element constants (backward compatibility)  

/// System state constant for cool-down phase
const int COOL_DOWN = 5;

/// Display constant for no element selected
const int NO_ELEMENT = -1;

/// Display constant for showing sonicator element
const int SHOW_SONICATOR = 0;
const int SHOW_PUMP = 1;
const int SHOW_TANK = 2;

// Page titles (backward compatibility)

/// Display constant for showing pump element
const int SHOW_PUMP  = 1;

/// Display constant for showing tank element
const int SHOW_TANK  = 2;

/// Page title for system running state
const String RUN_TITLE = "System Running";

// File paths (backward compatibility)
const String LOG_FILE_PATH = "log.txt";

// Asset paths (backward compatibility)
const String TANK_PATH = "assets/images/Tank.png";
const String PUMP_PATH = "assets/images/pump.png";
const String LARGE_ICON = "assets/images/BigIcon2.png";
const String SONIC_PATH = "assets/images/sonicator2.png";

// Icon paths (backward compatibility)
const String WARN_ICON = "assets/images/warn.jpg";
const String LOCK_OPEN = "assets/images/padlock_open.avif";

// Document paths (backward compatibility)
const String PP_PATH = "assets/documents/privacy_policy.md";
const String TAC_PATH = "assets/documents/terms_and_conditions.md";

// UI constants (backward compatibility)
Color originalConfirmButtonColor = Colors.blueGrey.withAlpha(20);
const freqLockWidth = 52;


