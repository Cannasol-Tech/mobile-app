# Issue: Long Method

## Severity: Medium

## Category: Maintenance

## Location
- **File(s)**: `lib/shared/types.dart`
- **Line(s)**: 13-13
- **Method/Widget**: `toTitleCase`

## Description


## Why This Matters


## Current Code
```dart
// Extension on String for Title Case
extension StringExtensions on String {
  String toTitleCase() {
    if (isEmpty) return this;
    return split(' ')
        .map((word) =>
```

## Suggested Fix


## Implementation Steps


## Additional Resources


## Estimated Effort
15-30 minutes

## Analysis Confidence
High
