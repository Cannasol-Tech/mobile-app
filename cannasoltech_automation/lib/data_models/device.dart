/**
 * @file device.dart
 * @author Stephen Boyett
 * @date 2025-09-06
 * @brief Device data model representing a Cannasol Technologies automation device.
 * @details Defines the Device class which encapsulates all device-related data,
 *          state management, configuration, alarms, and file operations including
 *          history downloads and device control functionality.
 * @version 1.0
 * @since 1.0
 */

import 'package:cannasoltech_automation/main.dart';
import 'package:cannasoltech_automation/shared/banners.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cannasoltech_automation/handlers/alarm_handler.dart';
import 'package:cannasoltech_automation/handlers/config_handler.dart';
import 'package:cannasoltech_automation/handlers/state_handler.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

import '../handlers/alarm_logs.dart';
import '../handlers/current_run.dart';
import '../handlers/history_logs.dart';
import '../objects/save_slot.dart';
import '../shared/methods.dart';
import '../shared/types.dart';

/**
 * @brief Represents a Cannasol Technologies automation device.
 * @details Encapsulates all device-related data including status, configuration,
 *          alarms, state management, and provides methods for device control
 *          and data operations such as history downloads.
 * @since 1.0
 */
class Device {
  /**
   * @brief Creates a Device instance with required parameters.
   * @param status Current operational status of the device
   * @param id Unique identifier for the device
   * @param name Human-readable name of the device
   * @param type Device type classification
   * @param native Raw device data from the database
   */
  Device(
      {required this.status,
      required this.id,
      required this.name,
      required this.type,
      required this.native});

  /// Current operational status of the device (e.g., "ONLINE", "OFFLINE")
  String status;

  /// Unique identifier for the device
  String id;

  /// Human-readable name of the device
  String name;

  /// Device type classification
  String type;

  /// Raw device data from the database
  Map<String, dynamic> native;

  /// Private URL for downloading device history data
  String _historyDownloadUrl = "";

  /// Authentication token for device operations
  late dynamic authToken;

  /// Database map containing device data
  late DbMap data;

  /// Handler for device state management
  late StateHandler state;

  /// Model for managing device alarms
  late AlarmsModel alarms;

  /// Model for managing device warnings
  late WarningsModel warnings;

  /// Firebase database reference for this device
  late DatabaseReference dbRef;

  /// Model for managing alarm logs
  late AlarmLogsModel alarmLogs;

  /// Model for managing history logs
  late HistoryLogsModel history;

  /// List of save slots for device configurations
  late List<SaveSlot> saveSlots;

  /// Handler for device configuration management
  late ConfigHandler config;

  /// Current run model, nullable if no run is active
  CurrentRunModel? currentRun;

  /**
   * @brief Factory constructor for creating a placeholder "no device" instance.
   * @details Creates a Device instance with default "None" values for all fields.
   *          Used when no actual device is selected or available.
   * @return Device instance with placeholder values
   * @since 1.0
   */
  factory Device.noDevice() {
    return Device(
        status: "None",
        id: "None",
        name: "None",
        type: "None",
        native: {"None": "None"});
  }

  /**
   * @brief Factory constructor for creating a Device from Firebase database snapshot.
   * @details Parses Firebase database snapshot to create a fully initialized Device
   *          instance with all handlers, models, and configuration loaded.
   * @param snap Firebase database snapshot containing device data
   * @return Device instance populated from database data, or noDevice() if invalid
   * @since 1.0
   */
  factory Device.fromDatabase(DataSnapshot snap) {
    final data = getDbMap(snap);

    if (!data.containsKey('Info')) {
      return Device.noDevice();
    }

    Map deviceInfo = data["Info"] as Map;
    final Map<String, dynamic> native = data;
    final String id = deviceInfo["id"].toString();
    final String name = deviceInfo["name"].toString();
    final String type = deviceInfo["type"].toString();
    final String status = deviceInfo["status"].toString();

    Device newDevice =
        Device(status: status, id: id, name: name, type: type, native: native);

    if (snap.child('SaveSlots').exists) {
      newDevice.saveSlots = List.generate(
          5,
          (idx) => SaveSlot.fromDatabase(
              snap: snap.child('SaveSlots/slot_${idx + 1}'),
              idx: idx + 1,
              device: newDevice));
    }

    newDevice.currentRun =
        CurrentRunModel.fromDatabase(snap.child('CurrentRun'));
    newDevice.alarms = AlarmsModel.fromDatabase(snap.child('Alarms'));
    newDevice.alarmLogs = AlarmLogsModel.fromDatabase(snap.child('AlarmLogs'));
    newDevice.state = StateHandler.fromDatabase(snap.child('State'), newDevice);
    newDevice.config =
        ConfigHandler.fromDatabase(snap.child('Config'), newDevice);
    newDevice.history = HistoryLogsModel.fromDatabase(snap.child('History'));
    newDevice.dbRef = snap.ref;
    newDevice.initDownloadUrl();
    return newDevice;
  }

  /**
   * @brief Checks if the device is currently online.
   * @details Determines device online status based on the status field.
   * @return true if device status is "ONLINE", false otherwise
   * @since 1.0
   */
  bool isOnline() {
    if (status == "ONLINE") {
      return true;
    } else {
      return false;
    }
  }

  /**
   * @brief Requests storage permission for file downloads.
   * @details Handles platform-specific storage permission requests for Android and iOS.
   *          Shows error banner if permission is denied.
   * @return Future<bool> true if permission granted, false otherwise
   * @throws Exception if permission request fails
   * @since 1.0
   */
  Future<bool> requestStoragePermission() async {
    if (Platform.isAndroid) {
      if (await Permission.storage.request().isGranted) {
        return true;
      }

      if (await Permission.manageExternalStorage.request().isGranted) {
        return true;
      }

      showBanner(unableToDownloadBanner("Permission denied."));
      return false;
    } else if (Platform.isIOS) {
      return true; // Handle iOS permissions if necessary
    }

    return false;
  }

  /**
   * @brief Downloads device history data to local storage.
   * @details Requests storage permission, determines platform-specific download directory,
   *          and downloads device history as CSV file using Dio HTTP client.
   *          Shows progress banners during download and completion/error status.
   * @throws Exception if download fails or storage access is denied
   * @since 1.0
   */
  Future<void> downloadDeviceHistory() async {
    bool hasPermission = await requestStoragePermission();
    if (!hasPermission) {
      return;
    }

    try {
      Directory? directory;
      if (Platform.isAndroid) {
        directory = Directory('/storage/emulated/0/Download');
      } else if (Platform.isIOS) {
        directory = await getApplicationDocumentsDirectory();
      }

      if (directory == null) {
        showBanner(unableToDownloadBanner("Unable to access storage."));
        return;
      }

      String fileName = 'device_${name}_history.csv';
      String filePath = '${directory.path}/$fileName';

      // Initialize Dio for downloading
      Dio dio = Dio();

      await dio.download(
        _historyDownloadUrl,
        filePath,
        onReceiveProgress: (received, total) {
          if (total != -1 && received < total) {
            showBanner(downloadingDeviceHistoryBanner());
          } else {
            hideCurrentBanner();
          }
        },
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
          validateStatus: (status) {
            return status! < 500;
          },
        ),
      );
      showBanner(downloadCompleteBanner());
    } catch (error) {
      showBanner(downloadFailedBanner(error));
    }
  }

  /**
   * @brief Initializes the download URL listener for device history.
   * @details Sets up a Firebase database listener to monitor changes to the
   *          download URL for device history spreadsheet data.
   * @since 1.0
   */
  void initDownloadUrl() {
    dbRef
        .child('CloudLogging')
        .child('Spreadsheet')
        .child('download_url')
        .onValue
        .listen((event) => event.snapshot.exists
            ? _historyDownloadUrl = event.snapshot.value.toString()
            : null);
  }

  /**
   * @brief Shows confirmation dialog and clears device LOG history.
   * @details Displays an alert dialog asking for user confirmation before
   *          clearing all device history data from Firebase database.
   * @param context Build context for showing the dialog
   * @since 1.0
   */
  void clearDeviceLogHistory(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Clear Device History"),
            content: const Text(
                "Are you sure you want to clear the device history?"),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  dbRef.child('History').remove();
                  dbRef.child('History').set([]);
                  Navigator.of(navigatorKey.currentContext!).pop();
                },
                child: const Text("Yes"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(navigatorKey.currentContext!).pop();
                },
                child: const Text("No"),
              ),
            ],
          );
        });
  }
}
