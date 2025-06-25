import 'package:firebase_database/firebase_database.dart';

class Devices {
  /* 
    Class used to collect all the current devices available.. Called when initializing connection / checking connection to devices
  */
  final DatabaseReference  _devicesRef = FirebaseDatabase.instance.ref('/Devices');
  Map<String, String> idNameMap = {};
  Map<String, String> nameIdMap = {};

  dynamic _addedListener;
  dynamic _removedListener;
  bool initialized = false;


  Devices.initialize() {
      if (initialized == true){
        uninitialize();
      }
      initialize();
      initialized = true;
    }

  void uninitialize() {
    if (_addedListener != null){
      _addedListener.detach();
    }
    if (_removedListener != null) {
      _removedListener.detach();
    }
    initialized = false;
  }

  Devices.empty() {
    initialized = false;
    idNameMap = {};
    nameIdMap = {};
  }

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

  String? getNameFromId(String? deviceId) {
    return idNameMap[deviceId];
  }

  String? getIdFromName(String? deviceName){
    return nameIdMap[deviceName];
  }

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
