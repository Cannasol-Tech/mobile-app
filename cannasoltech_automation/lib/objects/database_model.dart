import '../data_models/property.dart';

class DatabaseModel {

  late Map<String, FireProperty> properties = {};

  FireProperty? getPropertyByVariableName(String name){
    return properties[name];
  }

  dynamic getPropertyValue(String name, dynamic defaultVal){
    if (properties.containsKey(name)){
      return properties[name]?.value;
    }
    return defaultVal;
  }

  String getStringPropertyValue(String name){
    dynamic value = getPropertyValue(name, "");
    if (value is String){
      return value;
    }
    else if (value is double || value is int){
      return value.toString();
    }
    return "";
  }

  bool getBoolPropertyValue(String name){
    dynamic value = getPropertyValue(name, false);
    if (value is String){
      return bool.parse(value);
    }
    else if (value is bool){
      return value;
    }
    else if (value == 0){
      return false;
    }
    else if (value == 1) {
      return true;
    }
    return false;
  }

  int getIntPropertyValue(String name){
    dynamic value = getPropertyValue(name, 0);
    if (value is String){
      return int.parse(value);
    }
    else if (value is double) {
      return value.round();
    }
    return value;
  }

  double getDoublePropertyValue(String name){
    dynamic value = getPropertyValue(name, 0.0);
    if (value is int){
      return double.parse("${value.toString()}.0");
    }
    if (value is String){
      return double.parse((double.parse(value)).toStringAsFixed(2));
    }
    double parsedVal = double.parse(value.toStringAsFixed(2));
    return parsedVal;
  }

  void setPropertyValue(String propertyName, dynamic value){
    if (properties.containsKey(propertyName)){
      properties[propertyName]?.setValue(value);
    }
  }

  void setBoolPropertyValue(String name, bool value){
    if (properties.containsKey(name)){
      if (value == true || value == 1){
        properties[name]?.ref.set(1);
      }
      else if (value == false || value == 0) {
        properties[name]?.ref.set(0);
      }
    }
  }

  void setIntPropertyValue(String propertyName, dynamic value){
    if (value is int) {
      setPropertyValue(propertyName, value);
    }
    else {
      setPropertyValue(propertyName, int.parse(value));
    }
  }

  void setDoublePropertyValue(String propertyName, dynamic value){
    if (value is String){
      if (double.tryParse(value) != null){
        setPropertyValue(propertyName, double.tryParse(value));
      }
    }
    else {
      setPropertyValue(propertyName, value);
    }
  }
}
