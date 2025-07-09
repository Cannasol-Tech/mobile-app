import 'package:flutter/material.dart';
// ignore_for_file: constant_identifier_names

const int RESET = 100;
const int INIT = 0;
const int WARM_UP = 1;
const int RUNNING = 2;
const int ALARM = 3;
const int FINISHED = 4;
const int COOL_DOWN = 5; 

/* Show constants */
const int NO_ELEMENT = -1;
const int SHOW_SONICATOR = 0;
const int SHOW_PUMP  = 1;
const int SHOW_TANK  = 2;

/* Page Titles */
const String RUN_TITLE = "System Running";

/* - - - - - - - - - - - - - - - - - - */
/* - - - - - - FILE PATHS. - - - - - - */
/* - - - - - - - - - - - - - - - - - - */

/* Logging */
const String LOG_FILE_PATH = "log.txt";

/* System Elements */
const String TANK_PATH  = "assets/images/Tank.png";
const String PUMP_PATH  = "assets/images/pump.png";
const String LARGE_ICON = "assets/images/BigIcon2.png";
const String SONIC_PATH = "assets/images/sonicator2.png";

/* Icons */
const String WARN_ICON  = "assets/images/warn.jpg";
const String LOCK_OPEN  = "assets/images/padlock_open.avif";

/* Documents */
const String PP_PATH = "assets/documents/privacy_policy.md";
const String TAC_PATH = "assets/documents/terms_and_conditions.md";

// const Color originalConfirmButtonColor = Color.fromARGB(156, 95, 103, 97);
Color originalConfirmButtonColor = Colors.blueGrey.withAlpha(20);
const freqLockWidth = 52;


