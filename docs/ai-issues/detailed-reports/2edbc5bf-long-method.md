# Issue: Long Method

## Severity: Medium

## Category: Maintenance

## Location
- **File(s)**: `lib/components/bottom_nav_bar.dart`
- **Line(s)**: 33-33
- **Method/Widget**: `build`

## Description


## Why This Matters


## Current Code
```dart

  @override
  Widget build(BuildContext context) {
    var displayProvider = context.watch<DisplayDataModel>();
    int bottomNavSelectedItem = displayProvider.bottomNavSelectedItem; 
    return BottomNavigationBar(
```

## Suggested Fix


## Implementation Steps


## Additional Resources


## Estimated Effort
15-30 minutes

## Analysis Confidence
High
