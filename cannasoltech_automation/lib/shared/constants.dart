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
// ignore_for_file: constant_identifier_names

/// System state constant for reset operation
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

/// System state constant for cool-down phase
const int COOL_DOWN = 5;

/// Display constant for no element selected
const int NO_ELEMENT = -1;

/// Display constant for showing sonicator element
const int SHOW_SONICATOR = 0;

/// Display constant for showing pump element
const int SHOW_PUMP = 1;

/// Display constant for showing tank element
const int SHOW_TANK = 2;

/// Page title for system running state
const String RUN_TITLE = "System Running";

/* - - - - - - - - - - - - - - - - - - */
/* - - - - - - FILE PATHS. - - - - - - */
/* - - - - - - - - - - - - - - - - - - */

/* Logging */
const String LOG_FILE_PATH = "log.txt";

/* System Elements */
const String TANK_PATH = "assets/images/Tank.png";
const String PUMP_PATH = "assets/images/pump.png";
const String LARGE_ICON = "assets/images/BigIcon2.png";
const String SONIC_PATH = "assets/images/sonicator2.png";

/* Icons */
const String WARN_ICON = "assets/images/warn.jpg";
const String LOCK_OPEN = "assets/images/padlock_open.avif";

/* Documents */
const String PP_PATH = "assets/documents/privacy_policy.md";
const String TAC_PATH = "assets/documents/terms_and_conditions.md";

// const Color originalConfirmButtonColor = Color.fromARGB(156, 95, 103, 97);
Color originalConfirmButtonColor = Colors.blueGrey.withAlpha(20);
const freqLockWidth = 52;
