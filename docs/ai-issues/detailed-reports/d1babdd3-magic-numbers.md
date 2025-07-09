# Issue: Magic Numbers

## Severity: Low

## Category: Maintenance

## Location
- **File(s)**: `lib/shared/snacks.dart`
- **Line(s)**: 23-23
- **Method/Widget**: `fromARGB`

## Description


## Why This Matters


## Current Code
```dart
SnackBar greenSnack({String msg = ''}) => baseSnack(
  msg: msg, 
  color: const Color.fromARGB(175, 25, 91, 11)
);

SnackBar redSnack({String msg = ''}) => baseSnack(
```

## Suggested Fix


## Implementation Steps


## Additional Resources


## Estimated Effort
15-30 minutes

## Analysis Confidence
High
