# Issue: Long Method

## Severity: Medium

## Category: Maintenance

## Location
- **File(s)**: `lib/UserInterface/icons.dart`
- **Line(s)**: 132-132
- **Method/Widget**: `if`

## Description


## Why This Matters


## Current Code
```dart
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    // Paint only the arrow "outline" using a stroke.
    if (side.style != BorderStyle.none) {
      final paint = side.toPaint()
        ..style = PaintingStyle.stroke;

```

## Suggested Fix


## Implementation Steps


## Additional Resources


## Estimated Effort
15-30 minutes

## Analysis Confidence
High
