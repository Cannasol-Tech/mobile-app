 import 'package:cannasoltech_automation/providers/system_data_provider.dart';
import 'package:cannasoltech_automation/shared/time.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../handlers/alarm_handler.dart';
import '../handlers/alarm_logs.dart';
import '../shared/constants.dart';

setTempColor(deviceState) {
  if (deviceState == COOL_DOWN) {
    return Colors.blue[800];
  }
  return Colors.black;
}

Widget runStat({String statText = '', Color color = Colors.black, padding = const EdgeInsetsDirectional.only(end: 5.0)}) => 
  Container(
      // color: Color.fromARGB(20, 0, 255, 0),
      padding: padding,
      alignment: Alignment.topRight, 
      child: Text(
        statText,
        style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: color
              ),
      ),
    );

  Widget redStat({String statText = ''}) => runStat(statText: statText, color: Colors.red);

class AlarmTime extends StatefulWidget {
  final AlarmLog alarmLog;

  const AlarmTime({super.key, required this.alarmLog});

  @override
  State<AlarmTime> createState() => _AlarmTimeState();
}

class _AlarmTimeState extends State<AlarmTime> {
  Duration alarmDuration = Duration.zero;


  @override
  Widget build(BuildContext context) {
    return alarmDuration.inSeconds > 0 ? redStat(statText: 
    formatDuration(alarmDuration)) : Container();
  }
}

  class LandScapeRunStats extends StatelessWidget {

    const LandScapeRunStats({super.key});

    @override
    Widget build(BuildContext context) {
      if (context.read<SystemDataModel>().activeDevice == null) {return Container();}
      context.watch<SystemDataModel>().activeDevice!.state.runSeconds;
      String runTime = context.watch<SystemDataModel>().activeDevice!.state.runTime;
      String setTime = context.watch<SystemDataModel>().activeDevice!.config.setTime;
      double currSetTemp = context.watch<SystemDataModel>().activeDevice!.config.currSetTemp;
      int state = context.watch<SystemDataModel>().activeDevice!.state.state;
      return Row(
        children: [
          runStat(statText: "Run Time: $runTime", padding: const EdgeInsets.only(left: 5.0),),
          const Spacer(), 
          runStat(statText: "Set Time: $setTime:00"),
          const Spacer(),
          runStat(statText: "Set Temp: $currSetTemp \u2103", color: setTempColor(state),),
        ],
      );
    }
  }
    
  class PortraitRunStats extends StatelessWidget {
    const PortraitRunStats({super.key});

    @override
    Widget build(BuildContext context) {
      if (context.read<SystemDataModel>().activeDevice == null) {return Container();}
      int state = context.watch<SystemDataModel>().activeDevice!.state.state; 
      String runTime = context.watch<SystemDataModel>().activeDevice!.state.runTime;
      String setTime = context.watch<SystemDataModel>().activeDevice!.config.setTime;
      double currSetTemp = context.watch<SystemDataModel>().activeDevice!.config.currSetTemp;
      AlarmsModel alarms = context.watch<SystemDataModel>().activeDevice!.alarms;
      return Column(
      children: [
        runStat(statText: "Run Time: $runTime"),
        runStat(statText: "Set Time: $setTime:00"),
        runStat(statText: "Set Temp: $currSetTemp \u2103", color: setTempColor(state)),
        (alarms.flowAlarm == true) && (alarms.flowAlarmTime != null) ?
        redStat(statText: "Flow Alarm: ${formatDuration(alarms.flowAlarmTime ?? Duration.zero)}") : Container(),
        (alarms.tempAlarm == true) && (alarms.tempAlarmTime != null) ?
        redStat(statText: "Temp Alarm: ${formatDuration(alarms.tempAlarmTime ?? Duration.zero)}") : Container(),
        (alarms.pressureAlarm == true) && (alarms.pressureAlarmTime != null) ?  
        redStat(statText: "Pressure Alarm: ${formatDuration(alarms.pressureAlarmTime ?? Duration.zero)}") : Container(),
        (alarms.overloadAlarm == true) && (alarms.overloadAlarmTime != null) ?  
        redStat(statText: "Overload Alarm: ${formatDuration(alarms.overloadAlarmTime ?? Duration.zero)}") : Container(),
        (alarms.freqLockAlarm == true) && (alarms.freqLockAlarmTime != null) ?  
        redStat(statText: "Freq Lock Alarm: ${formatDuration(alarms.freqLockAlarmTime ?? Duration.zero)}") : Container(),
      ],
              );
      }
  }

  runStats(device, orient) => !portrait(orient) ?
                              const LandScapeRunStats() 
                            : const PortraitRunStats();

  portrait(orientation) => (orientation == Orientation.portrait);

  
