# Issue: Long Method

## Severity: Medium

## Category: Maintenance

## Location
- **File(s)**: `lib/handlers/config_handler.dart`
- **Line(s)**: 82-82
- **Method/Widget**: `resetDevice`

## Description


## Why This Matters


## Current Code
```dart
  }

  void resetDevice() {
    dynamic property = getPropertyByVariableName('abort_run');
    if (property != null){
      property.setValue(true);
```

## Suggested Fix


## Implementation Steps


## Additional Resources


## Estimated Effort
15-30 minutes

## Analysis Confidence
High
