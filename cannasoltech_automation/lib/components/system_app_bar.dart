
/**
 * @file system_app_bar.dart
 * @author Stephen Boyett
 * @date 2025-09-06
 * @brief System application bar component with device status display.
 * @details Provides a standardized app bar with drawer navigation and device
 *          status information for the Cannasol Technologies application.
 * @version 1.0
 * @since 1.0
 */

import 'package:flutter/material.dart';
import '../pages/log_page.dart';
import 'title_text.dart';

/**
 * @brief Creates a system app bar with device status.
 * @details Builds an AppBar with drawer navigation, dark theme, and device status title.
 * @param context Build context for the app bar
 * @param activeDevice Currently active device for status display
 * @return PreferredSizeWidget configured app bar or null
 * @since 1.0
 */
PreferredSizeWidget? systemAppBar(context, activeDevice) => AppBar(
        leading: drawerButton(),
        backgroundColor: Colors.grey[900],
        centerTitle: true,
        title: titleTextWithStatus(activeDevice)
    );

/**
 * @brief Creates a drawer button for the app bar.
 * @details Builds an IconButton that opens the navigation drawer with proper
 *          styling and accessibility support.
 * @return Builder widget containing the drawer button
 * @since 1.0
 */
Builder drawerButton() {
  return Builder(
        builder: (BuildContext context) {
          return IconButton(
            color: Colors.white,
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
          );
        },
      );
}

PreferredSizeWidget? logPageAppBar(context, activeDevice) => AppBar(
        leading: appBarBackButton(),
        backgroundColor: Colors.grey[900],
        centerTitle: true,
        title: titleTextWithStatus(activeDevice)
    );

Builder appBarBackButton() {
  return Builder(
        builder: (BuildContext context) {
          return IconButton(
            color: Colors.blue.shade300,
            icon: const Icon(Icons.arrow_back_rounded  , size: 30),
            onPressed: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const LogPage()));
            },
          );
        },
      );
}

