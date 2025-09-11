# Issue: Long Method

## Severity: Medium

## Category: Maintenance

## Location
- **File(s)**: `lib/controllers/text_controllers.dart`
- **Line(s)**: 109-109
- **Method/Widget**: `if`

## Description


## Why This Matters


## Current Code
```dart
      }

      if (newConfig.cooldownTemp != activeConfig.cooldownTemp){
        coolDownTempController.text = displayDouble(newConfig.cooldownTemp, 1);     
      }
    }
```

## Suggested Fix


## Implementation Steps


## Additional Resources


## Estimated Effort
15-30 minutes

## Analysis Confidence
High
