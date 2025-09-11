# Issue: Magic Numbers

## Severity: Low

## Category: Maintenance

## Location
- **File(s)**: `lib/shared/banners.dart`
- **Line(s)**: 69-69
- **Method/Widget**: `fromARGB`

## Description


## Why This Matters


## Current Code
```dart
  List<SnackBarAction>? actions}) => BannerNotification(
  displayContent: bannerContent(displayText),
  bgColor: const Color.fromARGB(189, 15, 158, 79),
  actions: actions ?? [dismissAction]
);

```

## Suggested Fix


## Implementation Steps


## Additional Resources


## Estimated Effort
15-30 minutes

## Analysis Confidence
High
