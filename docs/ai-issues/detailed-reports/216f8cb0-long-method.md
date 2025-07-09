# Issue: Long Method

## Severity: Medium

## Category: Maintenance

## Location
- **File(s)**: `lib/components/title_text.dart`
- **Line(s)**: 31-31
- **Method/Widget**: `if`

## Description


## Why This Matters


## Current Code
```dart
  Color titleColor, statusColor;
  
  if (activeDevice == null || activeDevice.id == "None") {
    title = "No Device Selected";
    titleColor = Colors.red;
    status = '';
```

## Suggested Fix


## Implementation Steps


## Additional Resources


## Estimated Effort
15-30 minutes

## Analysis Confidence
High
