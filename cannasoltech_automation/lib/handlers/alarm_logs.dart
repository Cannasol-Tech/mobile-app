
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../objects/database_model.dart';
import '../objects/logger.dart';
import 'package:cannasoltech_automation/shared/methods.dart';
import '../shared/types.dart';

import 'package:intl/intl.dart';

class AlarmLog {
  late String type;
  late String? startTime;
  late String? clearedTime;

  int get startSeconds => startTime != null ? DateFormat("MM/dd/yyyy HH:mm:ss").parse(startTime!).millisecondsSinceEpoch ~/ 1000 : 0;
  int get clearedSeconds => clearedTime != null ? DateFormat("MM/dd/yyyy HH:mm:ss").parse(clearedTime!).millisecondsSinceEpoch ~/ 1000 : 0;

  AlarmLog({
    required this.type,
    required this.startTime,
    required this.clearedTime,
  });

  /// Creates an [AlarmLog] from integer epoch times.
  factory AlarmLog.fromMap(Map<dynamic, dynamic> map) {
    final startEpoch = map["start_time"] ?? 0;
    final clearedEpoch = map["cleared_time"] ?? 0;

    return AlarmLog(
      type: map["type"] ?? "Unknown",
      startTime: _epochToString(startEpoch),
      clearedTime: _epochToString(clearedEpoch),
    );
  }

  /// Utility method that converts "seconds since epoch" into a readable string.
  static String _epochToString(int epochSeconds) {
    if (epochSeconds == 0) {
      return "N/A";
    }
    final dateTime = DateTime.fromMillisecondsSinceEpoch(epochSeconds * 1000);
    return DateFormat("MM/dd/yyyy HH:mm:ss").format(dateTime);
  }

  Text get displayText => Text(
    "$type \n    Start: $startTime \n    Cleared: $clearedTime",
    style: TextStyle(
      color: clearedTime == "N/A" ? Colors.red : Colors.green,
      fontSize: 16,
      fontWeight: FontWeight.w500,
    ),
  );
  
}

class AlarmLogsModel extends DatabaseModel {
  List<AlarmLog> logs;
  AlarmLogsModel({required this.logs});

  factory AlarmLogsModel.fromDatabase(DataSnapshot snap) {
    if (snap.value == null) return AlarmLogsModel(logs: []);
    DbMap data = getDbMap(snap);

    // Build list from raw map
    List<AlarmLog> alarmLogs = [
      for (var entry in data.entries) 
        AlarmLog.fromMap(entry.value)
    ]..sort((a, b) => (b.startTime ?? "").compareTo(a.startTime ?? ""));

    log.info("DEBUG ALARMLOGS -> entries = data.entries");
    return AlarmLogsModel(logs: alarmLogs);
  }

  factory AlarmLogsModel.fromMap(Map<dynamic, dynamic> data) {
    // Build list from raw map
    List<AlarmLog> alarmLogs = [
      for (var entry in data.entries) 
        AlarmLog.fromMap(entry.value)
    ]..sort((a, b) => (b.startTime ?? "").compareTo(a.startTime ?? ""));

    log.info("DEBUG ALARMLOGS -> entries = data.entries");
    return AlarmLogsModel(logs: alarmLogs);
  }
  
  
  getAlarmStartSeconds(alarmName){
    for (var log in logs) {
      String alarmNamePrefix = alarmName.split("_")[0].toString().toCapital();
      if (log.type.contains(alarmNamePrefix) && log.clearedTime == "N/A") {
        return log.startSeconds;
      }
    }
    return 0;
  }

  String toMarkdown() {
    if (logs.isEmpty) {
      return 'No alarms recorded.';
    }

    final buffer = StringBuffer();
    for (int i = 0; i < logs.length; i++) {
      buffer.writeln('**Alarm #${i + 1}:** *${logs[i].type}*\n');
      buffer.writeln('- **Start Time**: ${logs[i].startTime?.replaceAll('-', '/')}\n');
      buffer.writeln('- **Cleared Time**: ${logs[i].startTime?.replaceAll('-', '/')}\n');

    }
    return buffer.toString();
  }
}