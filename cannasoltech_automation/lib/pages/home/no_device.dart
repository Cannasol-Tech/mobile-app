// Import async library for Timer
import 'package:cannasoltech_automation/components/side_menu.dart';
import 'package:cannasoltech_automation/components/system_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cannasoltech_automation/components/bottom_nav_bar.dart';
import 'package:cannasoltech_automation/providers/system_data_provider.dart';

import '../../shared/constants.dart';




class NoDevicePage extends StatefulWidget {
  const NoDevicePage({super.key});
  @override
  State<NoDevicePage> createState() => _NoDevicePageState();
}

class _NoDevicePageState extends State<NoDevicePage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<SystemDataModel> (
      builder: (context, value, child) =>  Scaffold(
        appBar: systemAppBar(context, value.activeDevice),
        drawer: const SideMenu(),
        body: SafeArea(
          child: Center(
            child: Image.asset(
              LARGE_ICON, 
              fit: BoxFit.contain, 
            ),
          ),
        ),
        bottomNavigationBar: BottomNavBar(),
      ),
    );
  }
}
