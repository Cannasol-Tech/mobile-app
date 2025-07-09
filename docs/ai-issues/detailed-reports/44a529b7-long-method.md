# Issue: Long Method

## Severity: Medium

## Category: Maintenance

## Location
- **File(s)**: `lib/components/icons/warn_icon.dart`
- **Line(s)**: 196-196
- **Method/Widget**: `getWarnIcon`

## Description


## Why This Matters


## Current Code
```dart


Widget getWarnIcon(context, activeDevice, sysElement) {
  return (sysElement.type == "Tank") ? const TempWarnIcon()
      : (sysElement.type == "Flow") ? const FlowWarnIcon()
      : (sysElement.type == "Air") || (sysElement.type.contains("Sonic")) ? const PressureWarnIcon() 
```

## Suggested Fix


## Implementation Steps


## Additional Resources


## Estimated Effort
15-30 minutes

## Analysis Confidence
High
