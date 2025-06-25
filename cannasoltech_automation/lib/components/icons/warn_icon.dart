
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data_models/device.dart';
import '../../providers/system_data_provider.dart';


String warnText(String paramName, minVal, maxVal, units) {
  if (minVal != null){
    return "minimum value of $minVal $units!"; 
  }
  else if (maxVal != null) {
    return "maximum value of $maxVal $units!"; 
  }
  else{
   return  "";
  }
}

Widget sysWarning(BuildContext context, String paramName, minVal, maxVal, units) {
  String warnTxt = warnText(paramName, minVal, maxVal, units);
  return AlertDialog(
    title: const Text('Warning!'),
    content: Text('$paramName is close to configured $warnTxt'),
    actions: [
      TextButton(
        child: const Text('Ok'),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    ],
  );
}

class WarnIcon extends StatelessWidget {
  final bool alarm;
  final bool warn;
  final String paramName;
  final double? minVal;
  final double? maxVal;
  final String units;

  const WarnIcon({
    super.key, // Include the key in the constructor
    required this.alarm,
    required this.warn,
    required this.paramName,
    required this.minVal,
    required this.maxVal,
    required this.units,
  });

  factory WarnIcon.noShow() {
    return const WarnIcon(
      alarm: false,
      warn: false,
      paramName: '',
      minVal: null,
      maxVal: null,
      units: '',
    );
  }

  @override
  Widget build(BuildContext context) {
    if (warn && !alarm) {
      return Padding(
        padding: const EdgeInsets.all(5.0),
        child: SizedBox(
          width: 50,
          height: 50,
          child: GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return sysWarning(context, paramName, minVal, maxVal, units);
                },
              );
            },
            child: Image.asset("assets/images/warn.png", color: Colors.yellow.shade800),
          ),
        ),
      );
    } 
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: SizedBox(
          width: 50,
          height: 50,
          child: Image.asset("assets/images/warn.png", 
          color: Colors.transparent
        )
      ),
    );
  }
}


class FlowWarnIcon extends StatelessWidget {
  const FlowWarnIcon({super.key});
  @override
  Widget build(BuildContext context) {
    return Selector<SystemDataModel, (bool, bool, double)>(
      selector: (context, systemData) => (
        (systemData.activeDevice == null) ? 
        (false, false, 0.0) : (systemData.activeDevice!.alarms.flowAlarm,
                                systemData.activeDevice!.alarms.flowWarn,
                                systemData.activeDevice!.config.flowThresh)
      ),
      builder: (context, values, child) {
        final (flowAlarm, flowWarn, flowThresh) = values;        
        return WarnIcon(
          alarm: flowAlarm,
          warn: flowWarn,
          paramName: "Flow",
          minVal: flowThresh,
          maxVal: null,
          units: "L/min",
        );
      },
    );
  }
}


class PressureWarnIcon extends StatelessWidget {
  const PressureWarnIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<SystemDataModel, (bool, bool, double)>(
      selector: (context, systemData) => (
        (systemData.activeDevice == null) ? 
        (false, false, 0.0) : (systemData.activeDevice!.alarms.pressureAlarm,
                                systemData.activeDevice!.alarms.pressureWarn,
                                systemData.activeDevice!.config.pressureThresh)
      ),
      builder: (context, values, child) {
        final (pressureAlarm, pressureWarn, pressureThresh) = values;        
        return WarnIcon(
          alarm: pressureAlarm,
          warn: pressureWarn,
          paramName: "Pressure",
          minVal: pressureThresh,
          maxVal: null,
          units: "psi",
        );
      },
    );
  }
}


class TempWarnIcon extends StatelessWidget {
  const TempWarnIcon({super.key});

  double? minVal(device, temp, setTemp, tempThresh) => (
    (device != null) && (temp < setTemp) ? setTemp - tempThresh : null
  );

  double? maxVal(device, temp, setTemp, tempThresh) => (
    (device != null) && (temp > setTemp) ? setTemp + tempThresh : null
  );

  @override
  Widget build(BuildContext context) {
    return Selector<SystemDataModel, (bool, bool, double, double)>(
      selector: (context, systemData) => (
        (systemData.activeDevice == null) ? 
        (false, false, 0.0, 0.0) : (systemData.activeDevice!.alarms.tempAlarm,
                                systemData.activeDevice!.alarms.tempWarn,
                                systemData.activeDevice!.config.tempThresh,
                                systemData.activeDevice!.config.setTemp)
      ),

      builder: (context, values, child) {
      final (tempAlarm, tempWarn, tempThresh, setTemp) = values;  
      Device? activeDevice = context.read<SystemDataModel>().activeDevice;
        return WarnIcon(
          alarm: tempAlarm,
          warn: tempWarn,
          paramName: "Temperature",
          minVal: minVal(activeDevice, activeDevice?.state.temperature, setTemp, tempThresh),
          maxVal: maxVal(activeDevice, activeDevice?.state.temperature, setTemp, tempThresh),
          units: "\u2103"
        );
      },
    );
  }
}


Widget getWarnIcon(context, activeDevice, sysElement) {
  return (sysElement.type == "Tank") ? const TempWarnIcon()
      : (sysElement.type == "Flow") ? const FlowWarnIcon()
      : (sysElement.type == "Air") || (sysElement.type.contains("Sonic")) ? const PressureWarnIcon() 
      : Container();
}
