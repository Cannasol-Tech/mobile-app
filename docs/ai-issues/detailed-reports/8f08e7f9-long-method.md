# Issue: Long Method

## Severity: Medium

## Category: Maintenance

## Location
- **File(s)**: `lib/handlers/history_logs.dart`
- **Line(s)**: 101-101
- **Method/Widget**: `_formatDuration`

## Description


## Why This Matters


## Current Code
```dart
  }

  String _formatDuration() {
    String hours = runHours.toString().padLeft(2, '0');
    String minutes = runMinutes.toString().padLeft(2, '0');
    String seconds = runSeconds.toString().padLeft(2, '0');
```

## Suggested Fix


## Implementation Steps


## Additional Resources


## Estimated Effort
15-30 minutes

## Analysis Confidence
High
