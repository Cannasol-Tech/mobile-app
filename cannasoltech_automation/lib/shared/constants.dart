import 'package:flutter/material.dart';
import 'app_constants.dart';

// Re-export the new constants for backward compatibility
// TODO: Update all files to import from app_constants.dart directly

// Device state constants (backward compatibility)
const int RESET = 100;
const int INIT = 0;
const int WARM_UP = 1;
const int RUNNING = 2;
const int ALARM = 3;
const int FINISHED = 4;
const int COOL_DOWN = 5;

// Display element constants (backward compatibility)  
const int NO_ELEMENT = -1;
const int SHOW_SONICATOR = 0;
const int SHOW_PUMP = 1;
const int SHOW_TANK = 2;

// Page titles (backward compatibility)
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


