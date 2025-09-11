# Issue: Long Method

## Severity: Medium

## Category: Maintenance

## Location
- **File(s)**: `lib/handlers/config_handler.dart`
- **Line(s)**: 57-57
- **Method/Widget**: `ConfigHandler`

## Description


## Why This Matters


## Current Code
```dart
  double get currSetTemp => (device.state.state != COOL_DOWN) ? setTemp : cooldownTemp;

  ConfigHandler({this.device}) {
    device = device;
  }

```

## Suggested Fix


## Implementation Steps


## Additional Resources


## Estimated Effort
15-30 minutes

## Analysis Confidence
High
