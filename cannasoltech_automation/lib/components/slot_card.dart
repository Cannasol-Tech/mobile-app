import 'package:cannasoltech_automation/providers/system_data_provider.dart';
import 'package:cannasoltech_automation/shared/methods.dart';
import 'package:cannasoltech_automation/shared/shared_widgets.dart';
import 'package:fancy_containers/fancy_containers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data_models/device.dart';
import 'display_system.dart';

extension StringExtension on String {
  String toCapital() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}

Widget slotCard (context, idx, option) {
  double screenWidth = MediaQuery.of(context).size.width;
  double screenHeight = MediaQuery.of(context).size.height;
  double cardWidth = screenWidth*0.9;
  double cardHeight = screenHeight*0.70;
  Device? activeDevice = Provider.of<SystemDataModel>(context, listen: false).activeDevice;
  return (activeDevice != null) ?
  SafeArea(

    child: SizedBox(
      height: screenHeight, 
      width: screenWidth, 
      child: Row(
        children: <Widget> [
          const Spacer(),
          Stack( 
            children: [
              SizedBox(height: cardHeight, width: cardWidth, child: const FancyContainer(title: "", color1: Colors.blue, color2: Colors.green)),
              SizedBox(
                height: cardHeight, 
                width: cardWidth, 
                child: SingleChildScrollView(
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: cardWidth,  
                      maxHeight: cardHeight
                    ),
                    child: Column(
                        children: [
                        const Spacer(),
                        Text("Save Slot $idx", style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, decoration: TextDecoration.underline)),
                        const Spacer(),
                        DisplaySysVal(text: "Set Time", val: activeDevice.saveSlots[idx-1].setTime),
                        const Spacer(),
                        DisplaySysValUnits(text: "Set Temperature", val: displayDouble(activeDevice.saveSlots[idx-1].setTemp, 1), units: '\u2103'),
                        const Spacer(),
                        DisplaySysVal(text: "Batch Size", val: displayDouble(activeDevice.saveSlots[idx-1].batchSize, 1)),
                        const Spacer(),
                        DisplaySysValUnits(text: "Temp Variance", val: displayDouble(activeDevice.saveSlots[idx-1].tempThresh, 1), units: '\u2103'),
                        const Spacer(),
                        DisplaySysValUnits(text: "Min. Flow Rate", val: displayDouble(activeDevice.saveSlots[idx-1].flowThresh, 1), units: "L/min"),
                        const Spacer(),
                        DisplaySysValUnits(text: "Min. Pressure", val: displayDouble(activeDevice.saveSlots[idx-1].pressureThresh, 1), units: "psi"),
                        const Spacer(),
                        DisplaySysValUnits(text: "Cool Down Temp", val: displayDouble(activeDevice.saveSlots[idx-1].cooldownTemp, 1), units: '\u2103'),
                        const Spacer(),
                        DisplaySysVal(text: "Cool Down Enabled", val: StringExtension(activeDevice.saveSlots[idx-1].cooldownEnabled.toString()).toCapital())
                      ]
                    ),
                  ),
                ),
              ),
            ]
          ),
          const Spacer(),
        ],
      ),
    ),
  ) : 
  SafeArea( 
  child: Container(
    child: null
  )
  );
}