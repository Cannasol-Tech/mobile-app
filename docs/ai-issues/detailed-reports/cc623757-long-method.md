# Issue: Long Method

## Severity: Medium

## Category: Maintenance

## Location
- **File(s)**: `lib/controllers/text_controllers.dart`
- **Line(s)**: 76-76
- **Method/Widget**: `if`

## Description


## Why This Matters


## Current Code
```dart
        batchSizeController.text = displayDouble(newConfig.batchSize, 1);     
      }
      if (newConfig.setTemp != activeConfig.setTemp){
        setTempController.text = displayDouble(newConfig.setTemp, 1);   
      }
      if (newDeviceData.id != activeDevice.id){
```

## Suggested Fix


## Implementation Steps


## Additional Resources


## Estimated Effort
15-30 minutes

## Analysis Confidence
High
