import 'package:flutter/material.dart';
import 'package:cannasoltech_automation/shared/constants.dart';
import 'package:cannasoltech_automation/data_models/device.dart';

class StatusMessage {
  
  String text = "Unknown State";
  Color color = Colors.grey;

  StatusMessage.fromDevice(Device device){
  final Map<int, String> stateToStatusMap = {
      RESET : "Resetting",
      INIT  : "System Ready",
      WARM_UP : "System Warming up...",
      RUNNING : "System Running",
      ALARM : device.state.alarmsCleared ? "Alarms Cleared!" : "System Alarm!",
      FINISHED : "Process Complete!",
      COOL_DOWN : "Cooling down..."
    };
  final Map<int, Color> stateToStatusColorMap = {
      RESET : Colors.grey,
      INIT : Colors.green,
      WARM_UP : Colors.red,
      RUNNING : Colors.green,
      ALARM : device.state.alarmsCleared ? const Color.fromARGB(255, 221, 218, 218) :Colors.red,
      FINISHED : Colors.green,
      COOL_DOWN : Colors.blue,
    };

    text = device.isOnline() ? (stateToStatusMap[device.state.state] ?? "Unknown State") : "System Offline";
    color = device.isOnline() ? (stateToStatusColorMap[device.state.state] ?? Colors.grey) : Colors.red;


  }

}