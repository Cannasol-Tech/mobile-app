import 'package:flutter/material.dart';
import 'package:cannasoltech_automation/components/system_input_warning.dart';

class DurationInputWidget extends StatelessWidget {
  final void Function(Duration) onDurationChanged;
  final double width;
  final TextEditingController controller;
  final String labelText;

  const DurationInputWidget({super.key, required this.labelText, required this.onDurationChanged, required this.width, required this.controller});

  @override
  Widget build(BuildContext context) {

    return SizedBox(
        width: width,
        child: TextField(
        onTapOutside: (event) {
          FocusManager.instance.primaryFocus?.unfocus();
          if (_isValidDurationFormat(controller.text)) {
            var duration = _parseDuration(controller.text);
            onDurationChanged(duration);
          }
          else {
            controller.clear();
            showAlertDialog(context, "Please enter the run time in the format 'HH:MM'");
          }
        },
          textAlignVertical: TextAlignVertical.top,
        textAlign: TextAlign.center,
        controller: controller,
        style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        decoration: const InputDecoration(
          isDense: true,
          filled: true,
          fillColor: Color.fromRGBO(22, 90, 126, 245),
          // labelText: labelText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5))),
        ),
        onSubmitted: (value) {
          if (_isValidDurationFormat(value)) {
            var duration = _parseDuration(value);
            onDurationChanged(duration);
          }
          else {
            controller.clear();
            showAlertDialog(context, "Please enter the run time in the format 'HH:MM'");
          }
        },
      ),
    );
  }

  bool _isValidDurationFormat(String value) {
    // Simple regex to check the format HH:MM
    final validDurationFormat = RegExp(r'^[0-9]{1,2}:[0-9][0-9]$');
    return validDurationFormat.hasMatch(value);
  }

  Duration _parseDuration(String value) {
    List<String> parts = value.split(':');
    int hours = int.parse(parts[0]);
    int minutes = int.parse(parts[1]);
    return Duration(hours: hours, minutes: minutes);
  }
}