import 'package:cannasoltech_automation/data_models/device.dart';
import 'package:firebase_database/firebase_database.dart';
import '../data_models/property.dart';
import '../shared/methods.dart';
import '../shared/types.dart';
import 'database_model.dart';

class StagedSlot {
  int hours = 0;
  int minutes = 0;
  double setTemp = 0.0;
  double batchSize = 0.0;
  double tempThresh = 0.0;
  double flowThresh = 0.0;
  double pressureThresh = 0.0;
  bool cooldownEnabled = false;
  double cooldownTemp = 0.0;

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
