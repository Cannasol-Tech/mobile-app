# Issue: Magic Numbers

## Severity: Low

## Category: Maintenance

## Location
- **File(s)**: `lib/components/system_images/system_image.dart`
- **Line(s)**: 53-53
- **Method/Widget**: `fromARGB`

## Description


## Why This Matters


## Current Code
```dart
          case WARM_UP:
            colorStart = const Color.fromARGB(255, 255, 124, 124).withOpacity(0.01);
            colorEnd = const Color.fromARGB(255, 255, 50, 50).withOpacity(0.1);
            break;
          case ALARM:
            if (active) {
```

## Suggested Fix


## Implementation Steps


## Additional Resources


## Estimated Effort
15-30 minutes

## Analysis Confidence
High
