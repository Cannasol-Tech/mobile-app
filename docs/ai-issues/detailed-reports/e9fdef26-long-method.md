# Issue: Long Method

## Severity: Medium

## Category: Maintenance

## Location
- **File(s)**: `lib/pages/home/home_page.dart`
- **Line(s)**: 31-31
- **Method/Widget**: `of`

## Description


## Why This Matters


## Current Code
```dart
            setState(() => _displayedTaC = true);
            Navigator.of(context).popUntil(ModalRoute.withName('/'));
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return const TaCDialog();
```

## Suggested Fix


## Implementation Steps


## Additional Resources


## Estimated Effort
15-30 minutes

## Analysis Confidence
High
