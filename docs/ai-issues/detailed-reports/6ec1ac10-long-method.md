# Issue: Long Method

## Severity: Medium

## Category: Maintenance

## Location
- **File(s)**: `lib/dialogs/terms_and_conditions.dart`
- **Line(s)**: 132-132
- **Method/Widget**: `then`

## Description


## Why This Matters


## Current Code
```dart
                context.read<SystemDataModel>().userHandler.acceptTaC();
                scalarController.playReverse(duration: const Duration(milliseconds:  300))
                .then((_) {
                  Navigator.of(context).popUntil(ModalRoute.withName('/'));
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const HomePage()
```

## Suggested Fix


## Implementation Steps


## Additional Resources


## Estimated Effort
15-30 minutes

## Analysis Confidence
High
