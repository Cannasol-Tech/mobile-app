# Issue: Long Method

## Severity: Medium

## Category: Maintenance

## Location
- **File(s)**: `lib/providers/system_data_provider.dart`
- **Line(s)**: 307-307
- **Method/Widget**: `if`

## Description


## Why This Matters


## Current Code
```dart

  void updateDataControllers(dynamic newDeviceData) {
    if (newDeviceData != null && newDeviceData.name != 'None'){
      if (_activeDevice == null || _activeDevice?.name == "None"){
        textControllers.init(newDeviceData);
        toggleControllers.init(newDeviceData);
```

## Suggested Fix


## Implementation Steps


## Additional Resources


## Estimated Effort
15-30 minutes

## Analysis Confidence
High
