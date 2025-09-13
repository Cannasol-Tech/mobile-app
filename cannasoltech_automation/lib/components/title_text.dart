/**
 * @file title_text.dart
 * @author Stephen Boyett
 * @date 2025-09-06
 * @brief Title and subtitle text components with styling.
 * @details Provides standardized text widgets for titles, subtitles, and
 *          device status display with consistent styling and formatting.
 * @version 1.0
 * @since 1.0
 */

import 'package:flutter/material.dart';

/**
 * @brief Creates a styled title text widget.
 * @details Generates a centered text widget with specified title and color
 *          using standardized title styling (24px font size).
 * @param title The title text to display
 * @param color The color for the title text
 * @return Widget containing the styled title text
 * @since 1.0
 */
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

/**
 * @brief Creates a styled subtitle text widget.
 * @details Generates a centered text widget with specified subtitle and color
 *          using standardized subtitle styling.
 * @param subTitle The subtitle text to display
 * @param color The color for the subtitle text
 * @return Widget containing the styled subtitle text
 * @since 1.0
 */
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