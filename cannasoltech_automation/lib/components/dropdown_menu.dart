// ignore_for_file: unused_import
import '../objects/logger.dart';
import '../data_models/data.dart';
import '../handlers/user_handler.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

List<DropdownMenuItem<String>> getDropDownItems(
    Devices devices, List<String> deviceList, Map<String, TextStyle> styles) {
  List<DropdownMenuItem<String>> dropDownItems = [
    const DropdownMenuItem(value: 'None', child: Text(''))
  ];
  for (String value in deviceList) {
    var newItem = DropdownMenuItem(
      value: value,
      child: Text(value, style: styles[devices.getIdFromName(value)]),
    );
    dropDownItems.add(newItem);
  }
  return dropDownItems;
}

Widget deviceDropDown(value, styles, setVal, onChanged) {
  if (value.updatingData == false) {
    LOG.info("Starting update data timer from dropdown");
    value.startUpdateDataTimer();
  }
  String setName;
  List<String> watchedDeviceIds = value.userHandler.watchedDevices;
  List<String> watchedDeviceNames = value.devices.idsToNames(watchedDeviceIds);
  if (!watchedDeviceIds.contains(setVal)) {
    if (!watchedDeviceNames.contains(setVal)) {
      setName = 'None';
    } else {
      setName = setVal;
    }
  } else {
    setName = value.devices.getNameFromId(setVal);
  }
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
    child: DropdownButtonFormField<String>(
        style: const TextStyle(
            overflow: TextOverflow.ellipsis,
            fontStyle: FontStyle.italic,
            fontSize: 22,
            fontWeight: FontWeight.w500),
        autofocus: true,
        decoration: const InputDecoration(
          // labelText: "Select Device: ",
          filled: true,
          fillColor: Color.fromRGBO(0, 0, 150, 0.05),
        ),
        value: setName,
        items: getDropDownItems(value.devices, watchedDeviceNames, styles),
        onChanged: (item) => onChanged(item)),
  );
}

// ignore: prefer_const_constructors
Widget dropDownDivider = Divider(
  color: Colors.black, //color of divider
  height: 10, //height spacing of divider
  thickness: 1, //thickness of divier line
);
