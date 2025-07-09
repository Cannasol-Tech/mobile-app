# Issue: Long Method

## Severity: Medium

## Category: Maintenance

## Location
- **File(s)**: `lib/UserInterface/ui.dart`
- **Line(s)**: 114-114
- **Method/Widget**: `if`

## Description


## Why This Matters


## Current Code
```dart
    type, ctrl, begin, end, setState
  ) { 
    if (type == int) {
      return AnimationsHdlr().intAnimation(ctrl, begin.toInt(), end.toInt(), setState);
    }
    else if (type == double) {
```

## Suggested Fix


## Implementation Steps


## Additional Resources


## Estimated Effort
15-30 minutes

## Analysis Confidence
High
