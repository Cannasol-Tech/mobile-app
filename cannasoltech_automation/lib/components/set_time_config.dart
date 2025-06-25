import 'package:provider/provider.dart';

import '../providers/system_data_provider.dart';
import 'time_input.dart';
import 'package:flutter/material.dart';

class SetTimeConfig extends StatelessWidget {
  const SetTimeConfig({super.key});
  @override
  Widget build(BuildContext context) {
    return Selector<SystemDataModel, TextEditingController>(
      selector: (_, data) => data.textControllers.setTimeController,
      builder: (_, controller, __) {
        return ListTile(
          title: const Text('Set Run Time', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          trailing: DurationInputWidget(
            labelText: "Set Time",
            controller: controller,
            width: 125,
            onDurationChanged: (Duration duration) {
              if (context.read<SystemDataModel>().activeDevice != null) {
                context.read<SystemDataModel>().activeDevice?.config.setSetTime(duration);
              }
            },
          ),
        );
      }
    );
  }
}