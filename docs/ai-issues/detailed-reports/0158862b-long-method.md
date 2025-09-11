# Issue: Long Method

## Severity: Medium

## Category: Maintenance

## Location
- **File(s)**: `lib/objects/database_model.dart`
- **Line(s)**: 46-46
- **Method/Widget**: `getIntPropertyValue`

## Description


## Why This Matters


## Current Code
```dart
  }

  int getIntPropertyValue(String name){
    dynamic value = getPropertyValue(name, 0);
    if (value is String){
      return int.parse(value);
```

## Suggested Fix


## Implementation Steps


## Additional Resources


## Estimated Effort
15-30 minutes

## Analysis Confidence
High
