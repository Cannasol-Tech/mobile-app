# Issue: Magic Numbers

## Severity: Low

## Category: Maintenance

## Location
- **File(s)**: `lib/components/bottom_nav_bar.dart`
- **Line(s)**: 39-39
- **Method/Widget**: `fromARGB`

## Description


## Why This Matters


## Current Code
```dart
        currentIndex: bottomNavSelectedItem == -1 ? 0 : bottomNavSelectedItem,
        selectedItemColor: (bottomNavSelectedItem != -1) ? const Color.fromARGB(199, 17, 120, 168) : const Color.fromARGB(255, 2, 2, 2),
        unselectedItemColor: const Color.fromARGB(255, 0, 0, 0),
        onTap: (index) {
              context.read<DisplayDataModel>().setBottomNavSelectedItem(index);
              Navigator.of(context).popUntil(ModalRoute.withName('/'));
```

## Suggested Fix


## Implementation Steps


## Additional Resources


## Estimated Effort
15-30 minutes

## Analysis Confidence
High
