
import 'package:firebase_database/firebase_database.dart';

import '../data_models/device.dart';
import '../data_models/property.dart';
import '../objects/database_model.dart';
import '../shared/methods.dart';
import '../shared/types.dart';

class CurrentRunModel extends DatabaseModel {
  
  Device? device;

  CurrentRunModel({ this.device });

  int get endTime => getIntPropertyValue("end_time");
  int get startTime => getIntPropertyValue("start_time");
  String get startUser => getStringPropertyValue("start_user");

  set startUser (String value) => properties["start_user"]?.ref.set(value);
  
  late Map<String, dynamic> native;

  factory CurrentRunModel.fromDatabase(DataSnapshot snap){
    DbMap data = getDbMap(snap);
    CurrentRunModel currentRun = CurrentRunModel();
    for (var propertyName in ['start_time', 'end_time', 'start_user']){
      DatabaseReference propertyRef = snap.child(propertyName).ref;
      MapEntry entry = data.entries.firstWhere(
        (entry) => entry.key == propertyName,
        orElse: () => MapEntry(propertyName, 'N/A')
      );
      currentRun.properties[propertyName] = FireProperty.fromData(entry, propertyRef);
    }
    return currentRun;
  }

  void setUser(String value) { 
    setPropertyValue("start_user", value);
  }
}