import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cannasoltech_automation/components/side_menu.dart';
import 'package:cannasoltech_automation/handlers/history_logs.dart';
import 'package:cannasoltech_automation/components/system_app_bar.dart';
import 'package:cannasoltech_automation/components/bottom_nav_bar.dart';
import 'package:cannasoltech_automation/providers/system_data_provider.dart';

import '../UserInterface/ui.dart';

class LogHistoryPage extends StatefulWidget {
  const LogHistoryPage({super.key});
  @override
  State<LogHistoryPage> createState() => _LogHistoryPageState();
}

class _LogHistoryPageState extends State<LogHistoryPage> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    UI ui = userInterface(context);
    List<HistoryLog>? sortedLogs = context
        .watch<SystemDataModel>()
        .activeDevice
        ?.history
        .logs
      ?..sort((a, b) => a.index.compareTo(b.index));
    return Consumer<SystemDataModel>(
        builder: (context, value, child) => Scaffold(
              appBar: logPageAppBar(context, value.activeDevice),
              body: SafeArea(
                child: SingleChildScrollView(
                  child: Center(
                    child: (value.activeDevice != null)
                        ? ((value.activeDevice?.history.logs.length ?? 0) != 0)
                            ? Column(children: [
                                ConstrainedBox(
                                    constraints: BoxConstraints.loose(Size(
                                        ui.size.displayWidth,
                                        ui.size.displayHeight - 200)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: ListView.builder(
                                          itemCount: value.activeDevice?.history
                                              .logs.length,
                                          itemBuilder: (context, index) {
                                            return Card(
                                              child: ListTile(
                                                title: sortedLogs?[index]
                                                        .displayText ??
                                                    const Text("N/A"),
                                                onTap: () => sortedLogs?[index]
                                                    .showLogDialog(context),
                                              ),
                                            );
                                          }),
                                    )),
                                ElevatedButton(
                                    style: ButtonStyle(
                                      shape: WidgetStateProperty.all<
                                              RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      )),
                                      elevation:
                                          WidgetStateProperty.all<double>(12.0),
                                      alignment: Alignment.center,
                                      shadowColor:
                                          WidgetStateProperty.all<Color>(
                                              Colors.black.withAlpha(200)),
                                      backgroundColor:
                                          WidgetStateProperty.all<Color>(
                                              Colors.white.withAlpha(50)),
                                    ),
                                    onPressed: () => value.activeDevice
                                        ?.clearDeviceLogHistory(context),
                                    child: Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: SizedBox(
                                          width: ui.size.displayWidth / 2,
                                          child: Text("Clear LOG History",
                                              style: TextStyle(
                                                color: Colors.blue.shade900
                                                    .withAlpha(140),
                                                fontSize: 18,
                                                // fontWeight: FontWeight.bold
                                              ),
                                              textAlign: TextAlign.center)),
                                    ))
                              ])
                            : Center(
                                child: Text("Device Logs Empty!",
                                    style: TextStyle(
                                        fontStyle: FontStyle.italic,
                                        fontSize: 30,
                                        color: Colors.grey.withAlpha(200))))
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
              ),
              drawer: const SideMenu(),
              bottomNavigationBar: BottomNavBar(),
            ));
  }
}
