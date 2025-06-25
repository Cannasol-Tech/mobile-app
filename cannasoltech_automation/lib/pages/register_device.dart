import 'package:cannasoltech_automation/components/side_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:provider/provider.dart';
import 'package:cannasoltech_automation/components/bottom_nav_bar.dart';
import 'package:cannasoltech_automation/providers/system_data_provider.dart';

import '../UserInterface/ui.dart';
import '../components/title_text.dart';
import '../shared/methods.dart';
import '../shared/snacks.dart';


class RegisterDevicePage extends StatefulWidget {
  
  const RegisterDevicePage({super.key, required this.title});
  final String title;
  @override
  State<RegisterDevicePage> createState() => _RegisterDevicePageState();

}

class _RegisterDevicePageState extends State<RegisterDevicePage> {


  Future<String> scanCode() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode("#ff6666", "Cancel", true, ScanMode.QR);
      return barcodeScanRes;

    } on PlatformException {
      barcodeScanRes = "Failed to scan";
      return "SCAN_ERR";
    }
  }
  void registerDevice(BuildContext context, SystemDataModel value){
    String deviceId = value.textControllers.registerDeviceController.text;
    if (context.read<SystemDataModel>().devices.doesDeviceExist(deviceId)){
      Provider.of<SystemDataModel>(context, listen: false).userHandler.watchDevice(context, deviceId);
      value.textControllers.registerDeviceController.clear();
    }
    else {
      showSnack(context, deviceDoesNotExistSnack(deviceId));
    }
  }
  @override
  Widget build(BuildContext context) {
    UI ui = userInterface(context);
    Size size = MediaQuery.of(context).size;
    dynamic value = Provider.of<SystemDataModel>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
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
        backgroundColor: Colors.grey[900],
        centerTitle: true,
        title: titleText("Register a Device", Colors.white),
      ),
        body: SafeArea(
          child: Center(
            child: Card(
              elevation: 8,
              child: Container(
                padding: const EdgeInsets.fromLTRB(32.0, 32.0, 32.0, 32.0),
                constraints: BoxConstraints(maxWidth: size.width < 350 ? 350 : size.width * 0.9, maxHeight: ui.size.displayHeight*0.9),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                        Image.asset("assets/images/SmallIcon.png"),
                        _gap(),
                        _gap(),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            "Cannasol Technologies",
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                        ),
                        _gap(),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            "Enter your device information.",
                            style: Theme.of(context).textTheme.bodySmall,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        _gap(),
                        TextFormField(
                              controller: value.textControllers.registerDeviceController,
                              decoration: const InputDecoration(
                                labelText: 'Device ID#',
                                hintText: "Enter your Devices ID #",
                                // prefixIcon: Icon(Icons.mail),
                                border: OutlineInputBorder(),
                              ),
                            ),
                        _gap(),
                      SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 15,
                              shadowColor: Colors.black,
                              backgroundColor: Colors.blueGrey,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4)),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Text(
                                'Register',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                              ),
                            ),
                            onPressed: () {
                              registerDevice(context, value);
                            },
                          ),
                        ),
                        _gap(),
                       SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 15,
                              shadowColor: Colors.black,
                              backgroundColor: Colors.blueGrey,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4)),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Text(
                                'Scan System QR Code',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                              ),
                            ),
                            onPressed: () async {
                              String deviceId = await scanCode();
                              if (!context.mounted) return;
                              if (deviceId == "SCAN_ERR" || deviceId == "-1" || deviceId == -1){
                                value.textControllers.registerDeviceController.clear();
                                showSnack(context, scanErrorSnack());
                              }
                              else{
                                value.textControllers.registerDeviceController.text = deviceId;
                                registerDevice(context, value);
                              }
                            },
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      drawer: const SideMenu(),
      bottomNavigationBar: BottomNavBar() //displayProvider: Provider.of<DisplayDataModel>, dataProvider: Provider.of<SystemDataModel>),
    );
  }
  Widget _gap() => const SizedBox(height: 16);
}
