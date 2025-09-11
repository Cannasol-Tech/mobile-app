# Issue: Long Method

## Severity: Medium

## Category: Maintenance

## Location
- **File(s)**: `lib/handlers/alarm_logs.dart`
- **Line(s)**: 38-38
- **Method/Widget**: `_epochToString`

## Description


## Why This Matters


## Current Code
```dart

  /// Utility method that converts "seconds since epoch" into a readable string.
  static String _epochToString(int epochSeconds) {
    if (epochSeconds == 0) {
      return "N/A";
    }
```

## Suggested Fix


## Implementation Steps


## Additional Resources


## Estimated Effort
15-30 minutes

## Analysis Confidence
High
