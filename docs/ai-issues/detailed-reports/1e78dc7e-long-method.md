# Issue: Long Method

## Severity: Medium

## Category: Maintenance

## Location
- **File(s)**: `lib/objects/database_model.dart`
- **Line(s)**: 48-48
- **Method/Widget**: `if`

## Description


## Why This Matters


## Current Code
```dart
  int getIntPropertyValue(String name){
    dynamic value = getPropertyValue(name, 0);
    if (value is String){
      return int.parse(value);
    }
    else if (value is double) {
```

## Suggested Fix


## Implementation Steps


## Additional Resources


## Estimated Effort
15-30 minutes

## Analysis Confidence
High
