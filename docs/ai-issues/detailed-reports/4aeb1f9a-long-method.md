# Issue: Long Method

## Severity: Medium

## Category: Maintenance

## Location
- **File(s)**: `lib/providers/system_data_provider.dart`
- **Line(s)**: 316-316
- **Method/Widget**: `if`

## Description


## Why This Matters


## Current Code
```dart
          toggleControllers.init(newDeviceData);
      }
      else if (_activeDevice?.status == "ONLINE" && newDeviceData.status == "OFFLINE"){
          textControllers.clear();
          toggleControllers.clear();
      }
```

## Suggested Fix


## Implementation Steps


## Additional Resources


## Estimated Effort
15-30 minutes

## Analysis Confidence
High
