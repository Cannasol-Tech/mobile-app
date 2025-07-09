# Issue: Long Method

## Severity: Medium

## Category: Maintenance

## Location
- **File(s)**: `lib/components/system_images/system_image.dart`
- **Line(s)**: 50-50
- **Method/Widget**: `switch`

## Description


## Why This Matters


## Current Code
```dart
        final bool active = data.active;

        switch (state) {
          case WARM_UP:
            colorStart = const Color.fromARGB(255, 255, 124, 124).withOpacity(0.01);
            colorEnd = const Color.fromARGB(255, 255, 50, 50).withOpacity(0.1);
```

## Suggested Fix


## Implementation Steps


## Additional Resources


## Estimated Effort
15-30 minutes

## Analysis Confidence
High
