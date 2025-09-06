import '../../main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../dialogs/terms_and_conditions.dart';
import '../../providers/system_data_provider.dart';
import 'package:cannasoltech_automation/pages/login_or_reg_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});


  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _displayedTaC = false;

  @override
  Widget build(BuildContext context) {
    return Selector<SystemDataModel, bool>(
      selector: (_, p) => (p.needsAcceptTaC),
      builder: (xX_x, needsAcceptTac, x_Xx) {
        // For development, always show login page first
        // This bypasses Firebase authentication issues
        try {
          final CurrentUser user = context.watch<CurrentUser>();
          final bool loggedIn = user != null;

          if (loggedIn) {
            if (needsAcceptTac && _displayedTaC == false) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() => _displayedTaC = true);
                Navigator.of(context).popUntil(ModalRoute.withName('/'));
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return const TaCDialog();
                  },
                );
              });
            }
            if (needsAcceptTac == false && _displayedTaC == true) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() => _displayedTaC = false);
              });
            }
            return context.read<SystemDataModel>().currentRunPage;
          }
          else {
            return const LoginOrRegisterPage();
          }
        } catch (e) {
          // If there's any error with authentication, show login page
          print('Authentication error: $e');
          return const LoginOrRegisterPage();
        }
    });
  }
}

