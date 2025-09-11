# Issue: Long Method

## Severity: Medium

## Category: Maintenance

## Location
- **File(s)**: `lib/handlers/state_handler.dart`
- **Line(s)**: 61-61
- **Method/Widget**: `if`

## Description


## Why This Matters


## Current Code
```dart

  void updateRunLogs(runSeconds){    
    if (properties['avg_flow_rate'] != null){
      int runTime = (runHours*3600 + runMinutes*60 + runSeconds).toInt();
      double avgFlow = (avgFlowRate * (runTime-1) + flow) / runTime;
      properties['avg_flow_rate']!.setValue(avgFlow);
```

## Suggested Fix


## Implementation Steps


## Additional Resources


## Estimated Effort
15-30 minutes

## Analysis Confidence
High
