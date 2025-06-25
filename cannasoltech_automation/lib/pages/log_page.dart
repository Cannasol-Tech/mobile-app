import 'package:cannasoltech_automation/components/side_menu.dart';
import 'package:cannasoltech_automation/components/system_app_bar.dart';
import 'package:cannasoltech_automation/shared/methods.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cannasoltech_automation/shared/shared_widgets.dart';
import 'package:cannasoltech_automation/components/bottom_nav_bar.dart';
import 'package:cannasoltech_automation/providers/system_data_provider.dart';
import 'package:simple_animations/simple_animations.dart';

import '../UserInterface/ui.dart';
import '../components/display_system.dart';
import 'log_history_page.dart';


class LogPage extends StatefulWidget {
  const LogPage({super.key});
  @override
  State<LogPage> createState() => _LogPageState();
}

class _LogPageState extends State<LogPage> with AnimationMixin {
  late AnimationController scalarController;
  late Animation<double> scalar;

  @override
  void initState() {
    scalarController = createController()
    ..play(duration: const Duration(milliseconds: 100));
    scalar = Tween(begin: 0.0, end: 1.0).animate(scalarController);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UI ui = userInterface(context);
    return Consumer<SystemDataModel> (builder: (context, value, child) =>  Scaffold(
      appBar: systemAppBar(context, value.activeDevice),
      body: SafeArea(
        child: Center(
          child: (value.activeDevice != null) ? value.activeDevice!.state.isOnline ?
          ui.size.orientation == Orientation.portrait ?
            Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 110.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const SizedBox(height: 50),
                      const Center(child: Text("Current Run", style: TextStyle(fontSize: 35, decoration: TextDecoration.underline, fontWeight: FontWeight.bold))),
                      const SizedBox(height: 25),
                      DisplaySysVal(text: "Operator", val: context.read<SystemDataModel>().userHandler.getUserName(context.read<SystemDataModel>().activeDevice?.currentRun?.startUser ?? "None")),
                      const SizedBox(height: 10),
                      DisplaySysVal(text: "Operating Time", val: value.activeDevice!.state.runTime),
                      const SizedBox(height: 10),
                      DisplaySysValUnits(text: "Average Flow", val: displayDouble(value.activeDevice!.state.avgFlowRate, 2), units: "L/min"),
                      const SizedBox(height: 10),
                      DisplaySysValUnits(text: "Average Temperature", val: displayDouble(value.activeDevice!.state.avgTemp, 2), units: "\u00B0C"),
                      const SizedBox(height: 10),
                      (value.activeDevice!.config.batchSize != 0) ? DisplaySysVal(text: "Number of Passes", val: displayDouble(value.activeDevice!.state.numPasses, 2)) : const Text("Enter batch size to view number of passes.",  style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic)),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Expanded(child: Container()),
                      Container(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 40.0),
                          child: FittedBox(
                            fit: BoxFit.fitWidth,
                            child: Container(
                              alignment: Alignment.center,
                              // height: 50,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shadowColor: Colors.grey.withAlpha((100+80*scalar.value).toInt()),
                                  backgroundColor: Colors.blueGrey.withAlpha(20),
                                  elevation: 20-10*scalar.value,
                                  animationDuration: const Duration(seconds: 1),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const LogHistoryPage()));
                                },
                                child:  const Row(
                                  children: [
                                    Icon(Icons.remove_red_eye_outlined), 
                                    Padding(
                                      padding: EdgeInsets.all(4.0),
                                      child: Text(
                                        "View History",
                                        style: TextStyle(
                                          fontSize: 18, 
                                          color: Colors.black, 
                                          fontWeight: FontWeight.w500, 
                                          fontStyle: FontStyle.italic
                                        )
                                      ),
                                    )
                                  ]
                                ),
                              ),
                            ),
                          ),
                        )
                      ),
                      /* DOWNLOAD DEVICE HISTORY BUTTON */
                      // Container(
                      //   // constraints: BoxConstraints.loose(Size(200, 50)),
                      //   alignment: Alignment.bottomCenter,
                      //   child: Padding(
                      //     padding: const EdgeInsets.only(bottom: 15.0),
                      //     child: FittedBox(
                      //       fit: BoxFit.fitWidth,
                      //       child: Container(
                      //         alignment: Alignment.center,
                      //         height: 50,
                      //         child: ElevatedButton(
                      //           style: ElevatedButton.styleFrom(
                      //             shadowColor: Colors.blue.withAlpha(160),
                      //             foregroundColor: Colors.blue,
                      //             backgroundColor: Colors.white.withAlpha(130),
                      //             elevation: 10,
                      //             animationDuration: const Duration(seconds: 1),
                      //           ),
                      //           onPressed: () {
                      //             value.activeDevice!.downloadDeviceHistory();
                      //           },
                      //           child: const Row(
                      //             children: [
                      //               Icon(Icons.download), 
                      //               Text(
                      //                 " Download Device History", 
                      //                 style: TextStyle(fontSize: 20, color: Colors.blue, fontStyle: FontStyle.italic, fontWeight: FontWeight.bold)
                      //               )
                      //             ]
                      //           ),
                      //         ),
                      //       ),
                      //     ),
                      //   )
                      // ),
                    ],
                  ),
                ],
            ) 
          : Container(
            constraints: BoxConstraints.loose(Size(ui.size.displayHeight, ui.size.displayWidth)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                const Spacer(), const Spacer(), const Spacer(), const Spacer(),
                const Spacer(), const Spacer(), const Spacer(), const Spacer(),
                DisplaySysVal(
                  text: "Operating Time", 
                  val: value.activeDevice!.state.runTime
                ),
                const Spacer(),
                DisplaySysValUnits(
                  text: "Average Flow", 
                  val: displayDouble(value.activeDevice!.state.avgFlowRate, 2), 
                  units: "L/min"
                ),
                const Spacer(),
                DisplaySysValUnits(
                  text: "Average Temperature",
                  val: displayDouble(
                    value.activeDevice!.state.avgTemp, 2
                  ), 
                  units: "\u00B0C"
                ),
                const Spacer(),
                (value.activeDevice!.config.batchSize != 0) 
                ? DisplaySysVal(
                  text: "Number of Passes", 
                  val: displayDouble(value.activeDevice!.state.numPasses, 2)) 
                  : const Text(
                    "Enter batch size to view number of passes.",  
                    style: TextStyle(
                      fontSize: 16, 
                      fontStyle: FontStyle.italic
                      )
                    ),
                const Spacer(), const Spacer(), const Spacer(), const Spacer(),
                const Spacer(), const Spacer(), const Spacer(), const Spacer(),
              ],
            ),
          )
          : Container(alignment: Alignment.center, child: const Text("No Device Selected!", style: TextStyle(color: Colors.red, fontSize: 24, fontWeight: FontWeight.bold)))
          : Container(alignment: Alignment.center, child: const Text("No Device Selected!", style: TextStyle(color: Colors.red, fontSize: 24, fontWeight: FontWeight.bold)))
          ),
        ),
       drawer: const SideMenu(),
      bottomNavigationBar: BottomNavBar()
      )
    );
  }
}
