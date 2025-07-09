# Issue: Long Method

## Severity: Medium

## Category: Maintenance

## Location
- **File(s)**: `lib/providers/system_data_provider.dart`
- **Line(s)**: 187-187
- **Method/Widget**: `init`

## Description


## Why This Matters


## Current Code
```dart
  bool get needsAcceptTaC => _needsAcceptTaC;

  void init(){
    _almCount = 0;
    setBottomNavPages();
    log.info("DEBUG -> SystemDataModel initialized");
```

## Suggested Fix


## Implementation Steps


## Additional Resources


## Estimated Effort
15-30 minutes

## Analysis Confidence
High
