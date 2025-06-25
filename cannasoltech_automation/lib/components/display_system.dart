
import 'package:cannasoltech_automation/shared/shared_widgets.dart';
import 'package:flutter/material.dart';

class DisplaySysValUnits extends StatelessWidget {
  final String text;
  final String val;
  final String units;

  const DisplaySysValUnits({super.key, required this.text, required this.val, required this.units});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        DisplaySysVal(text: text, val: val),
        const SizedBox(width: 5),
        DisplayText(displayText: units),
      ],
    );
  }
}
