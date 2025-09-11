# Issue: Magic Numbers

## Severity: Low

## Category: Maintenance

## Location
- **File(s)**: `lib/UserInterface/ui.dart`
- **Line(s)**: 18-18
- **Method/Widget**: `fromARGB`

## Description


## Why This Matters


## Current Code
```dart

  Color get CoolDown1 => const Color.fromARGB(255, 52, 113, 206);
  Color get CoolDown2 => const Color.fromARGB(255, 53, 130, 245);

  Color alphaCool1(int alpha) => Color.fromARGB(alpha, 52, 113, 206);
  Color alphaCool2(int alpha) => Color.fromARGB(alpha, 53, 130, 245);
```

## Suggested Fix


## Implementation Steps


## Additional Resources


## Estimated Effort
15-30 minutes

## Analysis Confidence
High
