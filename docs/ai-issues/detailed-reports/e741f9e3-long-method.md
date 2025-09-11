# Issue: Long Method

## Severity: Medium

## Category: Maintenance

## Location
- **File(s)**: `lib/handlers/history_logs.dart`
- **Line(s)**: 49-49
- **Method/Widget**: `fromMap`

## Description


## Why This Matters


## Current Code
```dart
  });

  factory HistoryLog.fromMap(Map<dynamic, dynamic> map, int index) {
    final startEpoch = map["start_time"] ?? 0;
    final endEpoch = map["end_time"] ?? 0;

```

## Suggested Fix


## Implementation Steps


## Additional Resources


## Estimated Effort
15-30 minutes

## Analysis Confidence
High
