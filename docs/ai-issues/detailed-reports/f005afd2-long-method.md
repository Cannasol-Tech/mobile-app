# Issue: Long Method

## Severity: Medium

## Category: Maintenance

## Location
- **File(s)**: `lib/main.dart`
- **Line(s)**: 93-93
- **Method/Widget**: `pop`

## Description


## Why This Matters


## Current Code
```dart
            navigatorKey.currentContext?.read<DisplayDataModel>().setBottomNavSelectedItem(0);
            navigatorKey.currentState?.pop();
            return MaterialPageRoute(
              builder: (context) {
                int idx = alarmToIdxMap[data['alarm']];
                context.read<SystemIdx>().set(idx);  
```

## Suggested Fix


## Implementation Steps


## Additional Resources


## Estimated Effort
15-30 minutes

## Analysis Confidence
High
