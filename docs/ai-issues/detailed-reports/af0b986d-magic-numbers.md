# Issue: Magic Numbers

## Severity: Low

## Category: Maintenance

## Location
- **File(s)**: `lib/UserInterface/ui.dart`
- **Line(s)**: 78-78
- **Method/Widget**: `of`

## Description


## Why This Matters


## Current Code
```dart
  double get displayWidth => MediaQuery.of(_ctx!).size.width;  
  double get displayHeight => MediaQuery.of(_ctx!).size.height;
  double get maxWidth => displayWidth < 325 ? displayWidth*0.9 : 350;

  double get boxHeight => (isPortrait) ? displayHeight*0.06 : displayHeight*0.10;

```

## Suggested Fix


## Implementation Steps


## Additional Resources


## Estimated Effort
15-30 minutes

## Analysis Confidence
High
