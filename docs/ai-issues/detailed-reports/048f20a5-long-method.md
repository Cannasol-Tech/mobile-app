# Issue: Long Method

## Severity: Medium

## Category: Maintenance

## Location
- **File(s)**: `lib/handlers/state_handler.dart`
- **Line(s)**: 49-49
- **Method/Widget**: `setRunTime`

## Description


## Why This Matters


## Current Code
```dart
  }

  void setRunTime(runSeconds){
    //Simulation Purposes only!
    if ([properties['run_hours'], properties['run_minutes'], properties['run_seconds']]
      .any((element) => element == null)) {
```

## Suggested Fix


## Implementation Steps


## Additional Resources


## Estimated Effort
15-30 minutes

## Analysis Confidence
High
