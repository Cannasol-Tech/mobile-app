# Issue: Long Method

## Severity: Medium

## Category: Maintenance

## Location
- **File(s)**: `lib/providers/system_data_provider.dart`
- **Line(s)**: 312-312
- **Method/Widget**: `if`

## Description


## Why This Matters


## Current Code
```dart
        toggleControllers.init(newDeviceData);
      }
      else if (_activeDevice?.status == "OFFLINE"){
          textControllers.init(newDeviceData);
          toggleControllers.init(newDeviceData);
      }
```

## Suggested Fix


## Implementation Steps


## Additional Resources


## Estimated Effort
15-30 minutes

## Analysis Confidence
High
