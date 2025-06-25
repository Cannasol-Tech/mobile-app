import 'package:cannasoltech_automation/components/side_menu.dart';
import 'package:cannasoltech_automation/components/system_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cannasoltech_automation/components/bottom_nav_bar.dart';
import 'package:cannasoltech_automation/providers/system_data_provider.dart';
import 'package:cannasoltech_automation/components/buttons/back_button.dart';

import '../components/load_slot_card.dart';

class LoadPage extends StatefulWidget {
  const LoadPage({super.key});
  @override
  State<LoadPage> createState() => _LoadPageState();
}

class _LoadPageState extends State<LoadPage> {

@override
  Widget build(BuildContext context) {
    // context.watch<SystemDataModel>().alarmHandler.notifications;
    // Provider.of<SystemDataModel>(context, listen: false).alarmHandler.showAlarmBanners(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Consumer<SystemDataModel> (builder: (context, value, child) =>  Scaffold(
      appBar: systemAppBar(context, value.activeDevice),
      body: SafeArea(
        child: Center(child: (value.activeDevice != null)? 
         Column(
            children: <Widget> [
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      loadSlotCard(context, 1),                 
                      loadSlotCard(context, 2),
                      loadSlotCard(context, 3),
                      loadSlotCard(context, 4),
                      loadSlotCard(context, 5),
                    ],
                  ),
                ),
              ),
              Row(
                children: <Widget> [
                  Container(
                    padding: const EdgeInsets.all(2),
                    alignment: Alignment.bottomLeft,
                    child: backButton(context),
                  ),
                  SizedBox(width: screenWidth-208),
                  Container(child: null),
                ],
              ),
            ]
          ) : Column(children: <Widget>[SizedBox(height: screenHeight/2.5), const Text("No Device Selected!", style: TextStyle(color: Colors.red, fontSize: 24, fontWeight: FontWeight.bold))])),
      ),
      drawer: const SideMenu(),
      bottomNavigationBar: BottomNavBar() //displayProvider: Provider.of<DisplayDataModel>, dataProvider: Provider.of<SystemDataModel>),
    ));
  }
}
