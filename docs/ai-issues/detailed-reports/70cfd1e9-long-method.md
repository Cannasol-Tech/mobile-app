# Issue: Long Method

## Severity: Medium

## Category: Maintenance

## Location
- **File(s)**: `lib/components/confirm_dialog.dart`
- **Line(s)**: 31-31
- **Method/Widget**: `confirmDialog`

## Description


## Why This Matters


## Current Code
```dart
}

confirmDialog(context, confirmMethod, promptText) {  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: const Text("Notice!"),
    content: Text("Are you sure you want to $promptText?"),
```

## Suggested Fix


## Implementation Steps


## Additional Resources


## Estimated Effort
15-30 minutes

## Analysis Confidence
High
