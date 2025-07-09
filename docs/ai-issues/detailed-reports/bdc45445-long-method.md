# Issue: Long Method

## Severity: Medium

## Category: Maintenance

## Location
- **File(s)**: `lib/handlers/registered_devices.dart`
- **Line(s)**: 59-59
- **Method/Widget**: `addDeviceListener`

## Description


## Why This Matters


## Current Code
```dart
  }

  void addDeviceListener(String deviceId) {
    DatabaseReference alarmRef = FirebaseDatabase.instance.ref('/Devices/$deviceId/Info/status');
    if (_deviceListeners.containsKey(deviceId)){
      _deviceListeners[deviceId].cancel();
```

## Suggested Fix


## Implementation Steps


## Additional Resources


## Estimated Effort
15-30 minutes

## Analysis Confidence
High
