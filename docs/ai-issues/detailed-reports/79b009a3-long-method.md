# Issue: Long Method

## Severity: Medium

## Category: Maintenance

## Location
- **File(s)**: `lib/pages/register_device.dart`
- **Line(s)**: 38-38
- **Method/Widget**: `registerDevice`

## Description


## Why This Matters


## Current Code
```dart
    }
  }
  void registerDevice(BuildContext context, SystemDataModel value){
    String deviceId = value.textControllers.registerDeviceController.text;
    if (context.read<SystemDataModel>().devices.doesDeviceExist(deviceId)){
      Provider.of<SystemDataModel>(context, listen: false).userHandler.watchDevice(context, deviceId);
```

## Suggested Fix


## Implementation Steps


## Additional Resources


## Estimated Effort
15-30 minutes

## Analysis Confidence
High
