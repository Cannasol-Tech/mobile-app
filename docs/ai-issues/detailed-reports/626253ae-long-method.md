# Issue: Long Method

## Severity: Medium

## Category: Maintenance

## Location
- **File(s)**: `lib/components/icons/warn_icon.dart`
- **Line(s)**: 169-169
- **Method/Widget**: `build`

## Description


## Why This Matters


## Current Code
```dart

  @override
  Widget build(BuildContext context) {
    return Selector<SystemDataModel, (bool, bool, double, double)>(
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
