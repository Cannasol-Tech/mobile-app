
import 'package:cannasoltech_automation/providers/system_data_provider.dart';
import 'package:cannasoltech_automation/providers/display_data_provider.dart';
import 'package:cannasoltech_automation/shared/maps.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../pages/home/run_page.dart';
import '../shared/methods.dart';




class AlarmNotification {
  String alarmName;
  late String deviceName;
  String? deviceId;
  AlarmNotification({required this.deviceId, required this.alarmName}){
    alarmName = alarmToNameMap[alarmName]!;
  }

  MaterialBanner materialBanner() { 
    String deviceName = Provider.of<SystemDataModel>(navigatorKey.currentContext!, listen: false).devices.getNameFromId(deviceId!).toString();
    return MaterialBanner(
      leading: const Icon(Icons.warning_outlined, size: 35.0),
      content: Text("${alarmName.toCapital()} on $deviceName!"),
      contentTextStyle: const TextStyle(color: Colors.white60, fontWeight: FontWeight.bold), 
      backgroundColor: const Color.fromARGB(190, 155, 25, 11),
      elevation: 20,
      shadowColor: Colors.black,
      actions: <Widget> [
        SnackBarAction(
          label: "VIEW",
          onPressed: () {
            SystemDataModel data = Provider.of<SystemDataModel>(navigatorKey.currentContext!, listen: false);
            data.setSelectedDeviceFromName(deviceName);
            scaffoldMessengerKey.currentState?.hideCurrentMaterialBanner();
            navigatorKey.currentContext?.read<DisplayDataModel>().setBottomNavSelectedItem(0);
            if (alarmName.contains('Flow')){
              navigatorKey.currentState?.pushReplacement(MaterialPageRoute(builder: (context) {
              Future.microtask(() => navigatorKey.currentContext?.read<SystemIdx>().set(1)  );
             
                return const RunPage();
              }));
            }
            else if (alarmName.contains('Temperature')){
              navigatorKey.currentState?.pushReplacement(MaterialPageRoute(builder: (context) { 
                Future.microtask(() => navigatorKey.currentContext?.read<SystemIdx>().set(2)  );
                return const RunPage();
              }));
            }
            else {
              navigatorKey.currentState?.pushReplacement(MaterialPageRoute(builder: (context) {
              Future.microtask(() => navigatorKey.currentContext?.read<SystemIdx>().set(0));
              return const RunPage();
              }));
            }
          },
        ),
        SnackBarAction(
          label: "DISMISS",
          onPressed: () {
            scaffoldMessengerKey.currentState?.hideCurrentMaterialBanner();
          }  
        ),
      ]
    );
  }

  String? getIgnAlarmName(String alarmName){
    if (alarmName.contains('Flow')){return 'ign_flow_alarm';}
    if (alarmName.contains('Temperature')){return 'ign_temp_alarm';}
    if (alarmName.contains('Pressure')){return 'ign_pressure_alarm';}
    if (alarmName.contains('Overload')){return 'ign_overload_alarm';}
    if (alarmName.contains('Frequency')){return 'ign_freqlock_alarm';}
    return null;
  }

  void showAlarmBanner() { 
    scaffoldMessengerKey.currentState?.clearMaterialBanners();
    scaffoldMessengerKey.currentState?.showMaterialBanner(materialBanner());
  }
}

class ClearedAlarmNotification{
  String alarmName = "";
  String? deviceId;
  ClearedAlarmNotification({required this.deviceId, required this.alarmName}){
    alarmName = alarmToNameMap[alarmName]!;
  }

  MaterialBanner materialBanner() {
    String? deviceName = navigatorKey.currentContext?.read<SystemDataModel>().devices.getNameFromId(deviceId);
    return MaterialBanner(
      content: Text("Cleared $alarmName on Device: ${deviceName ?? ''}!"),
      contentTextStyle: const TextStyle(color: Colors.white60, fontWeight: FontWeight.bold), 
      backgroundColor: const Color.fromARGB(175, 25, 91, 11),
      elevation: 20,
      shadowColor: Colors.black,
      actions: <Widget> [
        SnackBarAction(
          label: "OK",
          onPressed: () {
            scaffoldMessengerKey.currentState?.hideCurrentMaterialBanner();
        }  
      ),
      ]
    );
  }
  
  
  Future<void> showAlarmBanner() async {  
    await Future.delayed(Duration.zero);
      // ignore: use_build_context_synchronously
      scaffoldMessengerKey.currentState?.showMaterialBanner(materialBanner());
      // showSnack(context, deviceAlarmSnack(this));
  }
}
