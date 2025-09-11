# Issue: Long Method

## Severity: Medium

## Category: Maintenance

## Location
- **File(s)**: `lib/components/buttons/resume_button.dart`
- **Line(s)**: 13-13
- **Method/Widget**: `build`

## Description


## Why This Matters


## Current Code
```dart
  const ResumeButton({super.key});
  @override
  Widget build(BuildContext context) {
    UI ui = userInterface(context);
    return Selector<SystemDataModel, ({int state, bool cleared})>(
      selector: (_, p) => (state: p.activeDevice!.state.state, cleared: p.activeDevice!.state.alarmsCleared),
```

## Suggested Fix


## Implementation Steps


## Additional Resources


## Estimated Effort
15-30 minutes

## Analysis Confidence
High
