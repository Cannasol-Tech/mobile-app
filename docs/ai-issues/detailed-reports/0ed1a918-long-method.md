# Issue: Long Method

## Severity: Medium

## Category: Maintenance

## Location
- **File(s)**: `lib/handlers/current_run.dart`
- **Line(s)**: 24-24
- **Method/Widget**: `fromDatabase`

## Description


## Why This Matters


## Current Code
```dart
  late Map<String, dynamic> native;

  factory CurrentRunModel.fromDatabase(DataSnapshot snap){
    DbMap data = getDbMap(snap);
    CurrentRunModel currentRun = CurrentRunModel();
    for (var propertyName in ['start_time', 'end_time', 'start_user']){
```

## Suggested Fix


## Implementation Steps


## Additional Resources


## Estimated Effort
15-30 minutes

## Analysis Confidence
High
