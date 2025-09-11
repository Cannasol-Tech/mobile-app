# Issue: Long Method

## Severity: Medium

## Category: Maintenance

## Location
- **File(s)**: `lib/components/system_images/system_image.dart`
- **Line(s)**: 115-115
- **Method/Widget**: `fadeFilteredImage`

## Description


## Why This Matters


## Current Code
```dart


  ColorFiltered fadeFilteredImage(double aspectRatio, Color? color) {
    return ColorFiltered(
      colorFilter: fadeColorFilter(color),
      child: systemImage(aspectRatio),
```

## Suggested Fix


## Implementation Steps


## Additional Resources


## Estimated Effort
15-30 minutes

## Analysis Confidence
High
