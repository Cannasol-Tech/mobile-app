# Widget Testing Standards - Axovia Flow Flutter Framework

## 🎯 Overview

This document outlines the comprehensive widget testing standards for Flutter applications following Axovia Flow company guidelines. These standards ensure consistent, maintainable, and reliable widget tests across all Flutter projects.

## 📋 Testing Framework Stack

### Core Dependencies
- **Primary**: `flutter_test` (Flutter's built-in testing framework)
- **Mocking**: `mocktail` ^1.0.4 (null-safe, modern mocking)
- **BLoC Testing**: `bloc_test` ^9.1.7 (state management testing)
- **Integration**: `integration_test` (end-to-end testing)

### Test Structure
```
test/
├── widget/                  # Widget tests (UI components)
│   ├── components/         # Reusable UI components
│   ├── pages/             # Full page widgets
│   ├── dialogs/           # Dialog components
│   └── widget_test_suite.dart  # Test suite runner
├── unit/                   # Business logic tests
├── integration/            # End-to-end tests
├── golden/                 # Visual regression tests
└── helpers/               # Test utilities and mocks
```

## 🧪 Widget Test Categories

### 1. Component Tests (70% of widget tests)
Test individual UI components in isolation:
- **Rendering Tests**: Verify component renders correctly
- **Interaction Tests**: Test user interactions (taps, swipes, etc.)
- **State Management Tests**: Verify state changes update UI
- **Accessibility Tests**: Ensure components are accessible
- **Edge Cases**: Handle null values, empty states, errors

### 2. Page Tests (20% of widget tests)
Test complete page widgets:
- **Navigation Tests**: Verify routing and navigation
- **Form Validation Tests**: Test input validation
- **Integration Tests**: Test component interactions
- **Responsive Design Tests**: Test different screen sizes

### 3. Dialog Tests (10% of widget tests)
Test dialog components:
- **Modal Behavior**: Test dialog opening/closing
- **User Actions**: Test confirm/cancel actions
- **Barrier Dismissal**: Test tap-outside behavior

## 📝 Test Naming Conventions

### Test File Naming
```dart
// Component tests
{component_name}_test.dart

// Page tests
{page_name}_page_test.dart

// Dialog tests
{dialog_name}_dialog_test.dart
```

### Test Description Patterns
```dart
// Pattern: "should [expected behavior] when [condition]"
testWidgets('should display error message when validation fails', ...);
testWidgets('should navigate to home when sign in succeeds', ...);
testWidgets('should show loading indicator when submitting form', ...);
```

### Test Group Organization
```dart
group('ComponentName Widget Tests', () {
  group('Rendering Tests', () { ... });
  group('Interaction Tests', () { ... });
  group('State Management Tests', () { ... });
  group('Accessibility Tests', () { ... });
  group('Edge Cases', () { ... });
});
```

## 🏗️ Test Structure Template

```dart
// Widget Test Template
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mocktail/mocktail.dart';

import 'package:app/components/my_component.dart';

// Import centralized test helpers
import '../../helpers/mocks.dart';
import '../../helpers/test_data.dart';
import '../../helpers/test_utils.dart';

void main() {
  // Setup test environment
  TestEnvironment.setupGroup();

  group('MyComponent Widget Tests', () {
    late ProviderMockSetup providerMocks;

    setUp(() {
      providerMocks = MockSetup.createProviderMocks();
    });

    group('Rendering Tests', () {
      testWidgets('should render component with required elements', 
          (WidgetTester tester) async {
        // Arrange
        // ... setup mocks and test data

        // Act
        await tester.pumpWidget(
          createTestAppWithProviders(
            child: const MyComponent(),
            // ... provider setup
          ),
        );

        // Assert
        TestAssertions.expectVisible(find.byType(MyComponent));
        // ... additional assertions
      });
    });

    // ... other test groups
  });
}
```

## 🎭 Mock Management

### Centralized Mock Setup
```dart
// Use centralized mock creation
final providerMocks = MockSetup.createProviderMocks();
final authMocks = MockSetup.createAuthMocks();

// Setup common mock behaviors
when(() => mockProvider.property).thenReturn(value);
when(() => mockProvider.method()).thenAnswer((_) async => result);
```

### Mock Verification
```dart
// Verify method calls
verify(() => mockProvider.method()).called(1);
verifyNever(() => mockProvider.method());

// Verify with specific parameters
verify(() => mockProvider.method(any())).called(1);
verify(() => mockProvider.method('specific_value')).called(1);
```

## 🔍 Test Utilities Usage

### Widget Creation
```dart
// Simple widget testing
await tester.pumpWidget(
  createTestApp(child: MyWidget()),
);

// Widget with providers
await tester.pumpWidget(
  createTestAppWithProviders(
    child: MyWidget(),
    systemDataModel: mockSystemDataModel,
    displayDataModel: mockDisplayDataModel,
  ),
);
```

### User Interactions
```dart
// Use centralized interaction utilities
await TestInteractions.tap(tester, find.byType(Button));
await TestInteractions.enterText(tester, find.byKey(Key('email')), 'test@example.com');
await TestInteractions.scrollAndTap(tester, find.text('Submit'));
```

### Assertions
```dart
// Use centralized assertion utilities
TestAssertions.expectVisible(find.text('Success'));
TestAssertions.expectNotVisible(find.text('Error'));
TestAssertions.expectLoading();
TestAssertions.expectErrorMessage('Invalid input');
```

## ♿ Accessibility Testing

### Required Accessibility Tests
```dart
group('Accessibility Tests', () {
  testWidgets('should have proper semantic labels', (WidgetTester tester) async {
    // Test semantic labels
    final semantics = tester.getSemantics(find.byType(MyWidget));
    expect(semantics.label, contains('expected_label'));
  });

  testWidgets('should support keyboard navigation', (WidgetTester tester) async {
    // Test focus management
    expect(widget.focusNode, isNotNull);
  });

  testWidgets('should be accessible via screen reader', (WidgetTester tester) async {
    // Test screen reader compatibility
  });
});
```

## 🎨 Visual Regression Testing

### Golden Test Implementation
```dart
testWidgets('should match golden file', (WidgetTester tester) async {
  // Skip in CI unless explicitly enabled
  if (TestEnvironment.isCI && !enableGoldenTests) return;

  await GoldenTestUtils.expectGolden(
    tester,
    MyWidget(),
    'my_widget_default.png',
    size: GoldenTestUtils.phoneSize,
  );
});
```

## 🚀 Performance Testing

### Performance Test Guidelines
```dart
group('Performance Tests', () {
  testWidgets('should handle rapid interactions efficiently', (WidgetTester tester) async {
    final stopwatch = Stopwatch()..start();
    
    // Perform rapid interactions
    for (int i = 0; i < 100; i++) {
      await TestInteractions.tap(tester, find.byType(Button));
      await tester.pump(const Duration(milliseconds: 1));
    }
    
    stopwatch.stop();
    expect(stopwatch.elapsedMilliseconds, lessThan(1000));
  });
});
```

## 📊 Coverage Requirements

| Test Type | Minimum Coverage | Target Coverage |
|-----------|------------------|-----------------|
| Widget Tests | 70% | 85% |
| Component Tests | 80% | 90% |
| Page Tests | 60% | 75% |
| Dialog Tests | 75% | 85% |

### Coverage Commands
```bash
# Generate coverage report
flutter test --coverage

# View HTML report
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

## 🔧 CI/CD Integration

### Required Checks
- ✅ All widget tests pass
- ✅ Coverage meets minimum thresholds
- ✅ No accessibility violations
- ✅ Golden tests pass (if enabled)
- ✅ Performance tests within limits

### Test Execution
```bash
# Run all widget tests
flutter test test/widget/

# Run specific test suite
flutter test test/widget/widget_test_suite.dart

# Run with coverage
flutter test --coverage test/widget/

# Run golden tests
flutter test --dart-define=ENABLE_GOLDEN_TESTS=true test/widget/
```

## 🐛 Debugging and Troubleshooting

### Common Issues and Solutions

1. **Widget not found**
   ```dart
   // Use pumpAndSettle for async operations
   await tester.pumpAndSettle();
   ```

2. **Mock not working**
   ```dart
   // Ensure fallback values are registered
   registerFallbackValue(FakeObject());
   ```

3. **Overflow errors**
   ```dart
   // Wrap in bounded container
   await tester.pumpWidget(
     MaterialApp(
       home: SizedBox(
         width: 400,
         height: 600,
         child: MyWidget(),
       ),
     ),
   );
   ```

## 📚 Best Practices

### Do's ✅
- Use descriptive test names
- Group related tests logically
- Mock external dependencies
- Test both happy and error paths
- Include accessibility tests
- Use centralized test utilities
- Verify user interactions
- Test responsive behavior

### Don'ts ❌
- Don't mock the widget under test
- Don't test implementation details
- Don't ignore accessibility
- Don't skip edge cases
- Don't hardcode test data
- Don't test multiple concerns in one test
- Don't forget to clean up resources

## 🔗 Resources

- [Flutter Testing Guide](https://docs.flutter.dev/testing)
- [Mocktail Documentation](https://pub.dev/packages/mocktail)
- [Accessibility Testing](https://docs.flutter.dev/development/accessibility-and-localization/accessibility)
- [Golden Testing](https://github.com/flutter/flutter/wiki/Writing-a-golden-file-test-for-package%3Aflutter)

---

**For questions or clarifications on widget testing standards, contact the Flutter development team or refer to the project's testing documentation.**
