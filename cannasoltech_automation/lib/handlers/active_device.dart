
/**
 * @file active_device.dart
 * @author Stephen Boyett
 * @date 2025-09-06
 * @brief Active device management and monitoring handler.
 * @details Manages the currently active device selection, Firebase listeners,
 *          and real-time device data synchronization for the application.
 * @version 1.0
 * @since 1.0
 */

import 'package:firebase_database/firebase_database.dart';

import '../data_models/device.dart';

/**
 * @brief Handles active device selection and monitoring.
 * @details Manages the currently selected device, sets up Firebase listeners
 *          for real-time updates, and handles device switching operations.
 * @since 1.0
 */
class ActiveDeviceHandler {
  /// Firebase database reference for the active device
  late DatabaseReference _activeDeviceRef;

  /// ID of the currently active device
  String? deviceId;

  /// Currently active device instance
  Device? device;

  /// Flag indicating if the handler is initialized
  bool initialized = false;

  /// Firebase listener for active device updates
  dynamic _activeDeviceListener;

  /**
   * @brief Creates an uninitialized ActiveDeviceHandler.
   * @details Initializes the handler in an uninitialized state, ready for setup.
   */
  ActiveDeviceHandler.uninitialized(){
    uninitialize();
  }

  /**
   * @brief Uninitializes the active device handler.
   * @details Cancels Firebase listeners, clears device data, and resets state.
   * @since 1.0
   */
  void uninitialize(){
    if (_activeDeviceListener != null){
      _activeDeviceListener.cancel();
      deviceId = null;
      _activeDeviceListener = null;
      initialized = false;
    }
  }

  /**
   * @brief Initializes the handler with a specific device ID.
   * @details Sets up Firebase reference, device ID, and initializes device monitoring.
   * @param newId The device ID to set as active
   * @since 1.0
   */
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

