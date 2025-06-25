import 'package:cannasoltech_automation/components/side_menu.dart';
import 'package:cannasoltech_automation/components/system_app_bar.dart';
import 'package:cannasoltech_automation/providers/system_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cannasoltech_automation/components/bottom_nav_bar.dart';

import '../../components/buttons/reset_button.dart';
import '../../data_models/device.dart';
import '../../shared/constants.dart';
import 'start_page.dart';

class EndPage extends StatefulWidget {
  const EndPage({super.key});
  @override
  State<EndPage> createState() => _EndPageState();
}


class _EndPageState extends State<EndPage> {

  @override
  Widget build(BuildContext context) {
    return Selector<SystemDataModel, ({Device? activeDevice, int state})>(
     selector: (_, model) => (activeDevice: model.activeDevice, 
                              state: model.activeDevice?.state.state ?? INIT),
    builder: (_xX, data, Xx_) {
      if (data.state != FINISHED) {
        return const StartPage();  
      }
      else {
        return Scaffold(
          appBar: systemAppBar(context, data.activeDevice),
          drawer: const SideMenu(),
          body: SafeArea(
            child: Center(
              child:Column(
              children: [const SizedBox(height: 100), Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(alignment: Alignment.center, child: Image.asset("assets/images/BigIcon.png"),),
                ],
            ),),
                Row(
                  children: <Widget> [
                    Container(
                      padding: const EdgeInsets.all(5),
                      alignment: Alignment.bottomLeft,
                      child: resetButton(context, Provider.of<SystemDataModel>),
                    ),
                  ],
                ),
            ]
            ),
            ),
          ),
            bottomNavigationBar: BottomNavBar(),
        );
      }
    });
  }
}
