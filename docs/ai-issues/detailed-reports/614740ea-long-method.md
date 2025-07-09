# Issue: Long Method

## Severity: Medium

## Category: Maintenance

## Location
- **File(s)**: `lib/objects/database_model.dart`
- **Line(s)**: 20-20
- **Method/Widget**: `if`

## Description


## Why This Matters


## Current Code
```dart
  String getStringPropertyValue(String name){
    dynamic value = getPropertyValue(name, "");
    if (value is String){
      return value;
    }
    else if (value is double || value is int){
```

## Suggested Fix


## Implementation Steps


## Additional Resources


## Estimated Effort
15-30 minutes

## Analysis Confidence
High
