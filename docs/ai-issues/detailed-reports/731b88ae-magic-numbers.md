# Issue: Magic Numbers

## Severity: Low

## Category: Maintenance

## Location
- **File(s)**: `lib/components/system_images/system_image.dart`
- **Line(s)**: 66-66
- **Method/Widget**: `fromARGB`

## Description


## Why This Matters


## Current Code
```dart
          case COOL_DOWN:
            colorStart = const Color.fromARGB(255, 80, 184, 232).withOpacity(0.2);
            colorEnd = const Color.fromARGB(255, 75, 190, 243).withOpacity(0.55);
            break;
          default:
            colorStart = Colors.white.withOpacity(0.01);
```

## Suggested Fix


## Implementation Steps


## Additional Resources


## Estimated Effort
15-30 minutes

## Analysis Confidence
High
