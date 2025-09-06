
/**
 * @file alarm_logs.dart
 * @author Stephen Boyett
 * @date 2025-09-06
 * @brief Alarm logging and history management system.
 * @details Provides alarm log tracking, history management, and alarm event
 *          persistence with timestamp handling and Firebase integration.
 * @version 1.0
 * @since 1.0
 */

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../objects/database_model.dart';
import '../objects/logger.dart';
import 'package:cannasoltech_automation/shared/methods.dart';
import '../shared/types.dart';

import 'package:intl/intl.dart';

/**
 * @brief Individual alarm log entry with timing information.
 * @details Represents a single alarm event with start time, clear time,
 *          and type information, including timestamp conversion utilities.
 * @since 1.0
 */
class AlarmLog {
  /// Type of alarm (e.g., "flow", "temperature", "pressure")
  late String type;

  /// Formatted start time string (MM/dd/yyyy HH:mm:ss)
  late String? startTime;

  /// Formatted cleared time string (MM/dd/yyyy HH:mm:ss)
  late String? clearedTime;

  /// Getter for start time in seconds since epoch
  int get startSeconds => startTime != null ? DateFormat("MM/dd/yyyy HH:mm:ss").parse(startTime!).millisecondsSinceEpoch ~/ 1000 : 0;

  /// Getter for cleared time in seconds since epoch
  int get clearedSeconds => clearedTime != null ? DateFormat("MM/dd/yyyy HH:mm:ss").parse(clearedTime!).millisecondsSinceEpoch ~/ 1000 : 0;

  /**
   * @brief Creates an AlarmLog with specified timing and type information.
   * @param type Type of alarm
   * @param startTime Formatted start time string
   * @param clearedTime Formatted cleared time string (nullable)
   */
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