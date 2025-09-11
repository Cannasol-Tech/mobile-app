# Issue: Magic Numbers

## Severity: Low

## Category: Maintenance

## Location
- **File(s)**: `lib/dialogs/terms_and_conditions.dart`
- **Line(s)**: 131-131
- **Method/Widget**: `playReverse`

## Description


## Why This Matters


## Current Code
```dart
              if (_chkAccepted) {
                context.read<SystemDataModel>().userHandler.acceptTaC();
                scalarController.playReverse(duration: const Duration(milliseconds:  300))
                .then((_) {
                  Navigator.of(context).popUntil(ModalRoute.withName('/'));
                  Navigator.of(context).push(MaterialPageRoute(
```

## Suggested Fix


## Implementation Steps


## Additional Resources


## Estimated Effort
15-30 minutes

## Analysis Confidence
High
