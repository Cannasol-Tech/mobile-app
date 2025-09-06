import 'dart:async';
import 'package:firebase_database/firebase_database.dart';

class FireProperty {
  /// @brief The base class for a Firebase Realtime Database Property.
  ///
  /// This class serves as the Base Abstract Class for all data being
  /// sent/read through the Firebase Realtime Database. It provides
  /// a standardized interface for managing property values and their
  /// corresponding database references.

  String name;
  dynamic value;
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

  /// Listens for changes to the Firebase Realtime Database and updates the value
  /// Returns a StreamSubscription that can be cancelled to stop listening
  ///
  /// The [onChange] callback is called whenever the Firebase value changes
  /// The local [value] property is automatically updated when changes occur
  StreamSubscription<DatabaseEvent> listenForChanges(
      [Function(dynamic)? onChange]) {
    return ref.onValue.listen((DatabaseEvent event) {
      // Update the local value
      if (event.snapshot.exists) {
        value = event.snapshot.value;
      } else {
        value = null;
      }

      // Call the optional callback with the new value
      onChange?.call(value);
    });
  }
}
