# Issue: Long Method

## Severity: Medium

## Category: Maintenance

## Location
- **File(s)**: `lib/controllers/text_controllers.dart`
- **Line(s)**: 79-79
- **Method/Widget**: `if`

## Description


## Why This Matters


## Current Code
```dart
        setTempController.text = displayDouble(newConfig.setTemp, 1);   
      }
      if (newDeviceData.id != activeDevice.id){
        registerDeviceController.text = newDeviceData.id.toString();     
      }
      if (newState.state != activeState.state){
```

## Suggested Fix


## Implementation Steps


## Additional Resources


## Estimated Effort
15-30 minutes

## Analysis Confidence
High
