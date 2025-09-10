/**
 * @file start_page.dart
 * @author Stephen Boyett
 * @date 2025-09-06
 * @brief Device operation start page with configuration interface.
 * @details Provides user interface for configuring and starting device operations
 *          including time settings, pump controls, and system validation.
 * @version 1.0
 * @since 1.0
 */

import 'package:cannasoltech_automation/handlers/current_run.dart';

import '../../UserInterface/ui.dart';
import '../../handlers/user_handler.dart';
import 'end_page.dart';
import 'run_page.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../shared/constants.dart';
import '../../data_models/device.dart';
import '../../components/side_menu.dart';
import '../../components/list_config.dart';
import '../../components/dropdown_menu.dart';
import '../../components/bottom_nav_bar.dart';
import '../../components/system_app_bar.dart';
import '../../components/set_time_config.dart';
import '../../components/pump_control_config.dart';
import '../../providers/system_data_provider.dart';
import '../../components/system_input_warning.dart';

/**
 * @brief Start page for device operation configuration and initiation.
 * @details Stateful widget providing comprehensive interface for configuring
 *          device parameters and starting operations with validation.
 * @since 1.0
 */
class StartPage extends StatefulWidget {
  /**
   * @brief Creates a StartPage widget.
   * @param key Optional widget key for identification
   */
  const StartPage({super.key});

  /**
   * @brief Creates the state for StartPage widget.
   * @return _StartPageState instance
   */
  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  noDeviceSelectedDisplay() => (Expanded(
      child: Container(
          alignment: Alignment.center,
          child: const Text("No Device Selected!",
              style: TextStyle(
                  color: Colors.red,
                  fontSize: 24,
                  fontWeight: FontWeight.bold)))));

  get runPageStates => [RUNNING, WARM_UP, ALARM, COOL_DOWN];

  @override
  Widget build(BuildContext context) {
    return Consumer<SystemDataModel>(builder: (_xX, value, Xx_) {
      UI ui = userInterface(context);
      int state = value.activeDevice?.state.state ?? INIT;
      Device? activeDevice = value.activeDevice;
      if (runPageStates.contains(state)) {
        return const RunPage();
      } else if (state == FINISHED) {
        return const EndPage();
      }
      return (activeDevice == null)
          ? Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.grey[900],
                centerTitle: true,
                title: const Text("Cannasol Technologies", style: TextStyle(color: Colors.white)),
                leading: Builder(
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
                ),
              ),
              drawer: const SideMenu(),
              body: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "No Device Selected!",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 24,
                        fontWeight: FontWeight.bold
                      )
                    )
                  ],
                )
              ),
              bottomNavigationBar: BottomNavBar(),
            )
          : Scaffold(
              appBar: systemAppBar(context, activeDevice),
              drawer: const SideMenu(),
              body: SafeArea(
                child: Center(
                  child: Card(
                      shadowColor: Colors.black,
                      elevation: 8,
                      child: (activeDevice.isOnline())
                          ? Container(
                              width: ui.size.displayWidth * 0.90,
                              height: ui.size.displayHeight * 0.70,
                              constraints: BoxConstraints(
                                  maxWidth: ui.size.maxWidth,
                                  maxHeight: ui.size.displayHeight * 0.9),
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Image.asset("assets/images/SmallIcon.png"),
                                    _gap(),
                                    const Text(
                                      "Ultrasonic Control System",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        decoration: TextDecoration.underline,
                                        fontSize: 24,
                                      ),
                                    ),
                                    _gap(),
                                    dropDownDivider,
                                    const SetTimeConfig(),
                                    dropDownDivider,
                                    const SetTempListConfig(),
                                    dropDownDivider,
                                    const SetBatchSizeConfig(),
                                    dropDownDivider,
                                    const PumpControlConfig(),
                                    dropDownDivider,
                                    _gap(),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.4,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          elevation: 15,
                                          shadowColor: Colors.black,
                                          backgroundColor: Colors.blueGrey,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                        ),
                                        child: const Padding(
                                          padding: EdgeInsets.all(10.0),
                                          child: Text(
                                            'Start',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black),
                                          ),
                                        ),
                                        onPressed: () {
                                          if (activeDevice.state.paramsValid ==
                                              true) {
                                            Provider.of<SystemDataModel>(
                                                    context,
                                                    listen: false)
                                                .activeDevice!
                                                .config
                                                .startDevice(context);
                                            UserHandler currentUser = context
                                                .read<SystemDataModel>()
                                                .userHandler;
                                            if (currentUser.uid != null) {
                                              CurrentRunModel? currentRun =
                                                  context
                                                      .read<SystemDataModel>()
                                                      .activeDevice
                                                      ?.currentRun;
                                              currentRun
                                                  ?.setUser(currentUser.uid!);
                                            }
                                          } else {
                                            showAlertDialog(context,
                                                "Turn on pump and enter valid parameters to start your system.");
                                          }
                                          return;
                                        },
                                      ),
                                    ),
                                    _gap(),
                                  ],
                                ),
                              ),
                            )
                          : Container(
                              alignment: Alignment.center,
                              child: const Text("Device is offline",
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold)))),
                ),
              ),
              bottomNavigationBar: BottomNavBar(),
            );
    });
  }

  Widget _gap() => const SizedBox(height: 16);
}
