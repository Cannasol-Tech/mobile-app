# Issue: Long Method

## Severity: Medium

## Category: Maintenance

## Location
- **File(s)**: `lib/providers/system_data_provider.dart`
- **Line(s)**: 373-373
- **Method/Widget**: `if`

## Description


## Why This Matters


## Current Code
```dart
  void updateData() {
    log.info("Updating System Data");
    if (userHandler.initialized && _devices.initialized){
      _activeDeviceHandler.update(userHandler.selectedDevice);
      updateDataControllers(_activeDeviceHandler.device);
      _activeDevice = _activeDeviceHandler.device;
```

## Suggested Fix


## Implementation Steps


## Additional Resources


## Estimated Effort
15-30 minutes

## Analysis Confidence
High
