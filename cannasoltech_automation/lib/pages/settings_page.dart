/**
 * @file settings_page.dart
 * @author Stephen Boyett
 * @date 2025-09-06
 * @brief User settings and preferences management page.
 * @details Provides user interface for managing application settings,
 *          user preferences, device selection, and account management.
 * @version 1.0
 * @since 1.0
 */

import 'package:cannasoltech_automation/components/side_menu.dart';
import 'package:cannasoltech_automation/components/system_app_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cannasoltech_automation/components/bottom_nav_bar.dart';
import 'package:cannasoltech_automation/providers/system_data_provider.dart';
import '../UserInterface/ui.dart';
import '../components/dropdown_menu.dart';
import '../shared/methods.dart';
import '../shared/snacks.dart';
import 'reset_password.dart';

/**
 * @brief Settings page for user preferences and account management.
 * @details Stateful widget providing interface for user settings including
 *          device selection, notifications, and account management options.
 * @since 1.0
 */
class SettingsPage extends StatefulWidget {
  /**
   * @brief Creates a SettingsPage widget.
   * @param key Optional widget key for identification
   */
  const SettingsPage({super.key});

  /**
   * @brief Creates the state for SettingsPage widget.
   * @return _SettingsPageState instance
   */
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

/**
 * @brief State class for SettingsPage widget.
 * @details Manages settings page state, user preferences, and UI interactions
 *          for configuration and account management.
 * @since 1.0
 */
class _SettingsPageState extends State<SettingsPage> {

  /// Current authenticated user from Firebase Auth
  var currentUser = FirebaseAuth.instance.currentUser;

  /**
   * @brief Toggle function for settings switches.
   * @details Placeholder toggle function for various settings options.
   * @return bool Always returns true
   * @since 1.0
   */
  bool toggle(){
    return true;
  }

  @override
  Widget build(BuildContext context) {
    UI ui = userInterface(context);
    // context.watch<SystemDataModel>().alarmHandler.notifications;
    // Provider.of<SystemDataModel>(context, listen: false).alarmHandler.showAlarmBanners(context);
     return Consumer<SystemDataModel> (builder: (context, value, child) =>  Scaffold(
      appBar:systemAppBar(context, value.activeDevice),
      body: SafeArea(
        child: Center(
          child: Card(
            // color: Colors.grey,
            shadowColor: Colors.black,
            elevation: 8,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.90,
              height: MediaQuery.of(context).size.height * 0.70,
              constraints: BoxConstraints(
                maxWidth: ui.size.maxWidth, 
                maxHeight: MediaQuery.of(context).size.height*0.9
              ),
              child: SingleChildScrollView(
                child: Column(
                  // mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                      Image.asset("assets/images/SmallIcon.png"),
                      _gap(),
                      _gap(),
                        Text(
                          currentUser!.email.toString(),
                          style: Theme.of(context).textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                      _gap(),
                      dropDownDivider,
                      ListTile(
                        dense: true,
                        leading: const Icon(Icons.email),
                        trailing: value.userHandler.isEmailVerified()? const Icon(Icons.check, color: Colors.green) : const Icon(Icons.close, color:Colors.red),
                        title: const Text('Verify Email', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                        onTap: () {
                          if (value.userHandler.isEmailVerified() == false){
                            Provider.of<SystemDataModel>(context, listen: false).userHandler.verifyEmail();
                            showSnack(context, veirifcationSentSnack(value.userHandler.email));
                          }
                          else {
                            showSnack(context, emailVerifiedSnack);
                          }
                        },
                      ),
                    dropDownDivider,
                    SwitchListTile(
                      dense: true,
                      shape: const CircleBorder(eccentricity: 0.1 ),
                      enableFeedback: false,
                      activeColor: const Color.fromARGB(150, 255, 255, 255),
                      activeTrackColor: const Color.fromARGB(174, 7, 85, 7),
                      inactiveTrackColor: const Color.fromARGB(74, 25, 23, 23),
                      inactiveThumbColor: const Color.fromARGB(223, 255, 255, 255),
                      title: const Row( children: [Icon(Icons.info), Text('   Email Alert on Alarm', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))]),
                        value: Provider.of<SystemDataModel>(context, listen: false).userHandler.emailOnAlarm,
                        onChanged: (swValue) {
                          if (value.userHandler.isEmailVerified() == true){
                            Provider.of<SystemDataModel>(context, listen: false).userHandler.emailAlertOnAlarm(swValue);
                        }
                          else {
                            showSnack(context, pleaseVerifyEmailSnack);
                          }
                        }
                      ),
                    dropDownDivider,
                      ListTile(
                        // leading: const Icon(Icons.email),
                        dense: true,
                        leading: const Icon(Icons.key),
                        title: const Text('Reset Password', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                        onTap: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ResetPasswordPage()));
                        },
                      ),
                    dropDownDivider,
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      drawer: const SideMenu(),
      bottomNavigationBar: BottomNavBar() //displayProvider: Provider.of<DisplayDataModel>, dataProvider: Provider.of<SystemDataModel>),
    ));
  }
  Widget _gap() => const SizedBox(height: 16);

}