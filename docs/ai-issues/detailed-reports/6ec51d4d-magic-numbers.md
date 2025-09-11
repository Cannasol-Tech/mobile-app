# Issue: Magic Numbers

## Severity: Low

## Category: Maintenance

## Location
- **File(s)**: `lib/shared/time.dart`
- **Line(s)**: 4-4
- **Method/Widget**: `twoDigits`

## Description


## Why This Matters


## Current Code
```dart
String formatDuration(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, '0');
  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
  return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
}
```

## Suggested Fix


## Implementation Steps


## Additional Resources


## Estimated Effort
15-30 minutes

## Analysis Confidence
High
