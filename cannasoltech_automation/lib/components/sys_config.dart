
import 'package:flutter/material.dart';
import 'dropdown_menu.dart';
import 'list_config.dart';
import 'set_time_config.dart';

List<Widget> sysConfigHeader()  => [ 
    _gap(),
    Image.asset("assets/images/SmallIcon.png", height: 50.0, width: 50.0), 
    _gap(),
    const Text("System Configuration",
      style: TextStyle(
        fontWeight: FontWeight.bold,
        decoration: TextDecoration.underline,
        fontSize: 20,
    ),), 
    _gap(), dropDownDivider,
  ];

  sysConfigList(value) => [
    const SetTimeConfig(),      dropDownDivider,
    const SetTempListConfig(),  dropDownDivider,
    const SetBatchSizeConfig(), dropDownDivider,
    const MinFlowRateConfig(),  dropDownDivider,
    const MinPressureConfig(),  dropDownDivider,
    const TempVarListConfig(),
    value.activeDevice!.config.enableCooldown ? 
    dropDownDivider : Container(child: null),
    const CoolDownTempConfig(), dropDownDivider
  ];

  Widget switchConfig(label, controller, setter) =>  
    SwitchListTile(
      dense: true,
      contentPadding: const EdgeInsetsDirectional.only(end: 45.0),
      // activeTrackColor: Color.fromARGB(174, 12, 63, 2),
      title: Text('   $label', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        value: controller.value,
        onChanged: (swValue) {
          controller.value = swValue;
          setter(swValue);
        }
      );

  sysToggleList(value) => [
    switchConfig('Cooldown Enable', 
      value.toggleControllers.enableCooldown, 
      value.activeDevice?.config.setEnableCoolDown
    ), dropDownDivider,
    switchConfig('Ignore Temp Alarm', 
      value.toggleControllers.ignTempAlarm, 
      value.activeDevice?.alarms.setIgnoreTempAlarm
    ), dropDownDivider,
    switchConfig('Ignore Flow Alarm', 
      value.toggleControllers.ignFlowAlarm, 
      value.activeDevice?.alarms.setIgnoreFlowAlarm
    ), dropDownDivider,
    switchConfig('Ignore Pressure Alarm', 
      value.toggleControllers.ignPressureAlarm, 
      value.activeDevice?.alarms.setIgnorePressureAlarm
    ), dropDownDivider,
    switchConfig('Ignore Freq. Lock Alarm', 
      value.toggleControllers.ignFreqLockAlarm,
      value.activeDevice?.alarms.setIgnoreFreqLockAlarm
    ), dropDownDivider,
    switchConfig('Ignore Overload Alarm', 
      value.toggleControllers.ignOverloadAlarm,
      value.activeDevice?.alarms.setIgnoreOverloadAlarm
    ), dropDownDivider,
  ];

Widget _gap() => const SizedBox(height: 16);
