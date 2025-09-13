// @file system_data_provider.dart
// @author Stephen Boyett
// @date 2025-09-06
// @brief System data providers for st ate management in the Cannasol Technologies app.
// @details Contains provider classes for managing system indices, device data,
//          user authentication state, and application-wide state management
//          using Flutter's Provider pattern and ChangeNotifier.
// @version 1.0
// @since 1.0

// ignore_for_file: avoid_print
import 'dart:async';
import '../objects/logger.dart';
import '../data_models/device.dart';
import 'package:flutter/material.dart';
import '../handlers/active_device.dart';
import '../handlers/registered_devices.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cannasoltech_automation/pages/log_page.dart';
import 'package:cannasoltech_automation/shared/constants.dart';
import 'package:cannasoltech_automation/data_models/data.dart';
import 'package:cannasoltech_automation/pages/alarm_page.dart';
import 'package:cannasoltech_automation/pages/config_page.dart';
import 'package:cannasoltech_automation/handlers/alarm_logs.dart';
import 'package:cannasoltech_automation/pages/home/run_page.dart';
import 'package:cannasoltech_automation/pages/home/end_page.dart';
import 'package:cannasoltech_automation/handlers/user_handler.dart';
import 'package:cannasoltech_automation/pages/home/start_page.dart';
import 'package:cannasoltech_automation/controllers/text_controllers.dart';
import 'package:cannasoltech_automation/controllers/toggle_controllers.dart';

// @brief System index provider for managing current system component selection.
// @details Extends ValueNotifier to provide reactive state management for
//          system component indices with bounds checking and increment/decrement operations.
// @since 1.0
class SystemIdx extends ValueNotifier<int> {
  // @brief Creates a SystemIdx instance with initial value of 0.
  SystemIdx() : super(0);

  /// Minimum allowed index value
  final int minValue = 0;

  /// Maximum allowed index value
  final int maxValue = 2;

  /// @brief Increments the current index value if within bounds.
  /// @details Increases the value by 1 if it's less than maxValue.
  /// @since 1.0
  void increment() {
    if (value < maxValue) {
      value++;
    }
  }

  /// @brief Decrements the current index value if within bounds.
  /// @details Decreases the value by 1 if it's greater than minValue.
  /// @since 1.0
  void decrement() {
    if (value > minValue) {
      value--;
    }
  }

  /// @brief Sets the index to a specific value.
  /// @param idx The index value to set
  /// @since 1.0
  void set(int idx) {
    value = idx;
    print("DEBUG -> SystemIdx set to $idx");
  }

  /// @brief Initializes the system index provider.
  /// @details Resets the value to 0 and logs initialization.
  /// @since 1.0
  void init() {
    print("DEBUG -> SystemIndex provider initialized!");
    value = 0;
  }
}

typedef ActiveDevice = Device?;

// class DatabaseService {
//   /* Keeps track of the active devices */

//   final DatabaseReference _devicesReference = FirebaseDatabase.instance.ref('/Devices');
//   FirebaseAuth auth = FirebaseAuth.instance;
//   String selectedDevice = 'None';

//   Stream<ActiveDevice> streamActiveDevice(String selectedDevice) async* {
//     yield*
//     _devicesReference.child(selectedDevice)
//     .onValue.map((event) {
//       if (event.snapshot.exists){
//         return Device.fromDatabase(event.snapshot);
//       }
//       return null;
//     });
//   }
// }

class AlarmTimer {
  Duration? duration;
  Timer? latch;
  bool started = false;
  Duration? alarmStartTime;

  void start() {
    if (!started) {
      started = true;
      duration = const Duration(seconds: 0);

      latch = Timer.periodic(const Duration(seconds: 1), (timer) {
        int runSeconds = (DateTime.now().millisecondsSinceEpoch ~/ 1000) -
            alarmStartTime!.inSeconds;
        duration = Duration(seconds: runSeconds);
      });
    }
  }

  void stop() {
    if (started) {
      started = false;
      latch?.cancel();
      latch = null;
    }
  }
}

class TimerHandler {
  dynamic updateDataTimer;
  double updateSeconds = 0.25;
  AlarmTimer flowAlarmTimer = AlarmTimer();
  AlarmTimer tempAlarmTimer = AlarmTimer();
  AlarmTimer pressureAlarmTimer = AlarmTimer();
  AlarmTimer freqLockAlarmTimer = AlarmTimer();
  AlarmTimer overloadAlarmTimer = AlarmTimer();

  late Map<String, dynamic> alarmTimers;

  TimerHandler() {
    alarmTimers = {
      "flow_alarm": flowAlarmTimer,
      "temp_alarm": tempAlarmTimer,
      "pressure_alarm": pressureAlarmTimer,
      "freq_lock_alarm": freqLockAlarmTimer,
      "overload_alarm": overloadAlarmTimer
    };
  }
}

class SystemDataModel extends ChangeNotifier {
  // Internal private state of the system

  Device? _activeDevice;
  Device? get activeDevice => _activeDevice;

  Map<int, dynamic> currentRunPageMap = {
    RESET: const StartPage(),
    INIT: const StartPage(),
    WARM_UP: const RunPage(startIndex: 0),
    RUNNING: const RunPage(startIndex: 0),
    ALARM: const RunPage(startIndex: 0),
    FINISHED: const EndPage(),
    COOL_DOWN: const RunPage(startIndex: 0),
  };

  Size display(BuildContext ctx) => MediaQuery.of(ctx).size;
  double screenHeight(BuildContext ctx) => MediaQuery.of(ctx).size.height;
  double screenWidth(BuildContext ctx) => MediaQuery.of(ctx).size.width;

  int _almCount = 0;
  dynamic authListener;
  dynamic devicesListener;
  dynamic updatingData = false;

  final ActiveDeviceHandler _activeDeviceHandler =
      ActiveDeviceHandler.uninitialized();
  Map<String, String> get registeredDeviceStatus =>
      _registeredDeviceHandler.registeredDeviceStatus;
  final RegisteredDeviceHandler _registeredDeviceHandler =
      RegisteredDeviceHandler.uninitialized();
  Devices get devices => _devices;
  final Devices _devices = Devices.initialize();

  final String _runPageTitle = RUN_TITLE;
  String get runPageTitle => _runPageTitle;

  int? _activeDeviceState = INIT;
  int get activeDeviceState => _activeDeviceState ?? INIT;

  Widget _currentRunPage = const StartPage();
  Widget get currentRunPage => _currentRunPage;

  TextControllers textControllers = TextControllers();
  ToggleControllers toggleControllers = ToggleControllers();

  bool _isPasswordVisible = false;
  bool get isPasswordVisible => _isPasswordVisible;

  bool _alarmFlash = false;
  bool get alarmFlash => _alarmFlash;

  FirebaseAuth auth = FirebaseAuth.instance;
  UserHandler get userHandler => _userHandler;
  UserHandler _userHandler = UserHandler.uninitialized();

  Stream authStateChanges = FirebaseAuth.instance.authStateChanges();

  List<dynamic> bottomNavPages = [];

  final TimerHandler _timers = TimerHandler();

  int TaCCount = 0;
  bool _needsAcceptTaC = false;
  bool get needsAcceptTaC => _needsAcceptTaC;

  void init() {
    _almCount = 0;
    setBottomNavPages();
    LOG.info("DEBUG -> SystemDataModel initialized");
    startUpdateDataTimer();
    authListener = authStateChanges.listen((event) {
      if (event == null) {
        _userHandler = UserHandler.uninitialized();
      }
    });
  }

  @override
  dispose() {
    LOG.info("DEBUG -> SystemDataModel initialized");
    LOG.info("DEBUG -> SystemDataModel disposed");
    stopUpdateDataTimer();
    // _alarmHandler.uninitialize();
    _activeDeviceHandler.uninitialize();
    _registeredDeviceHandler.uninitialize();
    authListener.detach();
    devicesListener.detach();
    super.dispose();
  }

  void startUpdateDataTimer() {
    LOG.info("DEBUG -> Starting update data timer");
    if (_timers.updateDataTimer == null) {
      _timers.updateDataTimer = Timer.periodic(
          Duration(milliseconds: (_timers.updateSeconds * 1000).toInt()),
          ((Timer t) {
        updateData();
      }));
      updatingData = true;
    } else {
      LOG.info("DEBUG -> Starting update data timer");
      _timers.updateDataTimer = null;
    }
  }

  void stopUpdateDataTimer() {
    if (_timers.updateDataTimer != null) {
      updatingData = false;
      _timers.updateDataTimer.cancel();
      _timers.updateDataTimer = null;
    }
    notifyListeners();
  }

  void setBottomNavPages() {
    bottomNavPages = [
      const StartPage(),
      const ConfigPage(),
      const LogPage(),
      const AlarmPage()
    ];
  }

  void togglePWVis() {
    if (_isPasswordVisible == true) {
      _isPasswordVisible == false;
    } else {
      _isPasswordVisible = true;
    }
    return;
  }

  void setSelectedDeviceFromName(String deviceName) {
    String deviceId = devices.nameIdMap[deviceName] ??= 'None';
    if (_userHandler.watchedDevices.contains(deviceId) || deviceId == 'None') {
      _userHandler.setSelectedDeviceId(deviceId);
      _activeDeviceHandler.update(deviceId);
      notifyListeners();
    }
    return;
  }

  void updateNeedsAcceptTaC() {
    if (userHandler.doesAcceptTaC == false) {
      TaCCount += 1;
    } else {
      TaCCount = 0;
      _needsAcceptTaC = false;
    }
    if (TaCCount == 10 && _needsAcceptTaC == false) {
      _needsAcceptTaC = true;
    }
  }

  void updateCurrentRunPage() {
    /* Updates app to reflect the current system state */
    if (_activeDevice != null && _activeDevice?.name != 'None') {
      _currentRunPage = currentRunPageMap[_activeDevice?.state.state];
      LOG.info("DEBUG PAGE -> _currentRunPage = $_currentRunPage");
    } else {
      _currentRunPage = currentRunPageMap[RESET];
    }
    bottomNavPages[0] = _currentRunPage;
  }

  void updateAlarmFlash() {
    if (_activeDevice != null) {
      if (_almCount < 2) {
        _almCount += 1;
      } else {
        _almCount = 0;
        if (_activeDevice!.alarms.alarmActive) {
          _alarmFlash = !_alarmFlash;
        } else {
          _alarmFlash = false;
        }
      }
    }
  }

  void updateDataControllers(dynamic newDeviceData) {
    if (newDeviceData != null && newDeviceData.name != 'None') {
      if (_activeDevice == null || _activeDevice?.name == "None") {
        textControllers.init(newDeviceData);
        toggleControllers.init(newDeviceData);
      } else if (_activeDevice?.status == "OFFLINE") {
        textControllers.init(newDeviceData);
        toggleControllers.init(newDeviceData);
      } else if (_activeDevice?.status == "ONLINE" &&
          newDeviceData.status == "OFFLINE") {
        textControllers.clear();
        toggleControllers.clear();
      } else {
        textControllers.update(newDeviceData, _activeDevice);
        toggleControllers.update(newDeviceData, _activeDevice);
      }
    } else {
      // Clear text controllers because no device
      _activeDevice = null;
      textControllers.clear();
      toggleControllers.clear();
    }
  }

  void updateAlarmTimers() {
    /*
    List<String> alarmNames = [
    'flow_alarm', 
    'temp_alarm', 
    'pressure_alarm', 
    'freq_lock_alarm', 
    'overload_alarm'
  ];
  */
    if (_activeDevice == null) {
      return;
    }
    List<String> activeAlarms = _activeDevice!.alarms.activeAlarms;
    List<String> idleAlarms = _activeDevice!.alarms.idleAlarms;

    dynamic alarmTimers = _timers.alarmTimers;
    for (var alarmName in activeAlarms) {
      AlarmTimer alarmTimer = alarmTimers[alarmName];
      if (alarmTimer.started == false) {
        alarmTimer.start();
      }
      AlarmLogsModel alarmLogs = _activeDevice!.alarmLogs;
      alarmTimer.alarmStartTime =
          Duration(seconds: alarmLogs.getAlarmStartSeconds(alarmName));
    }
    for (var alarm in idleAlarms) {
      AlarmTimer alarmTimer = alarmTimers[alarm];
      if (alarmTimer.started == true) {
        alarmTimer.stop();
      }
    }
    _activeDevice!.alarms.flowAlarmTime =
        _timers.alarmTimers["flow_alarm"].duration;
    _activeDevice!.alarms.tempAlarmTime =
        _timers.alarmTimers["temp_alarm"].duration;
    _activeDevice!.alarms.pressureAlarmTime =
        _timers.alarmTimers["pressure_alarm"].duration;
    _activeDevice!.alarms.freqLockAlarmTime =
        _timers.alarmTimers["freq_lock_alarm"].duration;
    _activeDevice!.alarms.overloadAlarmTime =
        _timers.alarmTimers["overload_alarm"].duration;
  }

  void updateData() {
    LOG.info("Updating System Data");
    if (userHandler.initialized && _devices.initialized) {
      _activeDeviceHandler.update(userHandler.selectedDevice);
      updateDataControllers(_activeDeviceHandler.device);
      _activeDevice = _activeDeviceHandler.device;
      _activeDeviceState = _activeDevice?.state.state;
      _registeredDeviceHandler.update(userHandler.watchedDevices);
      updateCurrentRunPage();
      updateAlarmFlash();
      updateAlarmTimers();
      updateNeedsAcceptTaC();
    } else {
      if (userHandler.initialized == false) {
        userHandler.initialize();
      }
      if (_devices.initialized == false) {
        _devices.initialize();
      }
    }
    // LOG.info("DEBUG -> Active Device = $activeDevice");
    notifyListeners();
  }
}
