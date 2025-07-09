# Issue: Long Method

## Severity: Medium

## Category: Maintenance

## Location
- **File(s)**: `lib/main.dart`
- **Line(s)**: 67-67
- **Method/Widget**: `microtask`

## Description


## Why This Matters


## Current Code
```dart
  Widget build(BuildContext context) {
    bool loggedIn = Provider.of<CurrentUser>(context) != null;
    Future.microtask(() {
      context.read<DisplayDataModel>().setBottomNavSelectedItem(0);
    });
    return  MaterialApp(
```

## Suggested Fix


## Implementation Steps


## Additional Resources


## Estimated Effort
15-30 minutes

## Analysis Confidence
High
