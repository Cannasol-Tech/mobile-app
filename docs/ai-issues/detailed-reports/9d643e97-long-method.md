# Issue: Long Method

## Severity: Medium

## Category: Maintenance

## Location
- **File(s)**: `lib/controllers/text_controllers.dart`
- **Line(s)**: 72-72
- **Method/Widget**: `if`

## Description


## Why This Matters


## Current Code
```dart
    dynamic newState = newDeviceData.state;

    if (activeDevice != null && newDeviceData != null){
      if (newConfig.batchSize != activeConfig.batchSize){
        batchSizeController.text = displayDouble(newConfig.batchSize, 1);     
      }
```

## Suggested Fix


## Implementation Steps


## Additional Resources


## Estimated Effort
15-30 minutes

## Analysis Confidence
High
