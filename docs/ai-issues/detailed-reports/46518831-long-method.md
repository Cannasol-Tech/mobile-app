# Issue: Long Method

## Severity: Medium

## Category: Maintenance

## Location
- **File(s)**: `lib/components/confirm_dialog.dart`
- **Line(s)**: 7-7
- **Method/Widget**: `build`

## Description


## Why This Matters


## Current Code
```dart
  final void Function() confirmMethod;
  @override
  Widget build (BuildContext context) {
    return TextButton(
      child: const Text("Yes"),
      onPressed: () {
```

## Suggested Fix


## Implementation Steps


## Additional Resources


## Estimated Effort
15-30 minutes

## Analysis Confidence
High
