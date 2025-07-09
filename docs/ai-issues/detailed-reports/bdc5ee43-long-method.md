# Issue: Long Method

## Severity: Medium

## Category: Maintenance

## Location
- **File(s)**: `lib/handlers/alarm_logs.dart`
- **Line(s)**: 75-75
- **Method/Widget**: `fromMap`

## Description


## Why This Matters


## Current Code
```dart
  }

  factory AlarmLogsModel.fromMap(Map<dynamic, dynamic> data) {
    // Build list from raw map
    List<AlarmLog> alarmLogs = [
      for (var entry in data.entries) 
```

## Suggested Fix


## Implementation Steps


## Additional Resources


## Estimated Effort
15-30 minutes

## Analysis Confidence
High
