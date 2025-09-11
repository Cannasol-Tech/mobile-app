# Issue: Long Method

## Severity: Medium

## Category: Maintenance

## Location
- **File(s)**: `lib/providers/system_data_provider.dart`
- **Line(s)**: 253-253
- **Method/Widget**: `setSelectedDeviceFromName`

## Description


## Why This Matters


## Current Code
```dart
  }

  void setSelectedDeviceFromName(String deviceName) {
    String deviceId = devices.nameIdMap[deviceName] ??= 'None';
    if (_userHandler.watchedDevices.contains(deviceId) || deviceId == 'None'){
      _userHandler.setSelectedDeviceId(deviceId);
```

## Suggested Fix


## Implementation Steps


## Additional Resources


## Estimated Effort
15-30 minutes

## Analysis Confidence
High
