# Issue: Long Method

## Severity: Medium

## Category: Maintenance

## Location
- **File(s)**: `lib/handlers/config_handler.dart`
- **Line(s)**: 96-96
- **Method/Widget**: `endRun`

## Description


## Why This Matters


## Current Code
```dart
  }

  void endRun() {
    dynamic property = getPropertyByVariableName('end_run');
    if (property != null) {
      property.setValue(true);
```

## Suggested Fix


## Implementation Steps


## Additional Resources


## Estimated Effort
15-30 minutes

## Analysis Confidence
High
