# Issue: Long Method

## Severity: Medium

## Category: Maintenance

## Location
- **File(s)**: `lib/controllers/toggle_controllers.dart`
- **Line(s)**: 21-21
- **Method/Widget**: `init`

## Description


## Why This Matters


## Current Code
```dart
  bool offline = false;

  void init(dynamic newDeviceData){
    dynamic config = newDeviceData.config;
    dynamic alarm = newDeviceData.alarms;
    enableCooldown.value = config.enableCooldown;
```

## Suggested Fix


## Implementation Steps


## Additional Resources


## Estimated Effort
15-30 minutes

## Analysis Confidence
High
