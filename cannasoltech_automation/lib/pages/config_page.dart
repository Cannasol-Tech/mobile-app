import 'package:cannasoltech_automation/components/buttons/save_button.dart';

import '../UserInterface/ui.dart';
import '../components/buttons/load_button.dart';
import '../components/sys_config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cannasoltech_automation/components/side_menu.dart';
import 'package:cannasoltech_automation/components/system_app_bar.dart';
import 'package:cannasoltech_automation/components/bottom_nav_bar.dart';
import 'package:cannasoltech_automation/providers/system_data_provider.dart';




class ConfigPage extends StatefulWidget {
  const ConfigPage({super.key});
  @override
  State<ConfigPage> createState() => _ConfigPageState();
}

class _ConfigPageState extends State<ConfigPage> {

@override
  Widget build(BuildContext context) {
    UI ui = userInterface(context);
    return Consumer<SystemDataModel>
      (builder: (context, value, child) =>  Scaffold(
      appBar: systemAppBar(context, value.activeDevice),
        body: SafeArea(
            child: Center(
            child: value.activeDevice != null ? 
                   value.activeDevice?.isOnline() == true ? 
              SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Card(
                      elevation: 8,
                      shadowColor: Colors.black,
                      child: Container(
                        width: ui.size.displayWidth * 0.90,
                        height: ui.size.displayHeight * 0.70,
                        constraints: BoxConstraints(maxWidth: ui.size.displayWidth * 0.9, maxHeight: ui.size.displayHeight*0.9),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: < Widget > [] 
                                + sysConfigHeader()
                              + sysConfigList(value)
                            + sysToggleList(value)
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10)
                  ] 
                  + loadSaveRowFull(ui.size.orientation, ui.size.displayWidth),
                ),
              ) 
            : Container(alignment: Alignment.center, child: const Text("Device is offline", style: TextStyle(color: Colors.red, fontSize: 24, fontWeight: FontWeight.bold))) : Container(alignment: Alignment.center, child: const Text("No Device Selected!", style: TextStyle(color: Colors.red, fontSize: 24, fontWeight: FontWeight.bold))),
            ),
          ),
        drawer: const SideMenu(),
        bottomNavigationBar: BottomNavBar() //displayProvider: Provider.of<DisplayDataModel>, dataProvider: Provider.of<SystemDataModel>),
      )
    );
  }

  List<Widget> loadSaveRowFull(orientation, screenWidth) => [
      // portrait(orientation) ? const Spacer() : Container(child: null),
      portrait(orientation) ? loadSaveRow(screenWidth) : Container(child: null),
  ];  

  Widget loadSaveRow (screenWidth) =>              
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      mainAxisSize: MainAxisSize.min,
      children: <Widget> [
        Container(
          padding: const EdgeInsets.all(2),
          alignment: Alignment.bottomLeft,
          child: loadButton(context),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.all(2),
          alignment: Alignment.bottomRight,
          child: saveButton(context),
        )
      ],
    );
  portrait(orientation) => (orientation == Orientation.portrait);

}

