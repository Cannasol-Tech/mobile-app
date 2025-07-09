import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/system_data_provider.dart';
import 'package:cannasoltech_automation/controllers/toggle_controllers.dart';

class PumpControlConfig extends StatelessWidget {
  const PumpControlConfig({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<SystemDataModel, ToggleController>(
      selector: (_, p) => (p.toggleControllers.pumpControl),
      builder: (_x_x, pumpControl, x_x_) {
        bool pumpValue = context.watch<SystemDataModel>().activeDevice?.config.pumpControl ?? false;
        void Function(bool) setter = context.read<SystemDataModel>().activeDevice!.config.setPumpControl;
        return SwitchListTile(
          contentPadding: const EdgeInsets.fromLTRB(0, 0, 50, 0),
          dense: true,
          title: const Text('    Pump Control', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          value: (context.read<SystemDataModel>().activeDevice != null) ? pumpControl.value : false,
          onChanged: (swValue) {
            pumpControl.toggle();
            setter(swValue);
          },
        );
      },
    );
  }
}
