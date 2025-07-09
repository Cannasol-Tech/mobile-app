# Issue: Long Method

## Severity: Medium

## Category: Maintenance

## Location
- **File(s)**: `lib/UserInterface/icons.dart`
- **Line(s)**: 130-130
- **Method/Widget**: `paint`

## Description


## Why This Matters


## Current Code
```dart

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    // Paint only the arrow "outline" using a stroke.
    if (side.style != BorderStyle.none) {
      final paint = side.toPaint()
```

## Suggested Fix


## Implementation Steps


## Additional Resources


## Estimated Effort
15-30 minutes

## Analysis Confidence
High
