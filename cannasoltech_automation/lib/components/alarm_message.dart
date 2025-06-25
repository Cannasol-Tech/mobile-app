
// ignore_for_file: no_leading_underscores_for_local_identifiers, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../UserInterface/ui.dart';
import '../handlers/alarm_handler.dart';
import '../providers/system_data_provider.dart';
import '../shared/types.dart';
import '../providers/inline.dart';
import 'system_elements/system_element.dart';


class AlarmMessageDb {
  final AlarmMessage flowMsg, tempMsg, pressurewMsg, overloadwMsg, freqLockwMsg;
  
  AlarmMessageDb() :

    flowMsg = AlarmMessage.fromText("Flow Alarm!"),
    tempMsg = AlarmMessage.fromText("Temperature Alarm!"),
    pressurewMsg = AlarmMessage.fromText("Pressure Alarm!"),
    overloadwMsg = AlarmMessage.fromText("Overload Alarm!"),
    freqLockwMsg = AlarmMessage.fromText("Frequency Lock Alarm!");

    AlarmMessage get flow     => flowMsg;
    AlarmMessage get temp     => tempMsg;
    AlarmMessage get pressure => pressurewMsg;
    AlarmMessage get overload => overloadwMsg;
    AlarmMessage get freqLock => freqLockwMsg;  

}

List<AlarmMessage> sonicAlarmMessages() {
  AlarmMessageDb alarmDb = AlarmMessageDb();
  return [
    alarmDb.pressure, 
    alarmDb.overload, 
    alarmDb.freqLock 
  ];
}
List<AlarmMessage> pumpAlarmMessages() {
  AlarmMessageDb alarmDb = AlarmMessageDb();
  return [alarmDb.flow];
}
List<AlarmMessage> tankAlarmMessages() {
  AlarmMessageDb alarmDb = AlarmMessageDb();
  return [alarmDb.temp];
}

class AlarmMessage extends StatelessWidget {
  const AlarmMessage(this.text, this.alarmCb, this.ignAlarmCb, {super.key});
  final String text;
  final CtxCb alarmCb;
  final CtxCb ignAlarmCb;

  factory AlarmMessage.fromText(String text){
    Map<String, (CtxCb, CtxCb)> msgAlarmMap = {
        'Flow':      
          ((ctx) => sMdB.watchAlarmVar(ctx, 'flowAlarm'),
           (ctx) => sMdB.watchAlarmVar(ctx, 'ignoreFlowAlarm')),
        'Temperature':      
          ((ctx) => sMdB.watchAlarmVar(ctx, 'tempAlarm'),
           (ctx) => sMdB.watchAlarmVar(ctx, 'ignoreTempAlarm')),
        'Pressure':  
          ((ctx) => sMdB.watchAlarmVar(ctx, 'pressureAlarm'),
           (ctx) => sMdB.watchAlarmVar(ctx, 'ignorePressureAlarm')), 
        'Overload':  
          ((ctx) => sMdB.watchAlarmVar(ctx, 'overloadAlarm'),
           (ctx) => sMdB.watchAlarmVar(ctx, 'ignoreOverloadAlarm')), 
        'Frequency':
          ((ctx) => sMdB.watchAlarmVar(ctx, 'freqLockAlarm'),
           (ctx) => sMdB.watchAlarmVar(ctx, 'ignoreFreqLockAlarm')),
    };
    CtxCb almCb, ignAlmCb;
    var cbResult = msgAlarmMap.entries.firstWhere(
      (entry) => entry.key.contains(text.split(' ')[0]),
      orElse: () => const MapEntry('', (null, null))
    ).value;
    (almCb, ignAlmCb) = cbResult;
    return AlarmMessage(text, almCb, ignAlmCb);
  }

  @override
  Widget build(BuildContext context) {
    bool? alarm = alarmCb?.call(context);
    bool? ignore = ignAlarmCb?.call(context);
    bool flash = sMdB.alarmFlash(context);

    if (alarm == null || ignore == null) return const SizedBox.shrink();
    bool active = (alarm & !ignore);
    return Text(text, style: AlarmTextStyle(showText: (active & flash)));
  }
}

class AlarmMessageDisplay extends StatelessWidget {
  final SystemElement element;

  const AlarmMessageDisplay({
    required this.element,
    super.key,
  });


  @override
  Widget build(BuildContext context) {
    return Selector<SystemDataModel, AlarmsModel>(
      selector: (_, p) => (p.activeDevice?.alarms ?? AlarmsModel()), 
      builder: (xX_x, alarms, x_Xx) {
        List<AlarmMessage> alarmMessages = element.alarmMessages;
        SizedBox space = SizedBox(width: ui.size.displayWidth, height: ui.size.displayHeight * 0.2);
        List<Widget> displayWidgets = alarmMessages.expand((msg) => [space, msg]).toList();
        return Column(      
          children: displayWidgets
        );
      },
    );
  }
} 

class AlarmTextStyle extends TextStyle {
  final bool showText;
  const AlarmTextStyle({required this.showText});
  Color get onColor => ui.colors.alarm;
  Color get offColor => Colors.transparent;
  @override
  double get fontSize => 32;
  @override
  FontWeight get fontWeight => FontWeight.bold;
  @override
  Color get color => showText ? onColor : offColor;
}
