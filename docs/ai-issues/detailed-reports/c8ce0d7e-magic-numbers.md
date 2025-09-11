# Issue: Magic Numbers

## Severity: Low

## Category: Maintenance

## Location
- **File(s)**: `lib/components/system_images/system_image.dart`
- **Line(s)**: 65-65
- **Method/Widget**: `fromARGB`

## Description


## Why This Matters


## Current Code
```dart
            break;
          case COOL_DOWN:
            colorStart = const Color.fromARGB(255, 80, 184, 232).withOpacity(0.2);
            colorEnd = const Color.fromARGB(255, 75, 190, 243).withOpacity(0.55);
            break;
          default:
```

## Suggested Fix


## Implementation Steps


## Additional Resources


## Estimated Effort
15-30 minutes

## Analysis Confidence
High
