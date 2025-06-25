import 'package:cannasoltech_automation/shared/methods.dart';
import 'package:flutter/material.dart';

class SetTimeController extends TextEditingController {
  bool updateBlock = false;
  void lock() => updateBlock = true;
  void unlock() => updateBlock = false;
  void updateText(String newText) => (updateBlock) ? null : text = newText;
} 

class TextControllers {
  TextEditingController batchSizeController = TextEditingController();
  TextEditingController setTempController = TextEditingController();
  TextEditingController registerDeviceController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  SetTimeController     setTimeController = SetTimeController();
  TextEditingController pumpControlController = TextEditingController();
  TextEditingController tempThreshController = TextEditingController();
  TextEditingController flowThreshController = TextEditingController();
  TextEditingController pressureThreshController = TextEditingController();
  TextEditingController coolDownTempController = TextEditingController();

  bool offline = false;

  void dispose() {
    batchSizeController.dispose();
    setTempController.dispose();
    // registerDeviceController.clear();
    stateController.dispose();
    setTimeController.dispose();
    pumpControlController.dispose();
    tempThreshController.dispose();
    flowThreshController.dispose();
    pressureThreshController.dispose();
    coolDownTempController.dispose();
  }

  void clear(){
    batchSizeController.clear();
    setTempController.clear();
    // registerDeviceController.clear();
    stateController.clear();
    setTimeController.clear();
    pumpControlController.clear();
    tempThreshController.clear();
    flowThreshController.clear();
    pressureThreshController.clear();
    coolDownTempController.clear();
  }

  void init(dynamic newDeviceData){
    dynamic config = newDeviceData.config;
    dynamic state = newDeviceData.state;
      // registerDeviceController.text = newDeviceData.id.toString();
      stateController.text = state.toString();
      setTimeController.text = config.setTime;
      // pumpControlController.text = config.toString();
      batchSizeController.text = displayDouble(config.batchSize, 1);
      setTempController.text = displayDouble(config.setTemp, 1);
      tempThreshController.text = displayDouble(config.tempThresh, 2);
      flowThreshController.text = displayDouble(config.flowThresh, 1);
      pressureThreshController.text = displayDouble(config.pressureThresh, 1);
      coolDownTempController.text = displayDouble(config.cooldownTemp, 1);
  }

  void update(dynamic newDeviceData, dynamic activeDevice){
    dynamic activeConfig = activeDevice.config;
    dynamic newConfig = newDeviceData.config;
    dynamic activeState = activeDevice.state;
    dynamic newState = newDeviceData.state;

    if (activeDevice != null && newDeviceData != null){
      if (newConfig.batchSize != activeConfig.batchSize){
        batchSizeController.text = displayDouble(newConfig.batchSize, 1);     
      }
      if (newConfig.setTemp != activeConfig.setTemp){
        setTempController.text = displayDouble(newConfig.setTemp, 1);   
      }
      if (newDeviceData.id != activeDevice.id){
        registerDeviceController.text = newDeviceData.id.toString();     
      }
      if (newState.state != activeState.state){
        stateController.text = newState.state.toString();
      }

      if ((newConfig.setHours != activeConfig.setHours) ||
          (newConfig.setMinutes != activeConfig.setMinutes) ||
          (setTimeController.text == '')){
        setTimeController.updateText(newConfig.setTime);
        // setTimeController.text = newConfig.setTime;
      }

      if (newConfig.pumpControl != activeConfig.pumpControl){
        pumpControlController.text = newConfig.pumpControl.toString();
      }

      if (newConfig.tempThresh != activeConfig.tempThresh){
        tempThreshController.text = displayDouble(newConfig.tempThresh, 2);     
      }

      if (newConfig.flowThresh != activeConfig.flowThresh){
        flowThreshController.text = displayDouble(newConfig.flowThresh, 1);     
      }

      if (newConfig.pressureThresh != activeConfig.pressureThresh){
        pressureThreshController.text = displayDouble(newConfig.pressureThresh, 1);     
      }

      if (newConfig.cooldownTemp != activeConfig.cooldownTemp){
        coolDownTempController.text = displayDouble(newConfig.cooldownTemp, 1);     
      }
    }
  }
}