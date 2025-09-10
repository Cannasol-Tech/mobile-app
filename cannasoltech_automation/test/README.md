# Cannasoltech Automation - Test Suite

## 🧪 Testing Framework

This project uses **Mocktail** as the official mocking framework, following modern Flutter testing best practices.

### Framework Stack
- **Primary**: `flutter_test` (Flutter's built-in testing framework)
- **Mocking**: `mocktail` ^1.0.4 (null-safe, modern mocking)
- **BLoC Testing**: `bloc_test` ^9.1.7 (state management testing)
- **Integration**: `integration_test` (end-to-end testing)

## 🚀 Quick Start

### Running Tests

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/unit/handlers/user_handler_test.dart

# Run tests with coverage
flutter test --coverage

# Run integration tests
flutter test integration_test/
```

### Test Structure

```
test/
├── unit/                    # Business logic tests (70%)
├── widget/                  # UI component tests (20%)
├── integration/             # End-to-end tests (10%)
├── golden/                  # Visual regression tests
└── helpers/                 # Test utilities
```

## 📝 Writing Tests

### Unit Test Example

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Mock classes
class MockFirebaseAuth extends Mock implements FirebaseAuth {}

void main() {
  group('UserHandler Tests', () {
    late MockFirebaseAuth mockAuth;
    
    setUp(() {
      mockAuth = MockFirebaseAuth();
    });

    test('should handle sign in correctly', () {
      // Arrange
      when(() => mockAuth.signInWithEmailAndPassword(
        email: any(named: 'email'),
        password: any(named: 'password'),
      )).thenAnswer((_) async => mockUserCredential);

      // Act & Assert
      // Your test logic here
    });
  });
}
```

### Widget Test Example

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Button displays correct text', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(home: MyButton()),
    );

    expect(find.text('Sign In'), findsOneWidget);
  });
}
```

## 🎭 Mocktail Guidelines

### Mock Creation

```dart
// ✅ Correct: Mock interfaces
class MockUserHandler extends Mock implements UserHandler {}

// ✅ Correct: Fake for complex types
class MockAuthCredential extends Fake implements AuthCredential {}
```

### Fallback Values

```dart
void main() {
  setUpAll(() {
    registerFallbackValue(MockAuthCredential());
  });
  
  // Tests...
}
```

### Stubbing

```dart
// Method stubbing
when(() => mock.method()).thenReturn(value);
when(() => mock.method()).thenAnswer((_) async => value);
when(() => mock.method()).thenThrow(exception);

// Verification
verify(() => mock.method()).called(1);
verifyNever(() => mock.method());
```

## 📊 Coverage Requirements

| Test Type | Target | Status |
|-----------|--------|--------|
| Unit Tests | 85% | ✅ Enforced |
| Widget Tests | 70% | ✅ Enforced |
| Overall | 80% | ✅ Enforced |

### Coverage Commands

```bash
# Generate coverage
flutter test --coverage

# View HTML report (requires lcov)
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

## 🔧 Test Utilities

### Mock Helpers (`test/helpers/mocks.dart`)

Centralized mock definitions for reuse across tests:

```dart
// Common mocks used throughout the test suite
class MockFirebaseAuth extends Mock implements FirebaseAuth {}
class MockGoogleSignIn extends Mock implements GoogleSignIn {}
class MockUserHandler extends Mock implements UserHandler {}
```

### Test Data (`test/helpers/test_data.dart`)

Consistent test data for reliable testing:

```dart
class TestData {
  static const String validEmail = 'test@example.com';
  static const String validPassword = 'password123';
  static const String invalidEmail = 'invalid-email';
}
```

## 🚦 CI/CD Integration

Tests run automatically on:
- Every push to any branch
- Every pull request
- Before deployment

### Required Checks
- ✅ All tests pass
- ✅ Coverage meets minimum thresholds
- ✅ No linting errors
- ✅ Code formatting compliance

## 🐛 Debugging Tests

### Common Issues

1. **Mock not working**: Ensure fallback values are registered
2. **Widget not found**: Use `await tester.pumpAndSettle()`
3. **Async issues**: Use `thenAnswer((_) async => value)`

### Debug Commands

```bash
# Run single test with verbose output
flutter test test/unit/specific_test.dart --verbose

# Run tests in debug mode
flutter test --debug

# Print debug information
print('Debug: ${widget.toString()}');
```

## 📚 Best Practices

### Test Naming
- Use descriptive test names
- Follow pattern: "should [expected behavior] when [condition]"
- Group related tests with `group()`

### Test Organization
- One test file per source file
- Use `setUp()` and `tearDown()` for common setup
- Keep tests independent and isolated

### Mock Usage
- Mock external dependencies only
- Don't mock the class under test
- Use specific matchers when possible

## 🔗 Resources

- [TESTING-STANDARDS.md](../TESTING-STANDARDS.md) - Official testing standards
- [UNIT-TEST-FRAMEWORK-ANALYSIS.md](../UNIT-TEST-FRAMEWORK-ANALYSIS.md) - Framework analysis
- [Flutter Testing Guide](https://docs.flutter.dev/testing)
- [Mocktail Documentation](https://pub.dev/packages/mocktail)

---

**For questions or issues with testing, refer to the official standards document or reach out to the development team.**
