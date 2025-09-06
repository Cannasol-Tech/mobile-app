/**
 * @file config_handler.dart
 * @author Stephen Boyett
 * @date 2025-09-06
 * @brief Device configuration management handler.
 * @details Manages device configuration parameters, control operations,
 *          and save slot functionality with Firebase database integration.
 * @version 1.0
 * @since 1.0
 */

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../data_models/device.dart';
import '../data_models/property.dart';
import '../objects/database_model.dart';
import '../objects/save_slot.dart';
import '../shared/constants.dart';
import '../shared/methods.dart';
import '../shared/snacks.dart';
import '../shared/types.dart';

/**
 * @brief Handles device configuration and control operations.
 * @details Extends DatabaseModel to provide device configuration management,
 *          control operations (start/stop/reset), and save slot functionality.
 * @since 1.0
 */
class ConfigHandler extends DatabaseModel{
  /// Associated device instance
  dynamic device;

  /// List of configuration save slots
  List<SaveSlot> saveSlots = [];

  /// Getter for reset/abort run status
  bool get reset => getBoolPropertyValue('abort_run');

  /// Getter for start operation status
  bool get start => getBoolPropertyValue('start');

  /// Setter for reset/abort run operation
  set reset (bool value) => setPropertyValue("abort_run", value);

  /// Setter for start operation
  set start (bool value) => setPropertyValue("start", value);

  /// Getter for end run status
  bool get end => getBoolPropertyValue('end_run');

  /// Getter for abort operation status
  bool get abort => getBoolPropertyValue('abort_run');

  /// Setter for abort operation
  set abort (bool value) => setPropertyValue("abort_run", value);

  /// Setter for end run operation
  set end (bool value) => setPropertyValue("end_run", value);

  /// Getter for configured hours setting
  int get setHours => getIntPropertyValue('set_hours');

  /// Getter for configured minutes setting
  int get setMinutes => getIntPropertyValue('set_minutes');
  set setHours (int value) => setIntPropertyValue("set_temp", value);
  set setMinutes (int value) => setIntPropertyValue("batch_size", value);

  String get setTime => "$setHours:${padZeros(setMinutes, 2)}";

  bool get pumpControl => getBoolPropertyValue('pump_control');
  bool get enableCooldown => getBoolPropertyValue('enable_cooldown');
  set pumpControl (bool value) => setPropertyValue("pump_control", value);
  set enableCooldown (bool value) => setPropertyValue("enable_cooldown", value);

  double get setTemp => getDoublePropertyValue('set_temp');
  double get batchSize => getDoublePropertyValue('batch_size');
  double get flowThresh => getDoublePropertyValue('flow_thresh');
  double get tempThresh => getDoublePropertyValue('temp_thresh');
  double get cooldownTemp => getDoublePropertyValue('cool_down_temp');
  double get pressureThresh => getDoublePropertyValue('pressure_thresh');

  set setTemp (double value) => setDoublePropertyValue("set_temp", value);
  set batchSize (double value) => setDoublePropertyValue("batch_size", value);
  set flowThresh (double value) => setDoublePropertyValue("flow_thresh", value);
  set tempThresh (double value) => setDoublePropertyValue("temp_thresh", value);
  set cooldownTemp (double value) => setDoublePropertyValue("cool_down_temp", value);
  set pressureThresh (double value) => setDoublePropertyValue("pressure_thresh", value);

  double get currSetTemp => (device.state.state != COOL_DOWN) ? setTemp : cooldownTemp;

  ConfigHandler({this.device}) {
    device = device;
  }

  factory ConfigHandler.fromDatabase(DataSnapshot snap, Device device){
    DbMap data = getDbMap(snap);
    DatabaseReference propertyRef;
    ConfigHandler config = ConfigHandler();
    config.device = device;
    for (var entry in data.entries){
      propertyRef = snap.child(entry.key).ref;
      config.properties[entry.key] = FireProperty.fromData(entry, propertyRef);
    }
    return config;
  }

  /* Setters */
  void startDevice(BuildContext context) {
    dynamic property = getPropertyByVariableName('start');
    if (property != null){
      property.setValue(true);
    }
    showSnack(context, startingDeviceSnack(device.name));
  }

  void resetDevice() {
    dynamic property = getPropertyByVariableName('abort_run');
    if (property != null){
      property.setValue(true);
    }
  }

  void abortRun() {
    dynamic property = getPropertyByVariableName('abort_run');
    if (property != null) {
      property.setValue(true);
    }
  }

  void endRun() {
    dynamic property = getPropertyByVariableName('end_run');
    if (property != null) {
      property.setValue(true);
    }
  }

  void resumeRun() {
    dynamic property = getPropertyByVariableName('resume');
    if (property != null) {
      property.setValue(true);
    }
  }

  void setSetTime(Duration duration){
    setIntPropertyValue('set_hours', duration.inHours);
    setIntPropertyValue('set_minutes', duration.inMinutes - duration.inHours*60);
  }

  void setEnableCoolDown(bool enabled) {
    dynamic property = getPropertyByVariableName('enable_cooldown');
    if (property != null){
      property.setValue(enabled);
    }
  }

  dynamic setPumpControl(bool pumpControl){
    setPropertyValue('pump_control', pumpControl);
  }

  void setBatchSize(String batchSize) {
    setDoublePropertyValue('batch_size', batchSize);
  }

  void setTemperature(String temperature) {
    setDoublePropertyValue('set_temp', temperature);
  }

  void setTempVariance(String tempVariance) {
    setDoublePropertyValue('temp_thresh', tempVariance); 
  }

  void setMinFlowRate(String minFlowRate) {
    setDoublePropertyValue('flow_thresh', minFlowRate);
  }

  void setMinPressure(String minPressure) {
    setDoublePropertyValue('pressure_thresh', minPressure);
  }

  void setCooldownTemp(String cooldownTemp) {
    setDoublePropertyValue('cool_down_temp', cooldownTemp);
  }
}