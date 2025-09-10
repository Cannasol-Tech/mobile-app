
/**
 * @file methods.dart
 * @author Stephen Boyett
 * @date 2025-09-06
 * @brief Shared utility methods and extensions for the application.
 * @details Provides common utility functions for string formatting, number display,
 *          error handling, and UI helper methods used throughout the application.
 * @version 1.0
 * @since 1.0
 */

// ignore_for_file: unnecessary_this

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../data_models/device.dart';

/// Type alias for active device reference
typedef ActiveDevice = Device;

/**
 * @brief Formats a double value with specified decimal places and optional units.
 * @details Converts a double to a string with fixed decimal places and appends units.
 * @param d The double value to format
 * @param decimalPlaces Number of decimal places to display
 * @param units Optional units string to append (default: empty)
 * @return Formatted string representation of the double
 * @since 1.0
 */
String displayDouble(double d, int decimalPlaces, {String units = ''}) =>
"${d.toStringAsFixed(decimalPlaces)}$units";
    // "${d.toStringAsFixed(decimalPlaces).replaceFirst(RegExp(r'\.?0*$'), '')} $units";

/**
 * @brief Pads a number with leading zeros to reach specified total length.
 * @details Converts an integer to string and pads with leading zeros.
 * @param number The integer to pad
 * @param totalLength The desired total string length
 * @return Zero-padded string representation
 * @since 1.0
 */
String padZeros(int number, int totalLength) {
  return number.toString().padLeft(totalLength, '0');
}

/**
 * @brief Extension methods for String class.
 * @details Adds utility methods for string manipulation and formatting.
 * @since 1.0
 */
extension StringExtension on String {
  /**
   * @brief Converts string to capital case (first letter uppercase, rest lowercase).
   * @details Capitalizes the first character and converts remaining to lowercase.
   * @return Capitalized string
   * @since 1.0
   */
  String toCapital() => length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : this;
}

  void showErrorMessage(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.cyan,
          title: Center(
            child: Text(
              message,
              style: TextStyle(color: Colors.grey[300]),
            )
          ),
        );
      },
    );
  }
  
  void hideSnack(BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }

  void showSnack(BuildContext context, SnackBar snack) {
    hideSnack(context);
    ScaffoldMessenger.of(context).showSnackBar(snack);
  }

Map<String, dynamic> getDbMap(DataSnapshot data) {
  if (data.value != null){
    return Map<String, dynamic>.from(data.value as Map);
  }
  return {};
}


Map<String, dynamic> castDbMap(Map data) {
  return Map<String, dynamic>.from(data);
}


// Extension on String for Title Case
extension StringExtensions on String {
  String toTitleCase() {
    if (this.isEmpty) return this;
    return this
        .split(' ')
        .map((word) =>
            word.isEmpty ? word : word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }
}

Iterable<int> yieldRange(int start, int end, [int step = 1]) sync* {
  for (int i = start; i < end; i += step) {
    yield i;
  }
}

List<int> range(int number, [int? secondNumber, int? step]){
  if (secondNumber != null) {
    if (step != null) {
      return yieldRange(number, secondNumber, step).toList();
    }
    return yieldRange(number, secondNumber).toList();
  }
  if (step!= null){
    yieldRange(0, number, step).toList();
  }
  return yieldRange(0, number).toList();
}

bool isPortrait(ctx) {
    Orientation orient = MediaQuery.of(ctx).orientation;
    return (orient == Orientation.portrait);
}