/**
 * @file database_model.dart
 * @author Stephen Boyett
 * @date 2025-09-06
 * @brief Base database model for Firebase property management.
 * @details Provides base class for managing Firebase properties with type-safe
 *          getters, setters, and property value conversion utilities.
 * @version 1.0
 * @since 1.0
 */

import '../data_models/property.dart';

/**
 * @brief Base class for database models with Firebase property management.
 * @details Provides common functionality for managing Firebase properties
 *          including type-safe getters, setters, and value conversions.
 * @since 1.0
 */
class DatabaseModel {

  /// Map of property names to FireProperty instances
  late Map<String, FireProperty> properties = {};

  /**
   * @brief Gets a FireProperty by its variable name.
   * @param name The property variable name
   * @return FireProperty instance or null if not found
   * @since 1.0
   */
  FireProperty? getPropertyByVariableName(String name){
    return properties[name];
  }

  /**
   * @brief Gets a property value with default fallback.
   * @details Retrieves property value if it exists, otherwise returns default.
   * @param name The property name
   * @param defaultVal Default value to return if property doesn't exist
   * @return Property value or default value
   * @since 1.0
   */
  dynamic getPropertyValue(String name, dynamic defaultVal){
    if (properties.containsKey(name)){
      return properties[name]?.value;
    }
    return defaultVal;
  }

  /**
   * @brief Gets a property value as a string.
   * @details Converts property value to string, handling various data types.
   * @param name The property name
   * @return String representation of the property value
   * @since 1.0
   */
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
