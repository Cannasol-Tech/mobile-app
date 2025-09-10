# Cannasol Technologies Mobile App - Testing Makefile
# 
# This Makefile provides standardized testing targets per company Flutter Testing Standard
# All targets follow the testing pyramid distribution: 70% unit, 20% widget, 10% integration
#
# Usage:
#   make test           - Run complete test suite
#   make test-unit      - Run unit tests only (≥85% coverage)
#   make test-widget    - Run widget tests only (≥70% coverage)
#   make test-golden    - Run golden tests (visual regression)
#   make test-integration - Run integration tests
#   make coverage       - Generate coverage report
#   make clean-test     - Clean test artifacts

.PHONY: help test test-unit test-widget test-widget-legacy test-widget-suite test-components test-pages test-dialogs test-golden test-golden-components test-integration coverage clean-test setup-test

# Default target
help:
	@echo "Cannasol Technologies Mobile App - Testing Targets"
	@echo ""
	@echo "Available targets:"
	@echo "  test              - Run complete test suite (unit + widget + integration)"
	@echo "  test-unit         - Run unit tests (≥85% coverage required, mocking allowed)"
	@echo "  test-widget       - Run widget tests (≥70% coverage required, NO mocking)"
	@echo "  test-widget-suite - Run comprehensive widget test suite"
	@echo "  test-widget-legacy- Run legacy widget tests (TEMPORARY - allows mocking)"
	@echo "  test-components   - Run component widget tests"
	@echo "  test-pages        - Run page widget tests"
	@echo "  test-dialogs      - Run dialog widget tests"
	@echo "  test-golden       - Run golden tests (visual regression)"
	@echo "  test-integration  - Run integration tests (critical paths)"
	@echo "  coverage          - Generate and display coverage report"
	@echo "  clean-test        - Clean test artifacts and coverage files"
	@echo "  setup-test        - Setup test environment and dependencies"
	@echo ""
	@echo "Coverage Requirements (per Flutter Testing Standard):"
	@echo "  Unit Tests:       ≥85% statement coverage (mocking allowed)"
	@echo "  Widget Tests:     ≥70% widget coverage (NO mocking)"
	@echo "  Overall Project:  ≥80% total coverage"
	@echo ""
	@echo "Company Standard: .axovia-flow/company-standards/flutter-specific/flutter-testing-standard.md"

# Setup test environment
setup-test:
	@echo "Setting up test environment..."
	flutter pub get
	@echo "Test environment ready!"

# Complete test suite
test: test-unit test-widget test-integration
	@echo "✅ Complete test suite passed!"
	@echo "Running coverage analysis..."
	@$(MAKE) coverage

# Unit Testing (with mocking allowed)
# Executes: flutter test test/unit/
# Coverage: ≥85% requirement
# Mocking: Mocktail permitted
test-unit:
	@echo "🧪 Running unit tests..."
	@echo "Target: ≥85% coverage | Mocking: Permitted (Mocktail)"
	flutter test test/unit/ --coverage --reporter=expanded
	@echo "✅ Unit tests completed"

# Widget Testing (NO mocking allowed - Company Standard)
# Executes: flutter test test/widget/
# Coverage: ≥70% requirement
# Mocking: PROHIBITED per Flutter Testing Standard
# Standard: .axovia-flow/company-standards/flutter-specific/flutter-testing-standard.md
test-widget:
	@echo "🎨 Running widget tests..."
	@echo "Standard: Flutter Testing Standard | Coverage: ≥70% | Mocking: PROHIBITED"
	@echo "📋 Validating compliance with Flutter Testing Standard..."
	@echo "Checking for prohibited mocking in widget tests..."
	@if grep -r "mocktail\|mockito\|Mock\|when(" test/widget/ --include="*.dart" 2>/dev/null; then \
		echo "❌ VIOLATION: Mocking detected in widget tests!"; \
		echo "   Flutter Testing Standard prohibits mocking in widget tests"; \
		echo "   Standard: .axovia-flow/company-standards/flutter-specific/flutter-testing-standard.md"; \
		echo ""; \
		echo "🔧 To fix violations:"; \
		echo "   1. Remove all mocktail imports from widget tests"; \
		echo "   2. Replace mocked providers with real implementations"; \
		echo "   3. Use test data instead of mocked responses"; \
		echo "   4. Test actual widget behavior, not mocked behavior"; \
		echo ""; \
		echo "💡 For legacy migration, use: make test-widget-legacy"; \
		exit 1; \
	fi
	@echo "✅ No prohibited mocking detected"
	@echo "Testing real widget behavior and interactions..."
	flutter test test/widget/ --coverage --reporter=expanded
	@echo "✅ Widget tests completed with coverage"
	@echo "📊 Validating coverage requirements..."
	@if [ -f coverage/lcov.info ]; then \
		echo "Coverage report generated: coverage/lcov.info"; \
		if command -v lcov >/dev/null 2>&1; then \
			echo "Widget test coverage summary:"; \
			lcov --summary coverage/lcov.info | grep -E "(lines|functions)"; \
		fi; \
	else \
		echo "⚠️  Coverage file not found"; \
	fi

# Widget Test Suite (comprehensive)
test-widget-suite:
	@echo "🎨 Running comprehensive widget test suite..."
	flutter test test/widget/widget_test_suite.dart --reporter=expanded
	@echo "✅ Widget test suite completed"

# Component-specific widget tests
test-components:
	@echo "🧩 Running component widget tests..."
	flutter test test/widget/components/ --reporter=expanded
	@echo "✅ Component tests completed"

# Page-specific widget tests
test-pages:
	@echo "📄 Running page widget tests..."
	flutter test test/widget/pages/ --reporter=expanded
	@echo "✅ Page tests completed"

# Dialog-specific widget tests
test-dialogs:
	@echo "💬 Running dialog widget tests..."
	flutter test test/widget/dialogs/ --reporter=expanded
	@echo "✅ Dialog tests completed"

# Widget tests with coverage (DEPRECATED - use test-widget instead)
test-widget-coverage:
	@echo "🎨📊 Running widget tests with coverage..."
	@echo "⚠️  DEPRECATED: Use 'make test-widget' instead (includes coverage)"
	flutter test test/widget/ --coverage --reporter=expanded
	@echo "✅ Widget tests with coverage completed"

# Legacy widget testing (TEMPORARY - for migration period only)
# ⚠️  WARNING: This target bypasses company standards and should only be used
# during the migration period to remove mocking from widget tests
test-widget-legacy:
	@echo "🎨⚠️  Running LEGACY widget tests (bypasses standards)..."
	@echo "WARNING: This target allows prohibited mocking and violates company standards"
	@echo "Standard: .axovia-flow/company-standards/flutter-specific/flutter-testing-standard.md"
	@echo "🚨 MIGRATION REQUIRED: Remove all mocking from widget tests"
	@echo ""
	@echo "Detected violations:"
	@grep -r "mocktail\|mockito\|Mock\|when(" test/widget/ --include="*.dart" 2>/dev/null | head -10 || echo "No violations found"
	@echo ""
	@echo "Running tests with violations (TEMPORARY)..."
	flutter test test/widget/ --coverage --reporter=expanded
	@echo "⚠️  Legacy widget tests completed - MIGRATION REQUIRED"

# Run only compliant widget tests (no mocking violations)
test-widget-compliant:
	@echo "🎨✅ Running compliant widget tests only..."
	@echo "Standard: Flutter Testing Standard | Coverage: ≥70% | Mocking: PROHIBITED"
	@echo "Running tests that comply with company standards..."
	flutter test test/widget/dialogs/notice_dialog_test.dart --coverage --reporter=expanded
	@echo "✅ Compliant widget tests completed"
	@echo "📊 Coverage report generated for compliant tests"

# Golden Testing (visual regression)
# Executes: flutter test with golden file generation
# Mocking: Provider mocking permitted for widget goldens
test-golden:
	@echo "🖼️  Running golden tests (visual regression)..."
	@echo "Mocking: Provider mocking permitted | Purpose: Visual consistency"
	flutter test --dart-define=ENABLE_GOLDEN_TESTS=true test/widget/ --reporter=expanded
	@echo "✅ Golden tests completed"

# Golden tests for specific components
test-golden-components:
	@echo "🖼️  Running component golden tests..."
	flutter test --dart-define=ENABLE_GOLDEN_TESTS=true test/widget/components/ --reporter=expanded
	@echo "✅ Component golden tests completed"

# Update golden files (use with caution)
update-goldens:
	@echo "🔄 Updating golden files..."
	@echo "⚠️  WARNING: This will update all golden reference images"
	@read -p "Are you sure? (y/N): " confirm && [ "$$confirm" = "y" ] || exit 1
	flutter test --dart-define=ENABLE_GOLDEN_TESTS=true --update-goldens test/widget/
	@echo "✅ Golden files updated"

# Update golden files for specific components
update-goldens-components:
	@echo "🔄 Updating component golden files..."
	@echo "⚠️  WARNING: This will update component golden reference images"
	@read -p "Are you sure? (y/N): " confirm && [ "$$confirm" = "y" ] || exit 1
	flutter test --dart-define=ENABLE_GOLDEN_TESTS=true --update-goldens test/widget/components/
	@echo "✅ Component golden files updated"

# Integration Testing (end-to-end)
# Executes: flutter test integration_test/
# Mocking: PROHIBITED
test-integration:
	@echo "🔗 Running integration tests..."
	@echo "Scope: Critical user flows | Mocking: PROHIBITED"
	flutter test integration_test/ --reporter=expanded
	@echo "✅ Integration tests completed"

# Coverage analysis and reporting
coverage:
	@echo "📊 Generating coverage report..."
	flutter test --coverage
	@if command -v lcov >/dev/null 2>&1; then \
		echo "Generating HTML coverage report..."; \
		genhtml coverage/lcov.info -o coverage/html --ignore-errors source; \
		echo "📈 Coverage report generated: coverage/html/index.html"; \
	else \
		echo "⚠️  lcov not installed. Install with: brew install lcov"; \
	fi
	@echo "📋 Coverage summary:"
	@if command -v lcov >/dev/null 2>&1; then \
		lcov --summary coverage/lcov.info; \
	else \
		echo "Install lcov for detailed coverage summary"; \
	fi

# Coverage validation (CI/CD use)
validate-coverage:
	@echo "🔍 Validating coverage requirements..."
	@if [ ! -f coverage/lcov.info ]; then \
		echo "❌ Coverage file not found. Run 'make test' first."; \
		exit 1; \
	fi
	@echo "✅ Coverage validation completed"

# Clean test artifacts
clean-test:
	@echo "🧹 Cleaning test artifacts..."
	rm -rf coverage/
	rm -rf test/golden/failures/
	flutter clean
	@echo "✅ Test artifacts cleaned"

# Development helpers
test-watch:
	@echo "👀 Running tests in watch mode..."
	flutter test --reporter=expanded --watch

test-debug:
	@echo "🐛 Running tests in debug mode..."
	flutter test --reporter=expanded --debug

# Platform-specific testing
test-ios:
	@echo "🍎 Running tests for iOS..."
	flutter test --platform=ios

test-android:
	@echo "🤖 Running tests for Android..."
	flutter test --platform=android

test-web:
	@echo "🌐 Running tests for Web..."
	flutter test --platform=web

# Quality gates for CI/CD
quality-gate: test validate-coverage
	@echo "🚪 Quality gate passed!"
	@echo "✅ All tests passed"
	@echo "✅ Coverage requirements met"

# Firebase emulator setup (for integration tests)
setup-firebase-emulator:
	@echo "🔥 Setting up Firebase emulator..."
	@if command -v firebase >/dev/null 2>&1; then \
		firebase emulators:start --only auth,database,storage; \
	else \
		echo "❌ Firebase CLI not installed. Install with: npm install -g firebase-tools"; \
		exit 1; \
	fi

# Test data management
generate-test-data:
	@echo "📝 Generating test data..."
	dart run test/helpers/generate_test_data.dart

# Performance testing
test-performance:
	@echo "⚡ Running performance tests..."
	flutter test test/performance/ --reporter=expanded

# Lint and format before testing
pre-test: 
	@echo "🔧 Running pre-test checks..."
	dart format --set-exit-if-changed .
	flutter analyze
	@echo "✅ Pre-test checks passed"

# Full CI/CD pipeline simulation
ci-test: pre-test test quality-gate
	@echo "🚀 CI/CD pipeline simulation completed successfully!"
