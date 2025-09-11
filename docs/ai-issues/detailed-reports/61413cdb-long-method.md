# Issue: Long Method

## Severity: Medium

## Category: Maintenance

## Location
- **File(s)**: `lib/components/run_stats.dart`
- **Line(s)**: 58-58
- **Method/Widget**: `build`

## Description


## Why This Matters


## Current Code
```dart

    @override
    Widget build(BuildContext context) {
      if (context.read<SystemDataModel>().activeDevice == null) {return Container();}
      context.watch<SystemDataModel>().activeDevice!.state.runSeconds;
      String runTime = context.watch<SystemDataModel>().activeDevice!.state.runTime;
```

## Suggested Fix


## Implementation Steps


## Additional Resources


## Estimated Effort
15-30 minutes

## Analysis Confidence
High
