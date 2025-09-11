# Issue: Long Method

## Severity: Medium

## Category: Maintenance

## Location
- **File(s)**: `lib/objects/database_model.dart`
- **Line(s)**: 59-59
- **Method/Widget**: `if`

## Description


## Why This Matters


## Current Code
```dart
  double getDoublePropertyValue(String name){
    dynamic value = getPropertyValue(name, 0.0);
    if (value is int){
      return double.parse("${value.toString()}.0");
    }
    if (value is String){
```

## Suggested Fix


## Implementation Steps


## Additional Resources


## Estimated Effort
15-30 minutes

## Analysis Confidence
High
