import 'package:cannasoltech_automation/providers/system_data_provider.dart';
import 'package:cannasoltech_automation/shared/methods.dart';
import 'package:cannasoltech_automation/shared/shared_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data_models/device.dart';
import '../UserInterface/ui.dart';
import '../UserInterface/text_styles.dart';
import 'app_card.dart';
import 'display_system.dart';
import 'buttons/confirm_button.dart';

extension StringExtension on String {
  String toCapital() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}

Widget slotCard(context, idx, option) {
  double screenWidth = MediaQuery.of(context).size.width;
  double screenHeight = MediaQuery.of(context).size.height;
  double cardWidth = screenWidth * 0.9;
  double cardHeight = screenHeight * 0.70;
  Device? activeDevice = Provider.of<SystemDataModel>(context, listen: false).activeDevice;
  final ui = userInterface(context);
  
  return (activeDevice != null) ?
    SafeArea(
      child: SizedBox(
        height: screenHeight,
        width: screenWidth,
        child: Row(
          children: <Widget>[
            const Spacer(),
            AppCard(
              title: "${option.toString().toCapital()} Slot $idx",
              width: cardWidth,
              height: cardHeight,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 16.0),
                    DisplaySysVal(
                      text: "Set Time",
                      val: activeDevice.saveSlots[idx - 1].setTime,
                    ),
                    const SizedBox(height: 24.0),
                    DisplaySysValUnits(
                      text: "Set Temperature",
                      val: displayDouble(activeDevice.saveSlots[idx - 1].setTemp, 1),
                      units: '\u2103',
                    ),
                    const SizedBox(height: 24.0),
                    DisplaySysVal(
                      text: "Batch Size",
                      val: displayDouble(activeDevice.saveSlots[idx - 1].batchSize, 1),
                    ),
                    const SizedBox(height: 24.0),
                    DisplaySysValUnits(
                      text: "Temp Variance",
                      val: displayDouble(activeDevice.saveSlots[idx - 1].tempThresh, 1),
                      units: '\u2103',
                    ),
                    const SizedBox(height: 24.0),
                    DisplaySysValUnits(
                      text: "Min. Flow Rate",
                      val: displayDouble(activeDevice.saveSlots[idx - 1].flowThresh, 1),
                      units: "L/min",
                    ),
                    const SizedBox(height: 24.0),
                    DisplaySysValUnits(
                      text: "Min. Pressure",
                      val: displayDouble(activeDevice.saveSlots[idx - 1].pressureThresh, 1),
                      units: "psi",
                    ),
                    const SizedBox(height: 24.0),
                    DisplaySysValUnits(
                      text: "Cool Down Temp",
                      val: displayDouble(activeDevice.saveSlots[idx - 1].cooldownTemp, 1),
                      units: '\u2103',
                    ),
                    const SizedBox(height: 24.0),
                    DisplaySysVal(
                      text: "Cool Down Enabled",
                      val: StringExtension(activeDevice.saveSlots[idx - 1].cooldownEnabled.toString()).toCapital(),
                    ),
                    const SizedBox(height: 24.0),
                    // Add save or load button based on option
                    SizedBox(
                      width: 140,
                      height: 50,
                      child: ConfirmButton(
                        color: Theme.of(context).colorScheme.primary,
                        confirmMethod: option == "save" 
                          ? activeDevice.saveSlots[idx - 1].save
                          : activeDevice.saveSlots[idx - 1].load,
                        confirmText: option == "save"
                          ? 'want to overwrite the contents of save slot #$idx'
                          : 'want to load the contents of save slot #$idx',
                        buttonText: option == "save" ? 'Save Config' : 'Load Config',
                        hero: '${option}CfgBtn_$idx',
                      ),
                    ),
                    const SizedBox(height: 16.0),
                  ],
                ),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    ) :
    SafeArea(
      child: Container(
        child: null,
      ),
    );
}