# Issue: Magic Numbers

## Severity: Low

## Category: Maintenance

## Location
- **File(s)**: `lib/shared/snacks.dart`
- **Line(s)**: 28-28
- **Method/Widget**: `fromARGB`

## Description


## Why This Matters


## Current Code
```dart
SnackBar redSnack({String msg = ''}) => baseSnack(
  msg: msg, 
  color: const Color.fromARGB(190, 155, 25, 11),
);

SnackBar cantDownloadSnack(almNt) => redSnack(
```

## Suggested Fix


## Implementation Steps


## Additional Resources


## Estimated Effort
15-30 minutes

## Analysis Confidence
High
