# Issue: Long Method

## Severity: Medium

## Category: Maintenance

## Location
- **File(s)**: `lib/handlers/alarm_handler.dart`
- **Line(s)**: 180-180
- **Method/Widget**: `getActiveSonicAlarmCount`

## Description


## Why This Matters


## Current Code
```dart
  }

  int getActiveSonicAlarmCount () {
    int alarmCount = 0;
    List<bool> sonicAlarms = [pressureAlarm, overloadAlarm, freqLockAlarm];
    List<bool> sonicIgnore = [ignorePressureAlarm, ignoreOverloadAlarm, ignoreFreqLockAlarm];
```

## Suggested Fix


## Implementation Steps


## Additional Resources


## Estimated Effort
15-30 minutes

## Analysis Confidence
High
