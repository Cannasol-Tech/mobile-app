# Issue: Long Method

## Severity: Medium

## Category: Maintenance

## Location
- **File(s)**: `lib/data_models/device.dart`
- **Line(s)**: 146-146
- **Method/Widget**: `if`

## Description


## Why This Matters


## Current Code
```dart
      filePath,
      onReceiveProgress: (received, total) {
        if (total != -1 && received < total) {
          showBanner(downloadingDeviceHistoryBanner());
        } else {
          hideCurrentBanner();
```

## Suggested Fix


## Implementation Steps


## Additional Resources


## Estimated Effort
15-30 minutes

## Analysis Confidence
High
