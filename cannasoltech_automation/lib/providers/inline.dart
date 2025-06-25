import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data_models/device.dart';
import '../handlers/state_handler.dart';
import '../handlers/alarm_handler.dart';
import 'system_data_provider.dart';

class SMDB{

  int _counter = 0;
  // 1. A private named constructor
  SMDB._internal();

  // 2. A static instance of the same class
  static final SMDB _instance = SMDB._internal();

  // 3. A factory constructor that returns the same instance
  factory SMDB() {
    // incrementCounters(); // Removed to fix the compile error
    return _instance;
  }

  void incrementCounters() {
    _counter = _counter + 1;
  }


//* Device *//
Device? readActiveDev(BuildContext ctx) => ctx.read<SystemDataModel>().activeDevice;
Device? watchActiveDev(BuildContext ctx) => ctx.watch<SystemDataModel>().activeDevice;

bool deviceIsActive(BuildContext ctx) => (readActiveDev(ctx) != null);

//* BROAD COMMAND FOR ANY ACTION / HDLR / VAL COMBO *//
// dynamic dev(BuildContext ctx, action, hdlr, v) {
//   if (deviceIsActive(ctx)) {
//     if (action == "read"){
//       return ctx.read<SystemDataModel>().activeDevice!.getHandler(hdlr)[v];
//     }
//     else if (action == "watch"){
//       return ctx.watch<SystemDataModel>().activeDevice!.getHandler(hdlr)[v];
//     }
//   }
//   else {
//     return null;
//   }
// }

//* Alarms *//
// dynamic getAlarmVar(BuildContext ctx, act, v) => (deviceIsActive(ctx) ? ctx.act<SystemDataModel>().activeDevice.state[v] : null);
// AlarmsModel? getAlarms(BuildContext ctx, act) => (deviceIsActive(ctx) ? ctx.act<SystemDataModel>().activeDevice.alarms : null);

AlarmsModel? readAlarms(BuildContext ctx) => (deviceIsActive(ctx) ? ctx.read<SystemDataModel>().activeDevice!.alarms : null);
AlarmsModel? watchAlarms(BuildContext ctx) => (deviceIsActive(ctx) ? ctx.watch<SystemDataModel>().activeDevice!.alarms : null);
bool alarmFlash(BuildContext ctx) => (ctx.read<SystemDataModel>().alarmFlash);

bool readAlarmVar(BuildContext ctx, v) => (deviceIsActive(ctx) ? ctx.read<SystemDataModel>().activeDevice!.alarms[v] : false);
bool watchAlarmVar(BuildContext ctx, v) => (deviceIsActive(ctx) ? ctx.watch<SystemDataModel>().activeDevice!.alarms[v] : false);

//* Config *//
// dynamic getConfigVar(BuildContext ctx, act, v) => (deviceIsActive(ctx) ? ctx.act<SystemDataModel>().activeDevice.state[v] : null);
// ConfigHandler? getConfig(BuildContext ctx, act) => (deviceIsActive(ctx) ? ctx.act<SystemDataModel>().activeDevice.config : null);

// ConfigHandler? readConfig(BuildContext ctx) => (deviceIsActive(ctx) ? ctx.read<SystemDataModel>().activeDevice!.config : null);
// ConfigHandler? watchConfig(BuildContext ctx) => (deviceIsActive(ctx) ? ctx.watch<SystemDataModel>().activeDevice!.config : null);

// dynamic readCfgVar(BuildContext ctx, v) => (deviceIsActive(ctx) ? ctx.read<SystemDataModel>().activeDevice!.config[v] : null);
// dynamic watchCfgVar(BuildContext ctx, v) => (deviceIsActive(ctx) ? ctx.watch<SystemDataModel>().activeDevice!.config[v] : null);
// void setCfgVar(BuildContext ctx, v, s) => (deviceIsActive(ctx) ? ctx.read<SystemDataModel>().activeDevice!.config[v] = s : null);

//* State *//
/* act == read/watch s == any state variable */
// dynamic getStateVar(BuildContext ctx, act, v) => (deviceIsActive(ctx) ? ctx.act<SystemDataModel>().activeDevice.state[v] : null);
// StateHandler? getState(BuildContext ctx, act) => (deviceIsActive(ctx) ? ctx.act<SystemDataModel>().activeDevice.state : null);

StateHandler? readState(BuildContext ctx) => (deviceIsActive(ctx) ? ctx.read<SystemDataModel>().activeDevice!.state : null);
StateHandler? watchState(BuildContext ctx) => (deviceIsActive(ctx) ? ctx.watch<SystemDataModel>().activeDevice!.state : null);

dynamic readStateVar(BuildContext ctx, v) => (deviceIsActive(ctx) ? ctx.read<SystemDataModel>().activeDevice!.state[v] : null);
dynamic watchStateVar(BuildContext ctx, v) => (deviceIsActive(ctx) ? ctx.watch<SystemDataModel>().activeDevice!.state[v] : null);


//* Data Vars *//
bool readSysData(ctx, v) => ctx.read<SystemDataModel>()[v];
bool watchSysData(ctx, v) => ctx.watch<SystemDataModel>()[v];
void setSysData(ctx, v, s) => (ctx, v, s) => (ctx.read<SystemDataModel>()[v] = s);

}

SMDB sMdB = SMDB();