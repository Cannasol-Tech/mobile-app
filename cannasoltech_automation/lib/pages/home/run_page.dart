
import 'package:cannasoltech_automation/components/system_display/sonicator_display.dart';
import 'package:cannasoltech_automation/components/system_display/pump_display.dart';
import 'package:cannasoltech_automation/components/system_display/tank_display.dart';
import 'package:cannasoltech_automation/components/buttons/resume_button.dart';
import 'package:cannasoltech_automation/components/buttons/abort_button.dart';
import 'package:cannasoltech_automation/providers/system_data_provider.dart';
import 'package:cannasoltech_automation/components/buttons/end_button.dart';
import 'package:cannasoltech_automation/components/bottom_nav_bar.dart';
import 'package:cannasoltech_automation/components/system_app_bar.dart';
import 'package:cannasoltech_automation/components/side_menu.dart';
import 'package:cannasoltech_automation/components/run_stats.dart';
import '../../UserInterface/text_styles.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../../UserInterface/ui.dart';
import '../../data_models/device.dart';
import '../../shared/constants.dart';
import '../../shared/methods.dart';
import '../../shared/types.dart';
import 'start_page.dart';
import 'end_page.dart';

class RunPage extends StatefulWidget {
  final int startIndex;
  const RunPage({super.key, this.startIndex = 0});

  @override
  State<RunPage> createState() => _RunPageState();
}

class _RunPageState extends State<RunPage> {

  late int index;
  late Orientation? orient;
  final int numElements = 3;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Selector<SystemDataModel, ({Device? activeDevice, int state})>(
     selector: (_, model) => (activeDevice: model.activeDevice, 
                              state: model.activeDevice?.state.state ?? INIT),
    builder: (_xX, data, Xx_) {
        final state = data.state;
        final activeDevice = data.activeDevice;
        index = context.watch<SystemIdx>().value;
        orient = MediaQuery.of(context).orientation;
        if ((data.activeDevice == null)) {
          return noDeviceDisplay();
        } else {
          switch (state) {
            case INIT     : return const StartPage();
            case FINISHED : return const EndPage();
            default: return Scaffold(
                appBar: systemAppBar(context, activeDevice),
                drawer: const SideMenu(),
                bottomNavigationBar: BottomNavBar(),
                body: SafeArea(
                  child: (isPortrait(context)) ? 
                    portraitDisplay(activeDevice)
                  : landscapeDisplay(activeDevice),
              ),
            );
          }
        }
      }
    );
  }

  void _onSwipe(Direction swipeDir) {
    if (swipeDir == Direction.left) {
      context.read<SystemIdx>().increment();
    } 
    else if (swipeDir == Direction.right) {
      context.read<SystemIdx>().decrement();
    }
  }

  dynamic readSwipe(event) => (
      (event.primaryVelocity! < -200) ? _onSwipe(Direction.left) 
    : (event.primaryVelocity! > 200) ? _onSwipe(Direction.right) : null  
  );

  Widget getSysDisplay(idx) {
    switch(idx) {
      case 0: return const SonicatorDisplay();
      case 1: return const PumpDisplay();
      case 2: return const TankDisplay();
      default: return Container(child: null);
    }
  }

  Widget noDeviceDisplay() => const Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text("No Device Selected!", 
          style: noDeviceStyle
        ),
      ],
    ),
  );

  Widget portraitDisplay(activeDevice) => 
    GestureDetector(
      onHorizontalDragEnd: (event) => readSwipe(event),
      child: Stack(
        children: [
          runStats(activeDevice, orient),
          Padding(
            padding: const EdgeInsets.only(bottom: 70.0, top: 20.0),
              child: getSysDisplay(index),
            ),
          Column(
            children: [
              Expanded(child: Container()),
              buttonRowPad(const ControlButtonRow()),
            ]
          ),
        ]
      ),
    );

  Center landscapeDisplay(activeDev) { 
    UI ui = userInterface(context);
    return Center(
      child: Stack(
        children: [
          // const Expanded(
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children:[
              runStats(activeDev, Orientation.landscape),
              Expanded(child: Container()), 
                Container(
                  alignment: Alignment.center,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SonicatorDisplay(),
                      PumpDisplay(),
                      TankDisplay(),
                    ],
                  ),
                )
              // )
              // ),
            ]
      ),
    ]
    ));
  }
  
  bool portrait(Orientation orientation) => orientation == Orientation.portrait;

}

Widget buttonRowPad(buttonRow) => Padding(
  padding: const EdgeInsets.symmetric(
    vertical: 8.0, horizontal: 10.0), 
  child: buttonRow 
); 

class ControlButtonRow extends StatelessWidget {
  const ControlButtonRow({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          abortButton(context, Provider.of<SystemDataModel>),
          const ResumeButton(),
          endButton(context, Provider.of<SystemDataModel>),
        ],
      ),
    );
  }
}

// Enum to define swipe direction
