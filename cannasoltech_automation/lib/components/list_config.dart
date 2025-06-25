import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/system_data_provider.dart';
import 'system_value_input_new.dart';



Widget listConfig(param, setter, controller, range, units) => ListTile(
      // dense: true,
      // focusNode: focus,
      title: Text('$param', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
      trailing: SysValInput(
        width: 125,
        setMethod: setter,
        controller: controller,
        minVal: range[0],
        maxVal: range[1],
        units: units,
      ),
    );

class TempVarListConfig extends StatelessWidget {
  const TempVarListConfig({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<SystemDataModel, ({TextEditingController tempThreshController})>(
      selector: (_, model) => (tempThreshController: model.textControllers.tempThreshController),
      builder: (_, data, __) {
        void Function(String) setter = context.read<SystemDataModel>().activeDevice!.config.setTempVariance;
        return listConfig(
          "Temp. Variance", 
          setter, 
          data.tempThreshController, 
          [0, 99.99], 
          "\u00B0C"
        );
      }
    );
  }
}

class MinFlowRateConfig extends StatelessWidget {
  const MinFlowRateConfig({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<SystemDataModel, ({TextEditingController flowThreshController})>(
      selector: (_, model) => (flowThreshController: model.textControllers.flowThreshController),
      builder: (_, data, __) {
        void Function(String) setter = context.read<SystemDataModel>().activeDevice!.config.setMinFlowRate;
        return listConfig(
          "Min. Flow Rate", 
          setter, 
          data.flowThreshController, 
          [0.0, 20.0], 
          "L/min"
        );
      }
    );
  }
}

class MinPressureConfig extends StatelessWidget {
  const MinPressureConfig({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<SystemDataModel, ({TextEditingController controller})>(
      selector: (_, model) => (controller: model.textControllers.pressureThreshController),
      builder: (_, data, __) {
        void Function(String) setter = context.read<SystemDataModel>().activeDevice!.config.setMinPressure;
        return listConfig(
          "Min. Pressure", 
          setter, 
          data.controller, 
          [0.0, 50.0], 
          "psi"
        );
      }
    );
  }
}

class CoolDownTempConfig extends StatelessWidget {
  const CoolDownTempConfig({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<SystemDataModel, ({
      bool enableCooldown, 
      TextEditingController controller
    })>(
      selector: (_, model) => (
        enableCooldown: model.activeDevice!.config.enableCooldown,
        controller: model.textControllers.coolDownTempController
      ),
      builder: (_, data, __) {
        void Function(String) setter = context.read<SystemDataModel>().activeDevice!.config.setCooldownTemp;
        return data.enableCooldown ? listConfig(
          "Cool Down Temp", 
          setter,
          data.controller, 
          [0.0, 99.0], 
          "\u00B0C"
        ) : Container();
      }
    );
  }
}


class SetTempListConfig extends StatelessWidget {
  const SetTempListConfig({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<SystemDataModel, ({TextEditingController controller})>(
      selector: (_, model) => (controller: model.textControllers.setTempController),
      builder: (_, data, __) {
        void Function(String) setter = context.read<SystemDataModel>().activeDevice!.config.setTemperature;
        return listConfig(
          'Set Temperature', 
          setter,
          data.controller, 
          [0, 99.99], "\u00B0C"
        );
      } 
    );
  }
}

class SetBatchSizeConfig extends StatelessWidget {
  const SetBatchSizeConfig({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<SystemDataModel, ({TextEditingController controller})>(
      selector: (_, model) => (controller: model.textControllers.batchSizeController),
      builder: (_, data, __) {
        void Function(String) setter = context.read<SystemDataModel>().activeDevice!.config.setBatchSize;
        return listConfig(
          "Set Batch Size", 
          setter, 
          data.controller, 
          [0.0, 999.99], 'L'
        );
      },
    );
  }
}
                    
