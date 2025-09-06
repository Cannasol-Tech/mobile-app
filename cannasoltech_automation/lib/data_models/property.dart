/**
 * @file property.dart
 * @author Stephen Boyett
 * @date 2025-09-06
 * @brief Firebase Realtime Database property management.
 * @details Defines the FireProperty class for managing Firebase database properties
 *          with standardized interfaces for reading, writing, and listening to changes.
 * @version 1.0
 * @since 1.0
 */

import 'package:firebase_database/firebase_database.dart';

/**
 * @brief Base class for Firebase Realtime Database properties.
 * @details Provides standardized interface for managing property values and their
 *          corresponding database references, including read/write operations.
 * @since 1.0
 */
class FireProperty {
  /// Property name identifier
  String name;

  /// Current property value (dynamic type to support various data types)
  dynamic value;

  /// Firebase database reference for this property
  DatabaseReference ref;

  FireProperty(
      {required this.name,
      required this.value,
      required this.ref}); //, required this.type});

  factory FireProperty.fromData(MapEntry data, DatabaseReference ref) {
    FireProperty property =
        FireProperty(ref: ref, name: data.key, value: data.value);
    return property;
  }

  /// Updates the Firebase Realtime Database with the new value

  void setValue(value) {
    ref.set(value);
  }

  void getValue(value) {
    ref.once().then((event) {
      value = event.snapshot.value;
    });
  }

  /// TODO: #13 Implement listening for all firebase properties.

  /// Listens for changes to the Firebase Realtime Database and updates the value
  // void listenForChanges(Function(dynamic) onChange) {
  //   ref.onValue.listen((DatabaseEvent event) {
  //     onChange(event.snapshot.value);
  //   });
  // }
}
