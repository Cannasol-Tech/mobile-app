import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/display_data_provider.dart';
import '../providers/system_data_provider.dart';

class BottomNavBar extends StatelessWidget {
  BottomNavBar({super.key});
  final List<BottomNavigationBarItem> bottomNavBarItems = [
    const BottomNavigationBarItem(
      icon: Icon(Icons.home_rounded),
      activeIcon: Icon(Icons.home_sharp),
      label: 'Home',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.settings),
      activeIcon: Icon(Icons.settings),
      label: 'Configuration',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.document_scanner),
      activeIcon: Icon(Icons.document_scanner_sharp),
      label: 'System Logs',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.error_outline),
      activeIcon: Icon(Icons.error_outline_sharp),
      label: 'Alarm Logs',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    var displayProvider = context.watch<DisplayDataModel>();
    int bottomNavSelectedItem = displayProvider.bottomNavSelectedItem; 
    return BottomNavigationBar(
        currentIndex: bottomNavSelectedItem == -1 ? 0 : bottomNavSelectedItem,
        selectedItemColor: (bottomNavSelectedItem != -1) ? const Color.fromARGB(199, 17, 120, 168) : const Color.fromARGB(255, 2, 2, 2),
        unselectedItemColor: const Color.fromARGB(255, 0, 0, 0),
        onTap: (index) {
              context.read<DisplayDataModel>().setBottomNavSelectedItem(index);
              Navigator.of(context).popUntil(ModalRoute.withName('/'));
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => context.read<SystemDataModel>().bottomNavPages[index]));
        },
        items: bottomNavBarItems,
        type: BottomNavigationBarType.fixed
    );
  }
}
