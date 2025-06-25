import 'package:flutter/material.dart';
import 'package:cannasoltech_automation/shared/constants.dart';
import 'confirm_button.dart';

Widget resetButton(context, dataProvider) { 
  return Container(
    // padding: const EdgeInsets.all(2),
    alignment: Alignment.centerRight,
    child: SizedBox(
        width: 100,
        height: 50,
        child: ConfirmButton(
          color: originalConfirmButtonColor,
          confirmMethod: dataProvider(context, listen: false).activeDevice?.config.resetDevice,
          confirmText: 'wish to reset the device',
          buttonText: 'Reset',
          hero: 'resetRunBtn',
        )
    )
  );
}
