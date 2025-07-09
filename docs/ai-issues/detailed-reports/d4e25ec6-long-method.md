# Issue: Long Method

## Severity: Medium

## Category: Maintenance

## Location
- **File(s)**: `lib/data_models/data.dart`
- **Line(s)**: 43-43
- **Method/Widget**: `for`

## Description


## Why This Matters


## Current Code
```dart
    await _devicesRef.once().then((event) {
      if (event.snapshot.exists){
        for (var child in event.snapshot.children){
          if (child.exists && child.hasChild('Info/name')){
            var id = child.key.toString();
            var name = child.child('Info/name').value.toString();
```

## Suggested Fix


## Implementation Steps


## Additional Resources


## Estimated Effort
15-30 minutes

## Analysis Confidence
High
