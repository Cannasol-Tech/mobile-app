# Issue: Magic Numbers

## Severity: Low

## Category: Maintenance

## Location
- **File(s)**: `lib/components/sensor_display/sensor_display.dart`
- **Line(s)**: 66-66
- **Method/Widget**: `alphaWarn`

## Description


## Why This Matters


## Current Code
```dart

mixin SensorDisplayDesign on StatelessWidget {
  Color get warnColor => ui.colors.alphaWarn(225);
  Color get alarmColor => ui.colors.alphaAlarm(200);
  Color get noAlarmColor => ui.colors.noAlarm;
  Color Function(bool, bool) get boxColor => (alarm, warn) => alarm ? alarmColor : warn ? warnColor : noAlarmColor;
```

## Suggested Fix


## Implementation Steps


## Additional Resources


## Estimated Effort
15-30 minutes

## Analysis Confidence
High
