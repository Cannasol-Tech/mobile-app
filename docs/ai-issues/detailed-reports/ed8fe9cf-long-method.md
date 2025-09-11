# Issue: Long Method

## Severity: Medium

## Category: Maintenance

## Location
- **File(s)**: `lib/pages/home/run_page.dart`
- **Line(s)**: 76-76
- **Method/Widget**: `if`

## Description


## Why This Matters


## Current Code
```dart

  void _onSwipe(Direction swipeDir) {
    if (swipeDir == Direction.left) {
      context.read<SystemIdx>().increment();
    } 
    else if (swipeDir == Direction.right) {
```

## Suggested Fix


## Implementation Steps


## Additional Resources


## Estimated Effort
15-30 minutes

## Analysis Confidence
High
