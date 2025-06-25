import 'package:cannasoltech_automation/components/save_slot_card.dart';
import 'package:cannasoltech_automation/components/side_menu.dart';
import 'package:cannasoltech_automation/components/system_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cannasoltech_automation/components/bottom_nav_bar.dart';
import 'package:cannasoltech_automation/providers/system_data_provider.dart';
import '../components/buttons/back_button.dart';

class SavePage extends StatefulWidget {
  const SavePage({super.key});
  @override
  State<SavePage> createState() => _SavePageState();
}

class _SavePageState extends State<SavePage> {

@override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Consumer<SystemDataModel> (
      builder: (context, value, child) =>  Scaffold(
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
                        saveSlotCard(context, 1),                 
                        saveSlotCard(context, 2),
                        saveSlotCard(context, 3),
                        saveSlotCard(context, 4),
                        saveSlotCard(context, 5),
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
      )
    );
  }
}
