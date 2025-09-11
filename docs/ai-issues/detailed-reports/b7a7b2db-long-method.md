# Issue: Long Method

## Severity: Medium

## Category: Maintenance

## Location
- **File(s)**: `lib/handlers/alarm_handler.dart`
- **Line(s)**: 185-185
- **Method/Widget**: `if`

## Description


## Why This Matters


## Current Code
```dart
    List<bool> sonicIgnore = [ignorePressureAlarm, ignoreOverloadAlarm, ignoreFreqLockAlarm];
    for (int i = 0; i<3; i++) {
      if (sonicAlarms[i] && !sonicIgnore[i]){
        alarmCount++;
      }
    }
```

## Suggested Fix


## Implementation Steps


## Additional Resources


## Estimated Effort
15-30 minutes

## Analysis Confidence
High
