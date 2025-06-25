import 'package:flutter/material.dart';

Widget titleText (String title, final Color color) {
  return  Text(
    title, 
    textAlign: TextAlign.center,
    style: TextStyle(
      color: color,
      fontSize: 24
      // fontWeight: FontWeight.bold,
    )
  );
}

Widget subTitleText(String subTitle, final Color color) {
  return Text(
    subTitle,
    textAlign: TextAlign.center,
    style: TextStyle(
      color: color,
      fontSize: 16,
      fontWeight: FontWeight.bold,
    ),
  );
}

Widget titleTextWithStatus(dynamic activeDevice) {
  String title, status;
  Color titleColor, statusColor;
  
  if (activeDevice == null || activeDevice.id == "None") {
    title = "No Device Selected";
    titleColor = Colors.red;
    status = '';
    statusColor = Colors.white;
  }
  else {
    title = activeDevice.name;
    titleColor = Colors.white;
    status = (activeDevice.state != null) ? activeDevice.state.statusMessage.text : '';
    statusColor = (activeDevice.state != null) ?  activeDevice.state.statusMessage.color : '';
  }

  return 
     Column(
      mainAxisAlignment: MainAxisAlignment.center,
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        titleText(title, titleColor), 
        subTitleText(status, statusColor)
      ],
    );
}