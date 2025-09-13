/**
 * @file data.dart
 * @author Stephen Boyett
 * @date 2025-09-06
 * @brief Device collection and management data model.
 * @details Defines the Devices class for managing collections of available devices,
 *          handling device discovery, and maintaining device ID/name mappings.
 * @version 1.0
 * @since 1.0
 */

import 'package:firebase_database/firebase_database.dart';

/**
 * @brief Manages collection of available devices and their mappings.
 * @details Handles device discovery, maintains ID/name mappings, and provides
 *          Firebase database listeners for real-time device updates.
 * @since 1.0
 */
class Devices {
  /// Firebase database reference to the devices collection
  final DatabaseReference  _devicesRef = FirebaseDatabase.instance.ref('/Devices');

  /// Map from device ID to device name
  Map<String, String> idNameMap = {};

  /// Map from device name to device ID
  Map<String, String> nameIdMap = {};

  /// Listener for device added events
  dynamic _addedListener;

  /// Listener for device removed events
  dynamic _removedListener;

  /// Flag indicating if the devices collection is initialized
  bool initialized = false;


  /**
   * @brief Named constructor that initializes the devices collection.
   * @details Reinitializes if already initialized, then sets up device listeners.
   * @since 1.0
   */
  Devices.initialize() {
      if (initialized == true){
        uninitialize();
      }
      initialize();
      initialized = true;
    }

  /**
   * @brief Uninitializes the devices collection and detaches listeners.
   * @details Removes Firebase database listeners and resets initialization state.
   * @since 1.0
   */
  void uninitialize() {
    if (_addedListener != null){
      _addedListener.detach();
    }
    if (_removedListener != null) {
      _removedListener.detach();
    }
    initialized = false;
  }

  /**
   * @brief Named constructor that creates an empty devices collection.
   * @details Initializes with empty maps and uninitialized state.
   * @since 1.0
   */
  Devices.empty() {
    initialized = false;
    idNameMap = {};
    nameIdMap = {};
  }

  /**
   * @brief Initializes the devices collection with Firebase listeners.
   * @details Loads existing devices from Firebase, sets up real-time listeners
   *          for device additions and removals, and populates ID/name mappings.
   * @throws Exception if Firebase operations fail
   * @since 1.0
   */
  Future<void> initialize() async {
    await _devicesRef.once().then((event) {
      if (event.snapshot.exists){
        for (var child in event.snapshot.children){
          if (child.exists && child.hasChild('Info/name')){
            var id = child.key.toString();
            var name = child.child('Info/name').value.toString();
            idNameMap[id] = name;
            nameIdMap[name] = id;
          }
        }
      }
    });
    _addedListener = _devicesRef.onChildAdded.listen((event) {
      if (event.snapshot.exists && event.snapshot.hasChild('Info/name')){
        var id = event.snapshot.key.toString();
        var name = event.snapshot.child('Info/name').value.toString();
        idNameMap[id] = name;
        nameIdMap[name] = id;
      }
    });
    _removedListener = _devicesRef.onChildRemoved.listen((event) {
      if (event.snapshot.exists && event.snapshot.hasChild('Info/name')){
        var id = event.snapshot.key.toString();
        var name = event.snapshot.child('Info/name').value.toString();
        idNameMap.removeWhere((dbId, dbName) => (dbId == id && dbName == name));
        nameIdMap.removeWhere((dbName, dbId) => (dbId == id && dbName == name));
      }
    });
    initialized = true;
  }

  /**
   * @brief Gets device name from device ID.
   * @param deviceId The device ID to look up
   * @return Device name if found, null otherwise
   * @since 1.0
   */
  String? getNameFromId(String? deviceId) {
    return idNameMap[deviceId];
  }

  /**
   * @brief Gets device ID from device name.
   * @param deviceName The device name to look up
   * @return Device ID if found, null otherwise
   * @since 1.0
   */
  String? getIdFromName(String? deviceName){
    return nameIdMap[deviceName];
  }

  /**
   * @brief Converts a list of device names to device IDs.
   * @details Maps each device name to its corresponding ID, using empty string
   *          for names that don't have a corresponding ID.
   * @param names List of device names to convert
   * @return List of corresponding device IDs
   * @since 1.0
   */
  List<String> namesToIds(List<String> names){
    List<String> ids = [];
    for (String name in names){
      ids.add(nameIdMap[name]??='');
    }
    return ids;
  }

    List<String> idsToNames(List<String> ids){
    List<String> names = [];
    for (String deviceId in ids){
      names.add(idNameMap[deviceId]??='');
    }
    return names;
  }


  bool doesDeviceExist(String deviceID) {
    return idNameMap.containsKey(deviceID);
  }
}
