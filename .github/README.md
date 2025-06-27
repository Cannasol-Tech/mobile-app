# CI/CD Pipeline

This repository includes a GitHub Actions CI pipeline that automatically runs tests and checks on every pull request.

## What the CI Pipeline Does

The CI pipeline (`.github/workflows/ci.yml`) performs the following checks:

1. **Flutter Setup**: Installs Flutter 3.24.3 (stable channel)
2. **Dependencies**: Downloads project dependencies with `flutter pub get`
3. **Dependency Check**: Verifies no dependency conflicts exist
4. **Code Formatting**: Ensures code follows Dart formatting standards
5. **Static Analysis**: Runs `flutter analyze` to catch potential issues
6. **Unit Tests**: Executes all unit tests with coverage reporting
7. **Coverage Upload**: Uploads coverage reports to Codecov

## Triggering the Pipeline

The pipeline runs automatically on:
- Pull requests to `main` or `develop` branches
- Direct pushes to the `main` branch

## Running Tests Locally

To run the same checks locally before creating a pull request:

```bash
cd cannasoltech_automation

# Get dependencies
flutter pub get

# Check formatting
dart format --output=none --set-exit-if-changed .

# Run analysis
flutter analyze --fatal-infos

# Run tests
flutter test --coverage
```

## Test Structure

The project includes:
- `test/widget_test.dart` - Basic widget tests
- `test/components/bottom_nav_bar_test.dart` - Component-specific tests

Additional tests should be added in the `test/` directory following the same structure.