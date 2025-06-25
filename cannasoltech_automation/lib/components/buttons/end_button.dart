import 'package:cannasoltech_automation/shared/constants.dart';
import 'package:flutter/material.dart';
import '../../UserInterface/ui.dart';
import 'confirm_button.dart';

Widget endButton(context, dataProvider) { 
    UI ui = userInterface(context);
    return SizedBox(
      width: ui.size.bottomButtonWidth,
      height: ui.size.bottomButtonHeight,
      child: ConfirmButton(
        color: originalConfirmButtonColor,
        confirmMethod: dataProvider(context, listen: false).activeDevice.config.endRun,
        confirmText: 'wish to end',
        buttonText: 'End',
        hero: 'endRunbtn',
      ),
  );
}
