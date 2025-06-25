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


class Device{
  Device({
    required this.status, required this.id, required this.name, required this.type, required this.native
  });
  String status;
  String id;
  String name;
  String type;
  Map<String, dynamic> native;

  String _historyDownloadUrl = "";

  late dynamic authToken;

  late DbMap data;
  late StateHandler state;
  late AlarmsModel alarms;
  late WarningsModel warnings;
  late DatabaseReference dbRef;
  late AlarmLogsModel alarmLogs;
  late HistoryLogsModel history;


  late List<SaveSlot> saveSlots;
  late ConfigHandler config;
  CurrentRunModel? currentRun;

  factory Device.noDevice() {
    return Device(
      status: "None",
      id: "None",
      name: "None",
      type: "None",
      native: {"None": "None"}
    );
  }

  factory Device.fromDatabase(DataSnapshot snap){
      final data = getDbMap(snap);
      
      if (!data.containsKey('Info')){
        return Device.noDevice();
      }

      Map deviceInfo = data["Info"] as Map;
      final Map<String, dynamic> native = data;
      final String id = deviceInfo["id"].toString();
      final String name = deviceInfo["name"].toString();
      final String type = deviceInfo["type"].toString();
      final String status = deviceInfo["status"].toString();

      Device newDevice = Device(status: status, id: id,  name: name, type: type, native: native);

      if (snap.child('SaveSlots').exists){
        newDevice.saveSlots = List.generate(5, (idx) => SaveSlot.fromDatabase(snap: snap.child('SaveSlots/slot_${idx+1}'), idx: idx+1, device: newDevice));
      }

      newDevice.currentRun = CurrentRunModel.fromDatabase(snap.child('CurrentRun'));
      newDevice.alarms = AlarmsModel.fromDatabase(snap.child('Alarms'));
      newDevice.alarmLogs = AlarmLogsModel.fromDatabase(snap.child('AlarmLogs'));
      newDevice.state = StateHandler.fromDatabase(snap.child('State'), newDevice);
      newDevice.config = ConfigHandler.fromDatabase(snap.child('Config'), newDevice);
      newDevice.history = HistoryLogsModel.fromDatabase(snap.child('History'));
      newDevice.dbRef = snap.ref;
      newDevice.initDownloadUrl();
      return newDevice;
  }

  bool isOnline() {
    if (status == "ONLINE") {
      return true;
    }
    else {
      return false;
    }
  }

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


  void initDownloadUrl() {
    dbRef.child('CloudLogging').child('Spreadsheet').child('download_url').onValue.listen((event) => 
      event.snapshot.exists 
      ? _historyDownloadUrl = event.snapshot.value.toString()
      : null
    );
  }

  void clearDeviceLogHistory(BuildContext context) {
    showDialog(context: context, 
      builder: (context) {
        return AlertDialog(
          title: const Text("Clear Device History"),
          content: const Text("Are you sure you want to clear the device history?"),
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
      }
    );
  }
}
