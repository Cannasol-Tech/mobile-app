
/**
 * @file current_run.dart
 * @author Stephen Boyett
 * @date 2025-09-06
 * @brief Current run session management and tracking.
 * @details Manages active device run sessions including start/end times,
 *          user tracking, and run state persistence with Firebase integration.
 * @version 1.0
 * @since 1.0
 */

import 'package:firebase_database/firebase_database.dart';

import '../data_models/device.dart';
import '../data_models/property.dart';
import '../objects/database_model.dart';
import '../shared/methods.dart';
import '../shared/types.dart';

/**
 * @brief Model for managing current device run sessions.
 * @details Extends DatabaseModel to track active run sessions including
 *          timing information, user attribution, and session state.
 * @since 1.0
 */
class CurrentRunModel extends DatabaseModel {

  /// Associated device for the current run
  Device? device;

  /**
   * @brief Creates a CurrentRunModel instance.
   * @param device Optional associated device for the run session
   */
  CurrentRunModel({ this.device });

  /// Getter for run end time (Unix timestamp)
  int get endTime => getIntPropertyValue("end_time");

  /// Getter for run start time (Unix timestamp)
  int get startTime => getIntPropertyValue("start_time");

  /// Getter for user who started the run
  String get startUser => getStringPropertyValue("start_user");

  /// Setter for user who started the run
  set startUser (String value) => properties["start_user"]?.ref.set(value);

  /// Raw native data from database
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