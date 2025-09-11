# Issue: Long Method

## Severity: Medium

## Category: Maintenance

## Location
- **File(s)**: `lib/providers/system_data_provider.dart`
- **Line(s)**: 213-213
- **Method/Widget**: `if`

## Description


## Why This Matters


## Current Code
```dart
  void startUpdateDataTimer() {
    log.info("DEBUG -> Starting update data timer");
    if (_timers.updateDataTimer == null){
      _timers.updateDataTimer = Timer.periodic(
        Duration(milliseconds: (_timers.updateSeconds*1000).toInt()),
       ((Timer t) {updateData(); }));
```

## Suggested Fix


## Implementation Steps


## Additional Resources


## Estimated Effort
15-30 minutes

## Analysis Confidence
High
