// ignore_for_file: no_leading_underscores_for_local_identifiers
import 'package:cannasoltech_automation/providers/system_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../UserInterface/ui.dart';
import '../../shared/constants.dart';
import 'confirm_button.dart';


class ResumeButton extends StatelessWidget {
  const ResumeButton({super.key});
  @override
  Widget build(BuildContext context) {
    UI ui = userInterface(context);
    return Selector<SystemDataModel, ({int state, bool cleared})>(
      selector: (_, p) => (state: p.activeDevice!.state.state, cleared: p.activeDevice!.state.alarmsCleared),
      builder: (_x, data, x_) {
        if (data.state == ALARM && data.cleared) {
              return SizedBox(
                width: ui.size.bottomButtonWidth,
                height: ui.size.bottomButtonHeight,
                child: ConfirmButton(
                  color: const Color.fromARGB(95, 3, 251, 197),
                  shadowColor: const Color.fromARGB(255, 2, 99, 78),
                  confirmMethod: context.read<SystemDataModel>().activeDevice?.config.resumeRun as Function,
                  confirmText: 'wish to resume',
                  buttonText: 'Resume',
                  hero: 'resumeRunBtn',
                )
              );
            } 
            else {
              return Container();
            }
      }
    );
  }
}
