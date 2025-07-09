# Issue: Long Method

## Severity: Medium

## Category: Maintenance

## Location
- **File(s)**: `lib/providers/system_data_provider.dart`
- **Line(s)**: 279-279
- **Method/Widget**: `if`

## Description


## Why This Matters


## Current Code
```dart
  void updateCurrentRunPage(){
    /* Updates app to reflect the current system state */
    if (_activeDevice != null && _activeDevice?.name != 'None'){
      _currentRunPage = currentRunPageMap[_activeDevice?.state.state];
      log.info("DEBUG PAGE -> _currentRunPage = $_currentRunPage");
    }
```

## Suggested Fix


## Implementation Steps


## Additional Resources


## Estimated Effort
15-30 minutes

## Analysis Confidence
High
