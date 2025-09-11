# Issue: Long Method

## Severity: Medium

## Category: Maintenance

## Location
- **File(s)**: `lib/pages/home/current_run_page.dart`
- **Line(s)**: 34-34
- **Method/Widget**: `build`

## Description


## Why This Matters


## Current Code
```dart
  
  @override
  Widget build(BuildContext context) {
    return Selector<SystemDataModel, int>(
     selector: (_, model) => model.activeDeviceState,
      shouldRebuild: (previous, next) => rebuildFilter(previous, next), 
```

## Suggested Fix


## Implementation Steps


## Additional Resources


## Estimated Effort
15-30 minutes

## Analysis Confidence
High
