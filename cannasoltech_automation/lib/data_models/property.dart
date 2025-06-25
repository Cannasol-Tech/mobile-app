import 'package:firebase_database/firebase_database.dart';

class FireProperty{
  String name;
  dynamic value;
  // late String type;
  DatabaseReference ref;

  FireProperty({required this.name, required this.value, required this.ref});//, required this.type});

  factory FireProperty.fromData(MapEntry data, DatabaseReference ref) {
    FireProperty property = FireProperty(
      ref: ref,
      name: data.key,
      value: data.value
    );
    return property;
  }

  void setValue(value){
    ref.set(value);
  }
}

// property.ref.set(data.value);
// property.ref.onValue.listen((DatabaseEvent event){
//   property.value = event.snapshot.value.toString();
// }