# Issue: Long Method

## Severity: Medium

## Category: Maintenance

## Location
- **File(s)**: `lib/controllers/toggle_controllers.dart`
- **Line(s)**: 58-58
- **Method/Widget**: `if`

## Description


## Why This Matters


## Current Code
```dart
    dynamic newAlarms = newDeviceData.alarms;

    if (newDeviceData != null && activeDevice != null){
      if (newConfig.enableCooldown != activeConfig.enableCooldown){
        enableCooldown.value = newConfig.enableCooldown;     
      }
```

## Suggested Fix


## Implementation Steps


## Additional Resources


## Estimated Effort
15-30 minutes

## Analysis Confidence
High
