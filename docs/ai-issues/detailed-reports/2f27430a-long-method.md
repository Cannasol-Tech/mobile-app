# Issue: Long Method

## Severity: Medium

## Category: Maintenance

## Location
- **File(s)**: `lib/api/firebase_api.dart`
- **Line(s)**: 91-91
- **Method/Widget**: `if`

## Description


## Why This Matters


## Current Code
```dart
    message.notification != null ? log.info("debug -> mesage title = ${message.notification?.title}") : null;

    if (message.notification != null){
      if (['System Alarm!'].contains(message.notification?.title)){
        AlarmNotification(deviceId: message.data['deviceId'], alarmName: message.data['alarm']).showAlarmBanner();
      }
```

## Suggested Fix


## Implementation Steps


## Additional Resources


## Estimated Effort
15-30 minutes

## Analysis Confidence
High
