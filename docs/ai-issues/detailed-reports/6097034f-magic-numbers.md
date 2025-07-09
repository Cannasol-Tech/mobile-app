# Issue: Magic Numbers

## Severity: Low

## Category: Maintenance

## Location
- **File(s)**: `lib/components/icons/arrows.dart`
- **Line(s)**: 187-187
- **Method/Widget**: `Duration`

## Description


## Why This Matters


## Current Code
```dart
          ? MirrorAnimationBuilder(
              tween: ColorTween(begin: Colors.red.withOpacity(0.2), end: Colors.red.withOpacity(1)),
              duration: const Duration(milliseconds: 200),
              curve: Curves.bounceInOut,
              builder: (BuildContext context, Color? color, Widget? child) {
                return ArrowIcon(
```

## Suggested Fix


## Implementation Steps


## Additional Resources


## Estimated Effort
15-30 minutes

## Analysis Confidence
High
