# Issue: Long Method

## Severity: Medium

## Category: Maintenance

## Location
- **File(s)**: `lib/objects/database_model.dart`
- **Line(s)**: 7-7
- **Method/Widget**: `getPropertyByVariableName`

## Description


## Why This Matters


## Current Code
```dart
  late Map<String, FireProperty> properties = {};

  FireProperty? getPropertyByVariableName(String name){
    return properties[name];
  }

```

## Suggested Fix


## Implementation Steps


## Additional Resources


## Estimated Effort
15-30 minutes

## Analysis Confidence
High
