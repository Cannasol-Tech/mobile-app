# Issue: Long Method

## Severity: Medium

## Category: Maintenance

## Location
- **File(s)**: `lib/objects/database_model.dart`
- **Line(s)**: 31-31
- **Method/Widget**: `if`

## Description


## Why This Matters


## Current Code
```dart
  bool getBoolPropertyValue(String name){
    dynamic value = getPropertyValue(name, false);
    if (value is String){
      return bool.parse(value);
    }
    else if (value is bool){
```

## Suggested Fix


## Implementation Steps


## Additional Resources


## Estimated Effort
15-30 minutes

## Analysis Confidence
High
