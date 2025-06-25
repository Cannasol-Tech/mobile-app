
import 'package:firebase_database/firebase_database.dart';


typedef DeviceId = String;

class RegisteredDeviceHandler {
  bool initialized = false;
  List<String> _registeredDeviceIds = [];
  Map<DeviceId, dynamic> _deviceListeners = {};
  Map<DeviceId, String> get registeredDeviceStatus => _registeredDeviceStatus;
  Map<DeviceId, String> _registeredDeviceStatus = {};

  RegisteredDeviceHandler.uninitialized(){
    if (_deviceListeners != []){
      for (var listener in _deviceListeners.values){
        listener.cancel();
      }
      _deviceListeners = {};
      _registeredDeviceIds = [];
      _registeredDeviceStatus = {};
      initialized = false;
    }
  }

  void uninitialize(){
    if (_deviceListeners != []){
      for (var listener in _deviceListeners.values){
        listener.cancel();
      }
      _deviceListeners = {};
      _registeredDeviceIds = [];
      initialized = false;
    }
  }

  void initialize(List<String> registeredDeviceIds){
    if (initialized != false){
      uninitialize();
    }
    _registeredDeviceIds = registeredDeviceIds;

    for (String deviceId in _registeredDeviceIds){
      addDeviceListener(deviceId);
    }
    initialized = true;
  }

  void update(List<String> registeredDeviceIds) {
    if (initialized == false){
      return initialize(registeredDeviceIds);
    }
    if (_registeredDeviceIds != registeredDeviceIds){
      uninitialize();
      initialize(registeredDeviceIds);
    }
  }

  void addDeviceListener(String deviceId) {
    DatabaseReference alarmRef = FirebaseDatabase.instance.ref('/Devices/$deviceId/Info/status');
    if (_deviceListeners.containsKey(deviceId)){
      _deviceListeners[deviceId].cancel();
    }
      _deviceListeners[deviceId] = alarmRef.onValue.listen((DatabaseEvent event){
        if (event.snapshot.exists){
          _registeredDeviceStatus[deviceId] = event.snapshot.value.toString();
        }
      }
    );
  }


}
