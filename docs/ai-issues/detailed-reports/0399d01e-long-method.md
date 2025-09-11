# Issue: Long Method

## Severity: Medium

## Category: Maintenance

## Location
- **File(s)**: `lib/components/icons/arrows.dart`
- **Line(s)**: 165-165
- **Method/Widget**: `build`

## Description


## Why This Matters


## Current Code
```dart

  @override
  Widget build(BuildContext context) {
    UI ui = userInterface(context);
    return Selector<SystemDataModel, AlarmsModel>(
      selector: (xXx, p) => (p.activeDevice?.alarms ?? AlarmsModel()),
```

## Suggested Fix


## Implementation Steps


## Additional Resources


## Estimated Effort
15-30 minutes

## Analysis Confidence
High
