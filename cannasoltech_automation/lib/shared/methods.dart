
// ignore_for_file: unnecessary_this

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../data_models/device.dart';

typedef ActiveDevice = Device;

String displayDouble(double d, int decimalPlaces, {String units = ''}) =>
"${d.toStringAsFixed(decimalPlaces)}$units";
    // "${d.toStringAsFixed(decimalPlaces).replaceFirst(RegExp(r'\.?0*$'), '')} $units";

String padZeros(int number, int totalLength) {
  return number.toString().padLeft(totalLength, '0');
}

extension StringExtension on String {
  String toCapital() => length > 0 ?'${this[0].toUpperCase()}${substring(1).toLowerCase()}': this[0].toUpperCase();
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