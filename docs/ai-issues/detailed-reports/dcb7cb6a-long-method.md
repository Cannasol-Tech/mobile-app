# Issue: Long Method

## Severity: Medium

## Category: Maintenance

## Location
- **File(s)**: `lib/main.dart`
- **Line(s)**: 80-80
- **Method/Widget**: `if`

## Description


## Why This Matters


## Current Code
```dart
      scaffoldMessengerKey: scaffoldMessengerKey,
      onGenerateRoute: (settings) {
        if (loggedIn && settings.name != null && settings.arguments != null){
          if (settings.name!.contains("push")){
            final data = settings.arguments as Map;
            dynamic sys = context.read<SystemDataModel>();
```

## Suggested Fix


## Implementation Steps


## Additional Resources


## Estimated Effort
15-30 minutes

## Analysis Confidence
High
