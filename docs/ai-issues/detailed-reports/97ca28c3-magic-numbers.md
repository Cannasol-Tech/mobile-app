# Issue: Magic Numbers

## Severity: Low

## Category: Maintenance

## Location
- **File(s)**: `lib/pages/home/run_page.dart`
- **Line(s)**: 86-86
- **Method/Widget**: `_onSwipe`

## Description


## Why This Matters


## Current Code
```dart
  dynamic readSwipe(event) => (
      (event.primaryVelocity! < -200) ? _onSwipe(Direction.left) 
    : (event.primaryVelocity! > 200) ? _onSwipe(Direction.right) : null  
  );

  Widget getSysDisplay(idx) {
```

## Suggested Fix


## Implementation Steps


## Additional Resources


## Estimated Effort
15-30 minutes

## Analysis Confidence
High
