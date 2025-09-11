# Issue: Magic Numbers

## Severity: Low

## Category: Maintenance

## Location
- **File(s)**: `lib/shared/banners.dart`
- **Line(s)**: 50-50
- **Method/Widget**: `withAlpha`

## Description


## Why This Matters


## Current Code
```dart
      content: widget.displayContent,
      elevation: scalar.value*20,
      backgroundColor: widget.bgColor.withAlpha(scalar.value*170),
      shadowColor: widget.bgColor.withAlpha(scalar.value*200),
      actions: widget.actions,
      animation: CurvedAnimation(parent: scalarController, curve: Curves.elasticOut),
```

## Suggested Fix


## Implementation Steps


## Additional Resources


## Estimated Effort
15-30 minutes

## Analysis Confidence
High
