// // Import async library for Timer
// // ignore_for_file: no_leading_underscores_for_local_identifiers

// import 'package:cannasoltech_automation/components/side_menu.dart';
// import 'package:cannasoltech_automation/components/system_app_bar.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:cannasoltech_automation/components/bottom_nav_bar.dart';
// import 'package:cannasoltech_automation/providers/system_data_provider.dart';
// import 'package:cannasoltech_automation/providers/display_data_provider.dart';

// import '../data_models/device.dart';
// import '../shared/constants.dart';

// class NoDevicePage extends StatefulWidget {
//   const NoDevicePage({super.key});
//   @override
//   State<NoDevicePage> createState() => _NoDevicePageState();
// }

// class _NoDevicePageState extends State<NoDevicePage> {
//   @override
//   Widget build(BuildContext context) {
//     return Selector<SystemDataModel, Device>(
//       selector: (_, p) => ((p.activeDevice != null) ?p.activeDevice! : ActiveDevice.noDevice()),
//       builder: (_x, activeDevice, x_) {
//         return Scaffold(
//           appBar: systemAppBar(context, activeDevice),
//           drawer: const SideMenu(),
//           body: SafeArea(
//             child: Center(
//               child: Column(
//                 children: <Widget> [
//                   Expanded(
//                     child: Image.asset(LARGE_ICON, fit: BoxFit.contain),
//                 )]
//               ),
//             ),
//           ),
//           bottomNavigationBar: BottomNavBar(displayProvider: Provider.of<DisplayDataModel>, dataProvider: Provider.of<SystemDataModel>),
//         );
//       }
//     );
//   }
// }

