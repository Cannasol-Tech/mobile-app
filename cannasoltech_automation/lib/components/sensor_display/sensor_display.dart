import '../../UserInterface/ui.dart';
import '../../providers/inline.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../handlers/alarm_handler.dart';
import '../../handlers/state_handler.dart';
import '../../providers/system_data_provider.dart';
import '../icons/warn_icon.dart';

abstract class SensorDisplay extends StatelessWidget with SensorDisplayDesign {
  const SensorDisplay({super.key,}); 
  abstract final String units;

  abstract final Widget warnIcon;
  abstract final bool Function(AlarmsModel) warnCb;
  abstract final bool Function(AlarmsModel) alarmCb;
  abstract final String Function(StateHandler) valCb;

  @override
  Widget build(BuildContext context) {
    UI ui = userInterface(context);
    return Selector<SystemDataModel, ({bool warn, bool alarm, String val})>(
      selector: (_, model) => (
        warn: warnCb(model.activeDevice?.alarms ?? AlarmsModel()),
        alarm: alarmCb(model.activeDevice?.alarms ?? AlarmsModel()),
        val: valCb(model.activeDevice?.state ?? StateHandler()),
      ),
      builder: (_x, data, x_) { 
        final bool warn = data.warn;
        final bool alarm = data.alarm;
        final String val = data.val;

    if (!sMdB.deviceIsActive(context)) {return const SizedBox.shrink();}
        return Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              WarnIcon.noShow(),
              Container(
                constraints: BoxConstraints.loose(
                  Size(ui.size.boxWidth, ui.size.boxHeight)
                ),
                decoration: decor(boxColor(alarm, warn)),
                alignment: Alignment.center,
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: SensorDisplayText(
                    val: val, 
                    units: units
                  ),
              ),
            ),
            warnIcon,
            const Spacer(),
          ]),
        );
      }
    );
  }
}


mixin SensorDisplayDesign on StatelessWidget {
  Color get warnColor => ui.colors.alphaWarn(225);
  Color get alarmColor => ui.colors.alphaAlarm(200);
  Color get noAlarmColor => ui.colors.noAlarm;
  Color Function(bool, bool) get boxColor => (alarm, warn) => alarm ? alarmColor : warn ? warnColor : noAlarmColor;
  BoxDecoration Function(Color) get decor => (boxColor) => 
  BoxDecoration(
    color: boxColor,
    border: Border.all(
      color: Colors.black,
      style: BorderStyle.solid,
      width: 3.0,
    )
  );
}

class SensorDisplayText extends StatelessWidget {
  const SensorDisplayText({super.key, 
                          required this.val, 
                          required this.units});

  final String val;
  final String units;

  @override
  Widget build(BuildContext context) {
    final TextStyle? theme = Theme.of(context).textTheme.headlineMedium;
    return Text("$val $units", style: theme);
  }
}
