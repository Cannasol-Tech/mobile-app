
import 'package:firebase_database/firebase_database.dart';

import '../data_models/device.dart';

class ActiveDeviceHandler {
  late DatabaseReference _activeDeviceRef;
  String? deviceId;
  Device? device;
  bool initialized = false;
  dynamic _activeDeviceListener;

  ActiveDeviceHandler.uninitialized(){
    uninitialize();
  }

  void uninitialize(){
    if (_activeDeviceListener != null){
      _activeDeviceListener.cancel();
      deviceId = null;
      _activeDeviceListener = null;
      initialized = false;
    }
  }

  void initialize(String newId){
    _activeDeviceRef = FirebaseDatabase.instance.ref('/Devices/$newId');
    deviceId = newId;
    initActiveDevice();
    initialized = true;
  }

  void update(String newId) {
    if (initialized == false){
      return initialize(newId);
    }
    if (newId != deviceId){
      uninitialize();
      initialize(newId);
    }
  }

  void initActiveDevice() {
    if (_activeDeviceListener != null){
      _activeDeviceListener.cancel();
    }
      _activeDeviceListener = _activeDeviceRef.onValue.listen((DatabaseEvent event){
      if (event.snapshot.exists){
          device = Device.fromDatabase(event.snapshot);
      }
      else {
        device = null;
      }
    });
  }
}

