import 'package:cannasoltech_automation/components/side_menu.dart';
import 'package:cannasoltech_automation/components/system_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cannasoltech_automation/components/bottom_nav_bar.dart';
import 'package:cannasoltech_automation/providers/system_data_provider.dart';
class AlarmPage extends StatefulWidget {
  const AlarmPage({super.key});
  @override
  State<AlarmPage> createState() => _AlarmPageState();
}

class _AlarmPageState extends State<AlarmPage> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Consumer<SystemDataModel>(builder: (context, value, child) => Scaffold(
      appBar: systemAppBar(context, value.activeDevice),
      body: SafeArea(
        child: Center(
          child: (value.activeDevice != null)
              ? ((value.activeDevice?.alarmLogs.logs.length ?? 0) != 0) ? ListView.builder(
                  itemCount: value.activeDevice?.alarmLogs.logs.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        title: value.activeDevice!.alarmLogs.logs[index].displayText,
                      ),
                    );
                  },
                ) : Center(
                    child: Text(
                      "Alarm Logs Empty!",
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 30,
                          color: Colors.grey.withAlpha(200)
                      )
                    )
                )
              : Column(
                  children: <Widget>[
                    SizedBox(height: screenHeight / 2.5),
                    const Text(
                      "No Device Selected!",
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
        ),
      ),
      drawer: const SideMenu(),
      bottomNavigationBar: BottomNavBar(),
    ));
  }
}
