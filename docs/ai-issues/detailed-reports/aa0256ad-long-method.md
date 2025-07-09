# Issue: Long Method

## Severity: Medium

## Category: Maintenance

## Location
- **File(s)**: `lib/data_models/data.dart`
- **Line(s)**: 61-61
- **Method/Widget**: `listen`

## Description


## Why This Matters


## Current Code
```dart
      }
    });
    _removedListener = _devicesRef.onChildRemoved.listen((event) {
      if (event.snapshot.exists && event.snapshot.hasChild('Info/name')){
        var id = event.snapshot.key.toString();
        var name = event.snapshot.child('Info/name').value.toString();
```

## Suggested Fix


## Implementation Steps


## Additional Resources


## Estimated Effort
15-30 minutes

## Analysis Confidence
High
