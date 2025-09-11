# Issue: Magic Numbers

## Severity: Low

## Category: Maintenance

## Location
- **File(s)**: `lib/objects/alarm_notification.dart`
- **Line(s)**: 29-29
- **Method/Widget**: `fromARGB`

## Description


## Why This Matters


## Current Code
```dart
      content: Text("${alarmName.toCapital()} on $deviceName!"),
      contentTextStyle: const TextStyle(color: Colors.white60, fontWeight: FontWeight.bold), 
      backgroundColor: const Color.fromARGB(190, 155, 25, 11),
      elevation: 20,
      shadowColor: Colors.black,
      actions: <Widget> [
```

## Suggested Fix


## Implementation Steps


## Additional Resources


## Estimated Effort
15-30 minutes

## Analysis Confidence
High
