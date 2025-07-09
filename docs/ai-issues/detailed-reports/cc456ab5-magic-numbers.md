# Issue: Magic Numbers

## Severity: Low

## Category: Maintenance

## Location
- **File(s)**: `lib/components/system_app_bar.dart`
- **Line(s)**: 8-8
- **Method/Widget**: `drawerButton`

## Description


## Why This Matters


## Current Code
```dart
PreferredSizeWidget? systemAppBar(context, activeDevice) => AppBar(
        leading: drawerButton(),
        backgroundColor: Colors.grey[900],
        centerTitle: true,
        title: titleTextWithStatus(activeDevice)
    );
```

## Suggested Fix


## Implementation Steps


## Additional Resources


## Estimated Effort
15-30 minutes

## Analysis Confidence
High
