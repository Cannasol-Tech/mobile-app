
import 'package:flutter/material.dart';
import '../pages/log_page.dart';
import 'title_text.dart';

PreferredSizeWidget? systemAppBar(context, activeDevice) => AppBar(
        leading: drawerButton(),
        backgroundColor: Colors.grey[900],
        centerTitle: true,
        title: titleTextWithStatus(activeDevice)
    );

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

