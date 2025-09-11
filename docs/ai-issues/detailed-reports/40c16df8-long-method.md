# Issue: Long Method

## Severity: Medium

## Category: Maintenance

## Location
- **File(s)**: `lib/components/slot_card.dart`
- **Line(s)**: 11-11
- **Method/Widget**: `toCapital`

## Description


## Why This Matters


## Current Code
```dart

extension StringExtension on String {
  String toCapital() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}
```

## Suggested Fix


## Implementation Steps


## Additional Resources


## Estimated Effort
15-30 minutes

## Analysis Confidence
High
