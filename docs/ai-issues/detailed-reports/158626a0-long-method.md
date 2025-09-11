# Issue: Long Method

## Severity: Medium

## Category: Maintenance

## Location
- **File(s)**: `lib/objects/database_model.dart`
- **Line(s)**: 11-11
- **Method/Widget**: `getPropertyValue`

## Description


## Why This Matters


## Current Code
```dart
  }

  dynamic getPropertyValue(String name, dynamic defaultVal){
    if (properties.containsKey(name)){
      return properties[name]?.value;
    }
```

## Suggested Fix


## Implementation Steps


## Additional Resources


## Estimated Effort
15-30 minutes

## Analysis Confidence
High
