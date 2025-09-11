# Issue: Magic Numbers

## Severity: Low

## Category: Maintenance

## Location
- **File(s)**: `lib/components/system_images/system_image.dart`
- **Line(s)**: 58-58
- **Method/Widget**: `fromARGB`

## Description


## Why This Matters


## Current Code
```dart
            if (active) {
              colorStart = const Color.fromARGB(0, 255, 0, 0).withOpacity(0.0);
              colorEnd = const Color.fromARGB(255, 255, 0, 0).withOpacity(0.6);
            } else {
              colorStart = Colors.white.withOpacity(0.01);
              colorEnd = Colors.white.withOpacity(0.12);
```

## Suggested Fix


## Implementation Steps


## Additional Resources


## Estimated Effort
15-30 minutes

## Analysis Confidence
High
