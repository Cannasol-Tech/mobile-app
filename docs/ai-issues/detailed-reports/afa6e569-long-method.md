# Issue: Long Method

## Severity: Medium

## Category: Maintenance

## Location
- **File(s)**: `lib/components/icons/warn_icon.dart`
- **Line(s)**: 21-21
- **Method/Widget**: `sysWarning`

## Description


## Why This Matters


## Current Code
```dart
}

Widget sysWarning(BuildContext context, String paramName, minVal, maxVal, units) {
  String warnTxt = warnText(paramName, minVal, maxVal, units);
  return AlertDialog(
    title: const Text('Warning!'),
```

## Suggested Fix


## Implementation Steps


## Additional Resources


## Estimated Effort
15-30 minutes

## Analysis Confidence
High
