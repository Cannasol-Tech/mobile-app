# Widget Testing Implementation - Axovia Flow Standards

## 🎯 Overview

This directory contains comprehensive widget tests following Axovia Flow company standards for Flutter applications. The implementation provides robust testing for UI components, pages, and dialogs with proper mocking, accessibility testing, and visual regression capabilities.

## 📁 Directory Structure

```
test/widget/
├── components/              # Component widget tests
│   ├── alarm_message_test.dart
│   ├── bottom_nav_bar_test.dart
│   ├── confirm_dialog_test.dart
│   └── buttons/
│       └── confirm_button_test.dart
├── pages/                   # Page widget tests
│   └── sign_in_page_test.dart
├── dialogs/                 # Dialog widget tests
│   └── notice_dialog_test.dart
├── widget_test_suite.dart   # Comprehensive test suite runner
└── README.md               # This file
```

## 🧪 Test Categories

### 1. Component Tests (70% of widget tests)
- **Rendering Tests**: Verify components render correctly
- **Interaction Tests**: Test user interactions (taps, swipes, etc.)
- **State Management Tests**: Verify state changes update UI
- **Accessibility Tests**: Ensure components are accessible
- **Edge Cases**: Handle null values, empty states, errors

### 2. Page Tests (20% of widget tests)
- **Navigation Tests**: Verify routing and navigation
- **Form Validation Tests**: Test input validation
- **Integration Tests**: Test component interactions
- **Authentication Flow Tests**: Test sign-in/sign-up flows

### 3. Dialog Tests (10% of widget tests)
- **Modal Behavior**: Test dialog opening/closing
- **User Actions**: Test confirm/cancel actions
- **Barrier Dismissal**: Test tap-outside behavior

## 🚀 Running Tests

### Basic Commands
```bash
# Run all widget tests
make test-widget

# Run comprehensive widget test suite
make test-widget-suite

# Run specific test categories
make test-components
make test-pages
make test-dialogs

# Run with coverage
make test-widget-coverage
```

### Advanced Commands
```bash
# Run golden tests (visual regression)
make test-golden

# Update golden files (use with caution)
make update-goldens

# Run performance tests
flutter test --dart-define=ENABLE_PERFORMANCE_TESTS=true test/widget/

# Run accessibility tests
flutter test --dart-define=ENABLE_ACCESSIBILITY_TESTS=true test/widget/
```

## 🎭 Mock Management

### Centralized Mock Setup
```dart
// Use centralized mock creation from test helpers
final providerMocks = MockSetup.createProviderMocks();
final authMocks = MockSetup.createAuthMocks();

// Setup in test
setUp(() {
  providerMocks = MockSetup.createProviderMocks();
  
  // Configure mock behaviors
  when(() => providerMocks.systemDataModel.alarmActive).thenReturn(true);
  when(() => providerMocks.displayDataModel.currentPageIndex).thenReturn(0);
});
```

### Mock Verification
```dart
// Verify method calls
verify(() => mockProvider.method()).called(1);
verifyNever(() => mockProvider.method());

// Verify with specific parameters
verify(() => mockProvider.setPageIndex(0)).called(1);
```

## 🔧 Test Utilities

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
await TestInteractions.enterText(tester, TestFinders.emailField, 'test@example.com');
await TestInteractions.performSignIn(tester);
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
});
```

## 🎨 Visual Regression Testing

### Golden Test Implementation
```dart
testWidgets('should match golden file', (WidgetTester tester) async {
  await GoldenTestUtils.expectGolden(
    tester,
    MyWidget(),
    'my_widget_default.png',
    size: GoldenTestUtils.phoneSize,
  );
});

// Multi-size golden testing
testWidgets('should match golden files across screen sizes', (WidgetTester tester) async {
  await GoldenTestUtils.expectGoldenMultiSize(
    tester,
    MyWidget(),
    'my_widget',
    sizes: [
      GoldenTestUtils.phoneSize,
      GoldenTestUtils.tabletSize,
    ],
  );
});
```

## 🚀 Performance Testing

### Performance Test Guidelines
```dart
group('Performance Tests', () {
  testWidgets('should handle rapid interactions efficiently', (WidgetTester tester) async {
    final buildTime = await PerformanceTestUtils.measureBuildTime(
      tester,
      MyWidget(),
    );
    
    expect(buildTime.inMilliseconds, lessThan(100));
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

## 🔍 Test Examples

### Component Test Example
```dart
testWidgets('should display alarm message when alarm is active', 
    (WidgetTester tester) async {
  // Arrange
  when(() => providerMocks.systemDataModel.alarmActive).thenReturn(true);
  when(() => providerMocks.systemDataModel.alarmMessage)
      .thenReturn('Flow alarm active');

  // Act
  await tester.pumpWidget(
    createTestAppWithProviders(
      child: const AlarmMessage(),
      systemDataModel: providerMocks.systemDataModel,
    ),
  );

  // Assert
  TestAssertions.expectVisible(find.text('Flow alarm active'));
});
```

### Page Test Example
```dart
testWidgets('should perform successful email sign in', 
    (WidgetTester tester) async {
  // Arrange
  when(() => authMocks.userHandler.signInWithEmailAndPassword(any(), any()))
      .thenAnswer((_) async => true);

  await tester.pumpWidget(
    createTestApp(
      child: Provider<UserHandler>.value(
        value: authMocks.userHandler,
        child: const SignInPage(),
      ),
    ),
  );

  // Act
  await TestInteractions.performSignIn(tester);

  // Assert
  verify(() => authMocks.userHandler.signInWithEmailAndPassword(
    AuthTestData.validEmail,
    AuthTestData.validPassword,
  )).called(1);
});
```

## 🐛 Debugging Tips

### Common Issues and Solutions

1. **Widget not found**
   ```dart
   // Use pumpAndSettle for async operations
   await tester.pumpAndSettle();
   ```

2. **Mock not working**
   ```dart
   // Ensure fallback values are registered in setUpAll
   setUpAll(() {
     MockSetup.setupFallbacks();
   });
   ```

3. **Overflow errors**
   ```dart
   // Use bounded containers for testing
   await tester.pumpWidget(
     createTestApp(
       child: SizedBox(
         width: 400,
         height: 600,
         child: MyWidget(),
       ),
     ),
   );
   ```

## 📚 Best Practices

### Do's ✅
- Use descriptive test names following "should [behavior] when [condition]" pattern
- Group related tests logically
- Mock external dependencies and providers
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

- [Widget Testing Standards](../WIDGET_TESTING_STANDARDS.md)
- [Test Helpers Documentation](../helpers/README.md)
- [Flutter Testing Guide](https://docs.flutter.dev/testing)
- [Mocktail Documentation](https://pub.dev/packages/mocktail)

---

**For questions or issues with widget testing, refer to the testing standards document or contact the development team.**
