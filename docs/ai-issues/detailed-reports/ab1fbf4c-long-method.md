# Issue: Long Method

## Severity: Medium

## Category: Maintenance

## Location
- **File(s)**: `lib/components/icons/warn_icon.dart`
- **Line(s)**: 133-133
- **Method/Widget**: `build`

## Description


## Why This Matters


## Current Code
```dart

  @override
  Widget build(BuildContext context) {
    return Selector<SystemDataModel, (bool, bool, double)>(
      selector: (context, systemData) => (
        (systemData.activeDevice == null) ? 
```

## Suggested Fix


## Implementation Steps


## Additional Resources


## Estimated Effort
15-30 minutes

## Analysis Confidence
High
