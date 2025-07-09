# Issue: Long Method

## Severity: Medium

## Category: Maintenance

## Location
- **File(s)**: `lib/handlers/current_run.dart`
- **Line(s)**: 27-27
- **Method/Widget**: `for`

## Description


## Why This Matters


## Current Code
```dart
    DbMap data = getDbMap(snap);
    CurrentRunModel currentRun = CurrentRunModel();
    for (var propertyName in ['start_time', 'end_time', 'start_user']){
      DatabaseReference propertyRef = snap.child(propertyName).ref;
      MapEntry entry = data.entries.firstWhere(
        (entry) => entry.key == propertyName,
```

## Suggested Fix


## Implementation Steps


## Additional Resources


## Estimated Effort
15-30 minutes

## Analysis Confidence
High
