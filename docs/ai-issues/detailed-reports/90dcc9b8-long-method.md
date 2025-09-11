# Issue: Long Method

## Severity: Medium

## Category: Maintenance

## Location
- **File(s)**: `lib/pages/home/home_page.dart`
- **Line(s)**: 26-26
- **Method/Widget**: `if`

## Description


## Why This Matters


## Current Code
```dart
        final CurrentUser user = context.watch<CurrentUser>();
      final bool loggedIn = user != null;
      if (loggedIn) {
        if (needsAcceptTac && _displayedTaC == false) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() => _displayedTaC = true);
```

## Suggested Fix


## Implementation Steps


## Additional Resources


## Estimated Effort
15-30 minutes

## Analysis Confidence
High
