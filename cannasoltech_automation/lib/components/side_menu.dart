/**
 * @file side_menu.dart
 * @author Stephen Boyett
 * @date 2025-09-06
 * @brief Side navigation menu with animated components and user options.
 * @details Provides side drawer navigation with animated spin card, device selection,
 *          user settings, and various application options and links.
 * @version 1.0
 * @since 1.0
 */

import 'package:cannasoltech_automation/providers/display_data_provider.dart';
import 'package:cannasoltech_automation/components/sign_out_button.dart';
import 'package:cannasoltech_automation/components/dropdown_menu.dart';
import 'package:cannasoltech_automation/pages/register_device.dart';
import 'package:cannasoltech_automation/pages/settings_page.dart';
import 'package:cannasoltech_automation/shared/constants.dart';
import '../providers/system_data_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/transform_provider.dart';
import '../dialogs/terms_and_conditions.dart';
import 'package:provider/provider.dart';
import '../dialogs/privacy_policy.dart';
import 'package:flutter/material.dart';
import '../handlers/user_handler.dart';
import 'buttons/confirm_button.dart';
import 'buttons/page_button.dart';

/**
 * @brief Animated spinning card component for side menu.
 * @details Stateless widget that creates an animated gradient card with
 *          rotation effects using the TransformModel provider.
 * @since 1.0
 */
class SpinCard extends StatelessWidget {
  /**
   * @brief Creates a SpinCard widget.
   * @param key Optional widget key for identification
   */
  const SpinCard({super.key});

  /**
   * @brief Builds the animated spinning card widget.
   * @details Creates a container with animated gradient background that
   *          rotates based on the TransformModel state.
   * @param context Build context for the widget
   * @return Widget representing the animated spin card
   * @since 1.0
   */
  @override
  Widget build(BuildContext context) {
          return Consumer<TransformModel>(builder: (context, value, child) => Container(
                  decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                            gradient: LinearGradient(
                              transform: GradientRotation(value.rotateFactor/64),
                              colors: const [
                              Color.fromARGB(255, 150, 207, 245),
                              Color.fromARGB(255, 24, 128, 203),
                              Color.fromARGB(255, 17, 82, 128),
                              Color.fromARGB(255, 6, 38, 61),
                              Color.fromARGB(255, 17, 82, 128),
                              Color.fromARGB(255, 24, 128, 203),
                              Color.fromARGB(255, 150, 207, 245),
                            ], begin: Alignment.topLeft, end: Alignment.bottomRight),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.grey,
                                blurRadius: 12,
                                offset: Offset(0, 6),
                              ),
                            ],
                          ),
                  child: Image.asset("assets/images/SmallIcon.png"),
          )
        );
    }
  }

Text getUser(context, userInfo) {
    String? userName = userInfo.name;
    String? email = userInfo.email;
    return Text(
      (userName == null) ? ((email == null) ? "" : email.toString()) : userName.toString(),
      textAlign: TextAlign.center,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 26,
        fontWeight: FontWeight.bold,
        // fontStyle: FontStyle.italic,
      ),
    );  
  }


class SideMenu extends StatefulWidget {

  const SideMenu({super.key});

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {

  String deviceToRemove = 'None';

  void setDeviceToRemove(String deviceName) {
    setState(() {deviceToRemove = deviceName;});
  }

  removeDevice() async {
    
    UserHandler userHandler = Provider.of<SystemDataModel>(context, listen: false).userHandler;
    String? deviceId = context.read<SystemDataModel>().devices.nameIdMap[deviceToRemove];
    if (userHandler.selectedDevice == deviceId){
      await userHandler.removeSelectedDevice();
    }
    setState(() {
      deviceToRemove = 'None';
    });
    // ignore: use_build_context_synchronously
    Provider.of<SystemDataModel>(context, listen: false).userHandler.unWatchDevice(deviceId??='None');
  }

  Widget userHeader(SystemDataModel value) => SizedBox( 
                                                height: 125, 
                                                child: DrawerHeader(
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey.shade900,
                                                  ),
                                                  child: getUser(context, value.userHandler),
                                                )
                                              );

  @override
  Widget build(BuildContext context) {
      return  Consumer<SystemDataModel> (
        builder: (BuildContext context, value, Widget? child) { 
        Map<String, TextStyle> styleMap = {};
        Map<String, String> deviceStatusMap = Provider.of<SystemDataModel>(context, listen: true).registeredDeviceStatus;
        for (var entry in deviceStatusMap.entries){
            styleMap[entry.key] = TextStyle(color: (entry.value == "ONLINE") ? Colors.green : Colors.red);
        }
        return Drawer(
          backgroundColor: Color.alphaBlend (const Color.fromARGB(30, 0, 20, 0),
           const Color.fromARGB(255, 255, 255, 255)),
          child: Stack(
            children: [
              ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  userHeader(value),
                  ListTile(
                    leading: const Icon(Icons.app_registration),
                    title: const Text('Register a device', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    onTap: () {
                      Provider.of<DisplayDataModel>(context, listen: false).setBottomNavSelectedItem(-1);
                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const RegisterDevicePage(title: "Register a Device")));
                    },
                  ),
                  dropDownDivider,
                  const ListTile(
                    leading: Icon(Icons.list),
                    dense: true,
                    title: Text('Select Device: ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                  deviceDropDown(value, styleMap, value.userHandler.selectedDevice, Provider.of<SystemDataModel>(context, listen: false).setSelectedDeviceFromName),
                  dropDownDivider,
                  const ListTile(
                      leading: Icon(Icons.list),
                      dense: true,
                      title: Text('Remove Device: ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  deviceDropDown(value, styleMap, deviceToRemove, setDeviceToRemove),
                  // dropDownDivider,
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 35,
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0), 
                      child: ConfirmButton(
                        color: originalConfirmButtonColor.withAlpha(30),
                        confirmMethod: removeDevice,
                        confirmText: "remove $deviceToRemove from the list of registered devices",
                        buttonText: "Remove",
                        hero: "removeDeviceBtn",
                      )
                    ),
                  ),
                  const SizedBox(height: 10),
                  dropDownDivider,
                  const SizedBox(height: 5),
                  SizedBox(
                    height: 35,
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0), 
                      child: PageButton(
                        hero: "AccountSettingsBtn",
                        color: originalConfirmButtonColor.withAlpha(35),
                        buttonText: "Account Settings",
                        newPage: const SettingsPage(),
                        pop: true,
                      )
                    ),
                  ),
                  const SizedBox(height: 5),
                  const SizedBox(height: 5),
                  SizedBox(
                    height: 35,
                    child: Container(padding: const EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0), child: signOutButton(context, const Color.fromARGB(255, 174, 12, 0), "Sign Out", "signOutBtn")),
                  ),
                  const SizedBox(height: 5),
                  dropDownDivider,
                  GestureDetector(
                    child: const ListTile(
                      contentPadding: EdgeInsets.fromLTRB(50, 0, 50, 0),
                      leading: Icon(
                        Icons.shopping_cart_outlined,
                        color: Colors.black
                      ),
                      title: Text('Cannasol Store', 
                        textAlign: TextAlign.left,
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    ),
                    onTap: () async {
                      Uri url = Uri.parse('https://cannasoltechnologies.com/shop');  
                      launchUrl(url);
                    }
                  ),
                  dropDownDivider,
                  // const Expanded(child: Column(children: [SizedBox(width: 10)])),
                ],
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 14.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                    DocumentLinks(),
                    Padding(
                      padding: EdgeInsets.only(bottom: 20.0, left: 20),
                      child: Text('\u00A9 Cannasol Technologies, 2025', 
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 9
                        )
                      ),
                    )
                  ],
                ),
              )
            ]
          ),
        );
      },
    );
  }
}

class DocumentLinks extends StatelessWidget {
  const DocumentLinks({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextButton(
          child: const Text(
          'Privacy Policy', 
            style: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold, fontSize: 12
            )
          ),
          onPressed: () =>  showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => const PrivacyPolicyDialog(),
          )
        ),
        const Text('|', 
          style: TextStyle(
            color: Colors.blue,
            fontSize: 10
          )
        ),
        TextButton(
          child: const Text(
          'Terms of Use', 
            style: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold, 
              fontSize: 12
            )
          ),
          onPressed: () => showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => const TaCDialog(needsAccept: false,)
            )
          )
      ],
    );
  }
}


/*  This is the old spin card

 const Card(
                        child: SpinCard(),
                        ),

*/
