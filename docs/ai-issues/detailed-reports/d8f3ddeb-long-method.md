# Issue: Long Method

## Severity: Medium

## Category: Maintenance

## Location
- **File(s)**: `lib/handlers/alarm_logs.dart`
- **Line(s)**: 26-26
- **Method/Widget**: `fromMap`

## Description


## Why This Matters


## Current Code
```dart

  /// Creates an [AlarmLog] from integer epoch times.
  factory AlarmLog.fromMap(Map<dynamic, dynamic> map) {
    final startEpoch = map["start_time"] ?? 0;
    final clearedEpoch = map["cleared_time"] ?? 0;

```

## Suggested Fix


## Implementation Steps


## Additional Resources


## Estimated Effort
15-30 minutes

## Analysis Confidence
High
