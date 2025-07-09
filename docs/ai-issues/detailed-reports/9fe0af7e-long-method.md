# Issue: Long Method

## Severity: Medium

## Category: Maintenance

## Location
- **File(s)**: `lib/components/side_menu.dart`
- **Line(s)**: 114-114
- **Method/Widget**: `for`

## Description


## Why This Matters


## Current Code
```dart
        Map<String, TextStyle> styleMap = {};
        Map<String, String> deviceStatusMap = Provider.of<SystemDataModel>(context, listen: true).registeredDeviceStatus;
        for (var entry in deviceStatusMap.entries){
            styleMap[entry.key] = TextStyle(color: (entry.value == "ONLINE") ? Colors.green : Colors.red);
        }
        return Drawer(
```

## Suggested Fix


## Implementation Steps


## Additional Resources


## Estimated Effort
15-30 minutes

## Analysis Confidence
High
