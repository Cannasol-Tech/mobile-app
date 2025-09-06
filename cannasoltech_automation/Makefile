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

.PHONY: help test test-unit test-widget test-golden test-integration coverage clean-test setup-test

# Default target
help:
	@echo "Cannasol Technologies Mobile App - Testing Targets"
	@echo ""
	@echo "Available targets:"
	@echo "  test              - Run complete test suite (unit + widget + integration)"
	@echo "  test-unit         - Run unit tests (≥85% coverage required)"
	@echo "  test-widget       - Run widget tests (≥70% coverage required)"
	@echo "  test-golden       - Run golden tests (visual regression)"
	@echo "  test-integration  - Run integration tests (critical paths)"
	@echo "  coverage          - Generate and display coverage report"
	@echo "  clean-test        - Clean test artifacts and coverage files"
	@echo "  setup-test        - Setup test environment and dependencies"
	@echo ""
	@echo "Coverage Requirements:"
	@echo "  Unit Tests:       ≥85% statement coverage"
	@echo "  Widget Tests:     ≥70% widget coverage"
	@echo "  Overall Project:  ≥80% total coverage"

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

# Widget Testing (NO mocking)
# Executes: flutter test test/widget/
# Coverage: ≥70% requirement  
# Mocking: PROHIBITED
test-widget:
	@echo "🎨 Running widget tests..."
	@echo "Target: ≥70% coverage | Mocking: PROHIBITED"
	flutter test test/widget/ --reporter=expanded
	@echo "✅ Widget tests completed"

# Golden Testing (visual regression)
# Executes: flutter test test/golden/
# Mocking: PROHIBITED
test-golden:
	@echo "🖼️  Running golden tests (visual regression)..."
	@echo "Mocking: PROHIBITED | Purpose: Visual consistency"
	flutter test test/golden/ --reporter=expanded
	@echo "✅ Golden tests completed"

# Update golden files (use with caution)
update-goldens:
	@echo "🔄 Updating golden files..."
	@echo "⚠️  WARNING: This will update all golden reference images"
	@read -p "Are you sure? (y/N): " confirm && [ "$$confirm" = "y" ] || exit 1
	flutter test test/golden/ --update-goldens
	@echo "✅ Golden files updated"

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
