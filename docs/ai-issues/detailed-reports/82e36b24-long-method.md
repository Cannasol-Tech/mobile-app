# Issue: Long Method

## Severity: Medium

## Category: Maintenance

## Location
- **File(s)**: `lib/handlers/alarm_logs.dart`
- **Line(s)**: 39-39
- **Method/Widget**: `if`

## Description


## Why This Matters


## Current Code
```dart
  /// Utility method that converts "seconds since epoch" into a readable string.
  static String _epochToString(int epochSeconds) {
    if (epochSeconds == 0) {
      return "N/A";
    }
    final dateTime = DateTime.fromMillisecondsSinceEpoch(epochSeconds * 1000);
```

## Suggested Fix


## Implementation Steps


## Additional Resources


## Estimated Effort
15-30 minutes

## Analysis Confidence
High
