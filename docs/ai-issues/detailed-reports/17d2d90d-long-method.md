# Issue: Long Method

## Severity: Medium

## Category: Maintenance

## Location
- **File(s)**: `lib/objects/database_model.dart`
- **Line(s)**: 95-95
- **Method/Widget**: `setDoublePropertyValue`

## Description


## Why This Matters


## Current Code
```dart
  }

  void setDoublePropertyValue(String propertyName, dynamic value){
    if (value is String){
      if (double.tryParse(value) != null){
        setPropertyValue(propertyName, double.tryParse(value));
```

## Suggested Fix


## Implementation Steps


## Additional Resources


## Estimated Effort
15-30 minutes

## Analysis Confidence
High
