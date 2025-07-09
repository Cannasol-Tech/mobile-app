# Issue: Long Method

## Severity: Medium

## Category: Maintenance

## Location
- **File(s)**: `lib/providers/system_data_provider.dart`
- **Line(s)**: 306-306
- **Method/Widget**: `updateDataControllers`

## Description


## Why This Matters


## Current Code
```dart
  }

  void updateDataControllers(dynamic newDeviceData) {
    if (newDeviceData != null && newDeviceData.name != 'None'){
      if (_activeDevice == null || _activeDevice?.name == "None"){
        textControllers.init(newDeviceData);
```

## Suggested Fix


## Implementation Steps


## Additional Resources


## Estimated Effort
15-30 minutes

## Analysis Confidence
High
