# Issue: Long Method

## Severity: Medium

## Category: Maintenance

## Location
- **File(s)**: `lib/dialogs/privacy_policy.dart`
- **Line(s)**: 110-110
- **Method/Widget**: `playReverse`

## Description


## Why This Matters


## Current Code
```dart
          style: dialogButtonStyle(colorScalar),
          onPressed: () {
            scalarController.playReverse(duration: const Duration(milliseconds: 250)).then( (_) {
              Navigator.of(context).popUntil(ModalRoute.withName('/'));
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const HomePage()));
            });
```

## Suggested Fix


## Implementation Steps


## Additional Resources


## Estimated Effort
15-30 minutes

## Analysis Confidence
High
