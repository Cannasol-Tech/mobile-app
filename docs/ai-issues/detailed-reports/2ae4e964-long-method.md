# Issue: Long Method

## Severity: Medium

## Category: Maintenance

## Location
- **File(s)**: `lib/objects/database_model.dart`
- **Line(s)**: 87-87
- **Method/Widget**: `if`

## Description


## Why This Matters


## Current Code
```dart

  void setIntPropertyValue(String propertyName, dynamic value){
    if (value is int) {
      setPropertyValue(propertyName, value);
    }
    else {
```

## Suggested Fix


## Implementation Steps


## Additional Resources


## Estimated Effort
15-30 minutes

## Analysis Confidence
High
