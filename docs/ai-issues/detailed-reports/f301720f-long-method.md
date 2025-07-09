# Issue: Long Method

## Severity: Medium

## Category: Maintenance

## Location
- **File(s)**: `lib/components/side_menu.dart`
- **Line(s)**: 88-88
- **Method/Widget**: `if`

## Description


## Why This Matters


## Current Code
```dart
    UserHandler userHandler = Provider.of<SystemDataModel>(context, listen: false).userHandler;
    String? deviceId = context.read<SystemDataModel>().devices.nameIdMap[deviceToRemove];
    if (userHandler.selectedDevice == deviceId){
      await userHandler.removeSelectedDevice();
    }
    setState(() {
```

## Suggested Fix


## Implementation Steps


## Additional Resources


## Estimated Effort
15-30 minutes

## Analysis Confidence
High
