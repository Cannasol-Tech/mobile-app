# Issue: Long Method

## Severity: Medium

## Category: Maintenance

## Location
- **File(s)**: `lib/controllers/text_controllers.dart`
- **Line(s)**: 73-73
- **Method/Widget**: `if`

## Description


## Why This Matters


## Current Code
```dart

    if (activeDevice != null && newDeviceData != null){
      if (newConfig.batchSize != activeConfig.batchSize){
        batchSizeController.text = displayDouble(newConfig.batchSize, 1);     
      }
      if (newConfig.setTemp != activeConfig.setTemp){
```

## Suggested Fix


## Implementation Steps


## Additional Resources


## Estimated Effort
15-30 minutes

## Analysis Confidence
High
