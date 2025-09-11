# Issue: Magic Numbers

## Severity: Low

## Category: Maintenance

## Location
- **File(s)**: `lib/providers/system_data_provider.dart`
- **Line(s)**: 215-215
- **Method/Widget**: `Duration`

## Description


## Why This Matters


## Current Code
```dart
    if (_timers.updateDataTimer == null){
      _timers.updateDataTimer = Timer.periodic(
        Duration(milliseconds: (_timers.updateSeconds*1000).toInt()),
       ((Timer t) {updateData(); }));
       updatingData = true;
    }
```

## Suggested Fix


## Implementation Steps


## Additional Resources


## Estimated Effort
15-30 minutes

## Analysis Confidence
High
