# Issue: Magic Numbers

## Severity: Low

## Category: Maintenance

## Location
- **File(s)**: `lib/UserInterface/ui.dart`
- **Line(s)**: 37-37
- **Method/Widget**: `withAlpha`

## Description


## Why This Matters


## Current Code
```dart

  Color dialogBtnColor(alpha) => Color.alphaBlend(
    Colors.white.withAlpha((alpha*50).toInt()),
    Colors.blueGrey.withAlpha((alpha*20).toInt())
  );

```

## Suggested Fix


## Implementation Steps


## Additional Resources


## Estimated Effort
15-30 minutes

## Analysis Confidence
High
