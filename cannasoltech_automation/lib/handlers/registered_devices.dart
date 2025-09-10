
/**
 * @file registered_devices.dart
 * @author Stephen Boyett
 * @date 2025-09-06
 * @brief Registered device management and status monitoring.
 * @details Manages user's registered devices, monitors their status,
 *          and handles device registration/deregistration with Firebase listeners.
 * @version 1.0
 * @since 1.0
 */

import 'package:firebase_database/firebase_database.dart';

/// Type alias for device ID strings
typedef DeviceId = String;

/**
 * @brief Handles registered device management and status monitoring.
 * @details Manages the list of devices registered to a user, monitors their
 *          status in real-time, and handles device listener management.
 * @since 1.0
 */
class RegisteredDeviceHandler {
  /// Flag indicating if the handler is initialized
  bool initialized = false;

  /// List of registered device IDs
  List<String> _registeredDeviceIds = [];

  /// Map of device listeners for real-time updates
  Map<DeviceId, dynamic> _deviceListeners = {};

  /// Getter for registered device status map
  Map<DeviceId, String> get registeredDeviceStatus => _registeredDeviceStatus;

  /// Private map storing device status information
  Map<DeviceId, String> _registeredDeviceStatus = {};

  /**
   * @brief Creates an uninitialized RegisteredDeviceHandler.
   * @details Initializes the handler in an uninitialized state and cleans up
   *          any existing listeners and device data.
   */
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
