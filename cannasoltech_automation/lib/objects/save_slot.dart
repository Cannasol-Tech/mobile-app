/**
 * @file save_slot.dart
 * @author Stephen Boyett
 * @date 2025-09-06
 * @brief Save slot management for device configuration storage.
 * @details Provides save slot functionality for storing and loading device
 *          configurations including timing, temperature, and threshold settings.
 * @version 1.0
 * @since 1.0
 */

import 'package:cannasoltech_automation/data_models/device.dart';
import 'package:firebase_database/firebase_database.dart';
import '../data_models/property.dart';
import '../shared/methods.dart';
import '../shared/types.dart';
import 'database_model.dart';

/**
 * @brief Staged configuration slot for temporary storage.
 * @details Holds configuration parameters temporarily before saving to
 *          permanent save slots, allowing for configuration staging.
 * @since 1.0
 */
class StagedSlot {
  /// Run duration in hours
  int hours = 0;

  /// Run duration in minutes
  int minutes = 0;

  /// Set temperature for the run
  double setTemp = 0.0;

  /// Batch size parameter
  double batchSize = 0.0;

  /// Temperature threshold setting
  double tempThresh = 0.0;

  /// Flow threshold setting
  double flowThresh = 0.0;

  /// Pressure threshold setting
  double pressureThresh = 0.0;

  /// Cooldown enabled flag
  bool cooldownEnabled = false;

  /// Cooldown temperature setting
  double cooldownTemp = 0.0;

  /**
   * @brief Creates a StagedSlot from configuration object.
   * @details Initializes staged slot with values from device configuration.
   * @param config Configuration object to copy values from
   */
  StagedSlot.fromConfig(config) {
    hours = config.setHours;
    minutes = config.setMinutes;
    setTemp = config.setTemp;
    batchSize = config.batchSize;
    tempThresh = config.tempThresh;
    flowThresh = config.flowThresh;
    pressureThresh = config.pressureThresh;
    cooldownEnabled = config.enableCooldown;
    cooldownTemp = config.cooldownTemp;
  } 
  StagedSlot.fromBlank();
}

class SaveSlot extends DatabaseModel {
  int idx;
  Device device;
  bool busy = false;
  bool saved = false;
  late DataSnapshot snap;

  SaveSlot({required this.device, required this.idx});

  factory SaveSlot.fromDatabase({snap, device, idx}){
    DbMap data = getDbMap(snap);
    DatabaseReference propertyRef;
    SaveSlot slot = SaveSlot(device: device, idx: idx);
    for (var entry in data.entries){
      propertyRef = snap.child(entry.key).ref;
      slot.properties[entry.key] = FireProperty.fromData(entry, propertyRef);
    }
    return slot;
  }  

  int get hours => getIntPropertyValue('hours');
  int get minutes => getIntPropertyValue('minutes');
  String get setTime => "$hours:${padZeros(minutes, 2)}:00";
  double get setTemp => getDoublePropertyValue('set_temp');
  double get batchSize => getDoublePropertyValue('batch_size');
  double get tempThresh => getDoublePropertyValue('temp_var');
  double get flowThresh => getDoublePropertyValue('min_flow');
  double get pressureThresh => getDoublePropertyValue('min_pressure');
  bool get cooldownEnabled => getBoolPropertyValue('enable_cooldown');
  double get cooldownTemp => getDoublePropertyValue('cool_down_temp');


  /* Private variables to verify the configuration
     gets correctly stored in the save slot        */
  dynamic staged;

  void save() {
    setIntPropertyValue('hours', device.config.setHours);
    setIntPropertyValue('minutes', device.config.setMinutes);
    setDoublePropertyValue('set_temp', device.config.setTemp);
    setDoublePropertyValue('batch_size', device.config.batchSize);
    setDoublePropertyValue('temp_var', device.config.tempThresh);
    setDoublePropertyValue('min_flow', device.config.flowThresh);
    setDoublePropertyValue('min_pressure', device.config.pressureThresh);
    setDoublePropertyValue('enable_cooldown', device.config.enableCooldown);
    setDoublePropertyValue('cool_down_temp', device.config.cooldownTemp);
    device.config.setIntPropertyValue('save_slot', idx);
  }

  void load() {
    // setSetTime(Duration(hours: hours, minutes: minutes));
    // setTemperature(setTemp.toString());
    // setBatchSize(batchSize.toString());
    // setTempVariance(tempThresh.toString());
    // setMinFlowRate(flowThresh.toString());
    // setMinPressure(pressureThresh.toString());
    // setEnableCoolDown(cooldownEnabled);
    // setCooldownTemp(cooldownTemp.toString());
    device.config.setPropertyValue('load_slot', idx);
  }
}
