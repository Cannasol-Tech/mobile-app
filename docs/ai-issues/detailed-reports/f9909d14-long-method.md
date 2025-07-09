# Issue: Long Method

## Severity: Medium

## Category: Maintenance

## Location
- **File(s)**: `lib/objects/database_model.dart`
- **Line(s)**: 29-29
- **Method/Widget**: `getBoolPropertyValue`

## Description


## Why This Matters


## Current Code
```dart
  }

  bool getBoolPropertyValue(String name){
    dynamic value = getPropertyValue(name, false);
    if (value is String){
      return bool.parse(value);
```

## Suggested Fix


## Implementation Steps


## Additional Resources


## Estimated Effort
15-30 minutes

## Analysis Confidence
High
