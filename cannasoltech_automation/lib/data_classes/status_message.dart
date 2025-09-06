/**
 * @file status_message.dart
 * @author Stephen Boyett
 * @date 2025-09-06
 * @brief Device status message generation and formatting.
 * @details Provides status message generation with appropriate text and colors
 *          based on device state, online status, and alarm conditions.
 * @version 1.0
 * @since 1.0
 */

import 'package:flutter/material.dart';
import 'package:cannasoltech_automation/shared/constants.dart';
import 'package:cannasoltech_automation/data_models/device.dart';

/**
 * @brief Status message class for device state display.
 * @details Generates appropriate status text and colors based on device state,
 *          online status, and alarm conditions for UI display.
 * @since 1.0
 */
class StatusMessage {

  /// Status message text
  String text = "Unknown State";

  /// Status message color for UI display
  Color color = Colors.grey;

  /**
   * @brief Creates a StatusMessage from device state.
   * @details Analyzes device state and generates appropriate status message
   *          with corresponding color based on current operational state.
   * @param device Device instance to generate status message from
   * @since 1.0
   */
  StatusMessage.fromDevice(Device device){
  /// Map of device states to human-readable status messages
  final Map<int, String> stateToStatusMap = {
      RESET : "Resetting",
      INIT  : "System Ready",
      WARM_UP : "System Warming up...",
      RUNNING : "System Running",
      ALARM : device.state.alarmsCleared ? "Alarms Cleared!" : "System Alarm!",
      FINISHED : "Process Complete!",
      COOL_DOWN : "Cooling down..."
    };

  /// Map of device states to corresponding UI colors
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