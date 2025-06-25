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
            // if (_displayedTaC == true) {
              setState(() => _displayedTaC = false);
            // }
          });
        }
        // if (needsAcceptTac == false && _displayedTaC == true) {
        //   WidgetsBinding.instance.addPostFrameCallback((_) {
        //     setState(() {
        //     _acceptedCount += 1;
        //     if (_acceptedCount == 4){
        //       _displayedTaC = false;
        //     }
        //   });
        //   });
        // }
        return context.read<SystemDataModel>().currentRunPage;
      }
      else { 
        return const LoginOrRegisterPage();
      }
    });
  }
}

