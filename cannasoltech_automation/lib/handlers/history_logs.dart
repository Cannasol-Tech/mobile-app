
import 'package:cannasoltech_automation/dialogs/log_dialog.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../objects/database_model.dart';
import 'package:cannasoltech_automation/shared/methods.dart';
import '../shared/types.dart';

import 'package:intl/intl.dart';

import 'alarm_logs.dart';




class HistoryLog {

  late int index;
  late String startUser;
  late AlarmLogsModel alarmLog;
  late double avgFlowRate;
  late double avgTemp;
  late double numPasses;
  late int runHours;
  late int runMinutes;
  late int runSeconds;
  late String? endTime;
  late String? startTime;

  HistoryLogDialog get dialog => HistoryLogDialog(historyLog: this);

  int get startSeconds => startTime != null ? DateFormat("MM/dd/yyyy HH:mm:ss").parse(startTime!).millisecondsSinceEpoch ~/ 1000 : 0;
  int get endSeconds => endTime != null ? DateFormat("MM/dd/yyyy HH:mm:ss").parse(endTime!).millisecondsSinceEpoch ~/ 1000 : 0;

  HistoryLog({
    required this.index,
    required this.startUser,
    required this.alarmLog,
    required this.avgFlowRate,
    required this.avgTemp,
    required this.numPasses,
    required this.runHours,
    required this.runMinutes,
    required this.runSeconds,
    required this.endTime,
    required this.startTime
  });

  factory HistoryLog.fromMap(Map<dynamic, dynamic> map, int index) {
    final startEpoch = map["start_time"] ?? 0;
    final endEpoch = map["end_time"] ?? 0;

    return HistoryLog(
      index: index,
      alarmLog: AlarmLogsModel.fromMap(map['alarm_logs'] ?? {}),
      startTime: _epochToString(startEpoch),
      endTime: _epochToString(endEpoch),
      startUser: map["start_user"] ?? "N/A",
      avgFlowRate: map["avg_flow_rate"].toDouble() ?? 0.0,
      avgTemp: map["avg_temp"].toDouble() ?? 0.0,
      numPasses: map["num_passes"].toDouble() ?? 0.0,
      runHours: map["run_hours"] ?? 0,
      runMinutes: map["run_minutes"] ?? 0,
      runSeconds: map["run_seconds"] ?? 0,
    );
  }

  String toMarkdown() {
    final buffer = StringBuffer();

    // Header
    // buffer.writeln('# System Log #${index + 1}\n');
    // buffer.writeln('');

    // Operator Information
    buffer.writeln("---");
    buffer.writeln('**Operator:** $startUser\n\n');

    // Time Information
    buffer.writeln('**Start Time:** ${startTime ?? "N/A"}\n');
    buffer.writeln('**End Time:** ${endTime ?? "N/A"}\n');
    buffer.writeln('**Run Duration:** ${_formatDuration()}\n');
    buffer.writeln('');

    // Performance Metrics
    buffer.writeln("\n");
    buffer.writeln('**Average Flow Rate:** ${avgFlowRate.toStringAsFixed(2)} L/min \n');
    buffer.writeln('**Average Temperature:** ${avgTemp.toStringAsFixed(2)}°C \n');
    buffer.writeln('**Number of Passes:** ${numPasses.toStringAsFixed(2)} \n');
    buffer.writeln("---");
    buffer.writeln('');

    // Alarm Logs
    // buffer.writeln('Alarm Logs \n');
    buffer.writeln(alarmLog.toMarkdown());
    buffer.writeln("---");

    return buffer.toString();
  }

  String _formatDuration() {
    String hours = runHours.toString().padLeft(2, '0');
    String minutes = runMinutes.toString().padLeft(2, '0');
    String seconds = runSeconds.toString().padLeft(2, '0');
    return '$hours h $minutes m $seconds s';
  }

  static String _epochToString(int epochSeconds) {
    if (epochSeconds == 0) {
      return "N/A";
    }
    final dateTime = DateTime.fromMillisecondsSinceEpoch(epochSeconds * 1000);
    return DateFormat("MM/dd/yyyy HH:mm:ss").format(dateTime);
  }

  Text get displayText => Text(
    "System Log #${index+1} - Operator: $startUser \n    Start: $startTime \n    End: $endTime",
    style: TextStyle(
      color: Colors.blue.shade800,
      fontSize: 16,
      fontWeight: FontWeight.w500,
    ),
  );

  showLogDialog(BuildContext context) {
    dialog.show(context);
  }
}

class HistoryLogsModel extends DatabaseModel {
  List<HistoryLog> logs;
  HistoryLogsModel({required this.logs});

  factory HistoryLogsModel.fromDatabase(DataSnapshot snap) {
    if (snap.value == null) return HistoryLogsModel(logs: []);
    DbMap data = getDbMap(snap);
    // Build list from raw map
    List<HistoryLog> historyLogs = [
      for (var (idx, entry) in data.entries.indexed) 
        HistoryLog.fromMap(entry.value, idx)
    ]..sort((a, b) => (b.startTime ?? "").compareTo(a.startTime ?? ""));

    return HistoryLogsModel(logs: historyLogs);
  }
}