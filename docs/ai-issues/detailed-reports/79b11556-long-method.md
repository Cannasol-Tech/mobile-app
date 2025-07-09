# Issue: Long Method

## Severity: Medium

## Category: Maintenance

## Location
- **File(s)**: `lib/components/time_input.dart`
- **Line(s)**: 61-61
- **Method/Widget**: `_parseDuration`

## Description


## Why This Matters


## Current Code
```dart
  }

  Duration _parseDuration(String value) {
    List<String> parts = value.split(':');
    int hours = int.parse(parts[0]);
    int minutes = int.parse(parts[1]);
```

## Suggested Fix


## Implementation Steps


## Additional Resources


## Estimated Effort
15-30 minutes

## Analysis Confidence
High
