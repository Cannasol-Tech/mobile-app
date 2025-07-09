# Issue: Long Method

## Severity: Medium

## Category: Maintenance

## Location
- **File(s)**: `lib/main.dart`
- **Line(s)**: 65-65
- **Method/Widget**: `build`

## Description


## Why This Matters


## Current Code
```dart
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    bool loggedIn = Provider.of<CurrentUser>(context) != null;
    Future.microtask(() {
      context.read<DisplayDataModel>().setBottomNavSelectedItem(0);
```

## Suggested Fix


## Implementation Steps


## Additional Resources


## Estimated Effort
15-30 minutes

## Analysis Confidence
High
