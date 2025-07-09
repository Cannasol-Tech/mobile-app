# Makefile for Cannasol Technologies Automation Flutter App
# Provides convenient targets for testing, building, and development

# Variables
FLUTTER := flutter
PROJECT_DIR := cannasoltech_automation
TEST_DIR := test
COVERAGE_DIR := coverage

# Default target
.DEFAULT_GOAL := help

# Help target - shows available commands
.PHONY: help
help:
	@echo "🚀 Cannasol Technologies Automation - Flutter App"
	@echo "=================================================="
	@echo ""
	@echo "📋 Available Commands:"
	@echo ""
	@echo "🧪 Testing:"
	@echo "  make test              - Run all tests"
	@echo "  make test-unit         - Run unit tests only"
	@echo "  make test-widget       - Run widget tests only"
	@echo "  make test-integration  - Run integration tests only"
	@echo "  make test-main         - Run all main.dart tests"
	@echo "  make test-coverage     - Run tests with coverage report"
	@echo "  make test-verbose      - Run tests with verbose output"
	@echo ""
	@echo "🔧 Development:"
	@echo "  make clean             - Clean build artifacts"
	@echo "  make deps              - Get dependencies"
	@echo "  make analyze           - Run static analysis"
	@echo "  make format            - Format code"
	@echo "  make build-debug       - Build debug APK"
	@echo "  make build-release     - Build release APK"
	@echo ""
	@echo "📱 Device/Emulator:"
	@echo "  make run               - Run app on connected device"
	@echo "  make run-debug         - Run app in debug mode"
	@echo "  make run-release       - Run app in release mode"
	@echo ""
	@echo "🧹 Maintenance:"
	@echo "  make clean-all         - Deep clean (including pub cache)"
	@echo "  make upgrade           - Upgrade Flutter and dependencies"
	@echo "  make doctor            - Run Flutter doctor"

# Change to project directory for all Flutter commands
define flutter_cmd
	cd $(PROJECT_DIR) && $(FLUTTER) $(1)
endef

# Testing targets
.PHONY: test
test:
	@echo "🧪 Running all tests..."
	$(call flutter_cmd,test)

.PHONY: test-unit
test-unit:
	@echo "🔬 Running unit tests..."
	$(call flutter_cmd,test test/main_unit_test.dart)

.PHONY: test-widget
test-widget:
	@echo "🎨 Running widget tests..."
	$(call flutter_cmd,test test/widget_test.dart)

.PHONY: test-integration
test-integration:
	@echo "🔗 Running integration tests..."
	$(call flutter_cmd,test test/main_integration_test.dart)

.PHONY: test-main
test-main:
	@echo "📄 Running all main.dart tests..."
	$(call flutter_cmd,test test/widget_test.dart test/main_unit_test.dart test/main_integration_test.dart)

.PHONY: test-coverage
test-coverage:
	@echo "📊 Running tests with coverage..."
	$(call flutter_cmd,test --coverage)
	@echo "📈 Coverage report generated in $(PROJECT_DIR)/coverage/"
	@echo "🌐 Open coverage/lcov.html in browser to view detailed report"

.PHONY: test-verbose
test-verbose:
	@echo "🔍 Running tests with verbose output..."
	$(call flutter_cmd,test --verbose)

.PHONY: test-watch
test-watch:
	@echo "👀 Running tests in watch mode..."
	@echo "Press 'q' to quit, 'r' to restart"
	$(call flutter_cmd,test --watch)

# Specific test file targets
.PHONY: test-pump-control
test-pump-control:
	@echo "💧 Testing pump control component..."
	$(call flutter_cmd,test test/components/ --name="pump")

.PHONY: test-components
test-components:
	@echo "🧩 Testing all components..."
	$(call flutter_cmd,test test/components/)

# Development targets
.PHONY: deps
deps:
	@echo "📦 Getting dependencies..."
	$(call flutter_cmd,pub get)

.PHONY: clean
clean:
	@echo "🧹 Cleaning build artifacts..."
	$(call flutter_cmd,clean)

.PHONY: analyze
analyze:
	@echo "🔍 Running static analysis..."
	$(call flutter_cmd,analyze)

.PHONY: format
format:
	@echo "✨ Formatting code..."
	$(call flutter_cmd,format lib/ test/)

.PHONY: format-check
format-check:
	@echo "📝 Checking code formatting..."
	$(call flutter_cmd,format --set-exit-if-changed lib/ test/)

# Build targets
.PHONY: build-debug
build-debug:
	@echo "🔨 Building debug APK..."
	$(call flutter_cmd,build apk --debug)

.PHONY: build-release
build-release:
	@echo "🚀 Building release APK..."
	$(call flutter_cmd,build apk --release)

.PHONY: build-ios
build-ios:
	@echo "🍎 Building iOS app..."
	$(call flutter_cmd,build ios)

# Run targets
.PHONY: run
run:
	@echo "📱 Running app on connected device..."
	$(call flutter_cmd,run)

.PHONY: run-debug
run-debug:
	@echo "🐛 Running app in debug mode..."
	$(call flutter_cmd,run --debug)

.PHONY: run-release
run-release:
	@echo "🚀 Running app in release mode..."
	$(call flutter_cmd,run --release)

.PHONY: run-profile
run-profile:
	@echo "📊 Running app in profile mode..."
	$(call flutter_cmd,run --profile)

# Device management
.PHONY: devices
devices:
	@echo "📱 Available devices:"
	$(call flutter_cmd,devices)

.PHONY: emulators
emulators:
	@echo "💻 Available emulators:"
	$(call flutter_cmd,emulators)

# Maintenance targets
.PHONY: doctor
doctor:
	@echo "🩺 Running Flutter doctor..."
	$(FLUTTER) doctor -v

.PHONY: upgrade
upgrade:
	@echo "⬆️ Upgrading Flutter and dependencies..."
	$(FLUTTER) upgrade
	$(call flutter_cmd,pub upgrade)

.PHONY: clean-all
clean-all: clean
	@echo "🧹 Deep cleaning..."
	$(call flutter_cmd,pub cache clean)
	rm -rf $(PROJECT_DIR)/build/
	rm -rf $(PROJECT_DIR)/.dart_tool/
	rm -rf $(PROJECT_DIR)/coverage/

# Git hooks and quality checks
.PHONY: pre-commit
pre-commit: format-check analyze test
	@echo "✅ Pre-commit checks passed!"

.PHONY: ci
ci: deps analyze test-coverage
	@echo "🚀 CI pipeline completed successfully!"

# Coverage utilities
.PHONY: coverage-html
coverage-html: test-coverage
	@echo "📊 Generating HTML coverage report..."
	cd $(PROJECT_DIR) && genhtml coverage/lcov.info -o coverage/html
	@echo "🌐 Coverage report available at: $(PROJECT_DIR)/coverage/html/index.html"

.PHONY: coverage-open
coverage-open: coverage-html
	@echo "🌐 Opening coverage report in browser..."
	@if command -v open >/dev/null 2>&1; then \
		open $(PROJECT_DIR)/coverage/html/index.html; \
	elif command -v xdg-open >/dev/null 2>&1; then \
		xdg-open $(PROJECT_DIR)/coverage/html/index.html; \
	elif command -v start >/dev/null 2>&1; then \
		start $(PROJECT_DIR)/coverage/html/index.html; \
	else \
		echo "Please open $(PROJECT_DIR)/coverage/html/index.html manually"; \
	fi

# Database and simulation targets
.PHONY: run-simulation
run-simulation:
	@echo "🧪 Starting hardware simulation..."
	cd hardware_simulation && python app.py

.PHONY: setup-env
setup-env:
	@echo "🔧 Setting up development environment..."
	$(FLUTTER) doctor
	$(call flutter_cmd,pub get)
	@echo "✅ Environment setup complete!"

# Troubleshooting targets
.PHONY: fix-permissions
fix-permissions:
	@echo "🔐 Fixing Android permissions..."
	cd $(PROJECT_DIR)/android && chmod +x gradlew

.PHONY: reset-deps
reset-deps:
	@echo "🔄 Resetting dependencies..."
	rm -f $(PROJECT_DIR)/pubspec.lock
	rm -rf $(PROJECT_DIR)/.dart_tool/
	$(call flutter_cmd,pub get)

# Performance targets
.PHONY: benchmark
benchmark:
	@echo "⚡ Running performance benchmarks..."
	$(call flutter_cmd,test --reporter=json | grep -E "(test|failure)" > benchmark_results.json)

# Documentation
.PHONY: docs
docs:
	@echo "📚 Generating documentation..."
	$(call flutter_cmd,pub global activate dartdoc)
	$(call flutter_cmd,pub global run dartdoc)

# Platform-specific targets
.PHONY: android-setup
android-setup:
	@echo "🤖 Setting up Android environment..."
	cd $(PROJECT_DIR)/android && ./gradlew build

.PHONY: ios-setup
ios-setup:
	@echo "🍎 Setting up iOS environment..."
	cd $(PROJECT_DIR)/ios && pod install

# Custom test configurations
.PHONY: test-debug
test-debug:
	@echo "🐛 Running tests in debug mode..."
	$(call flutter_cmd,test --debug)

.PHONY: test-specific
test-specific:
ifndef FILE
	@echo "❌ Error: Please specify FILE=test_file_name"
	@echo "Example: make test-specific FILE=widget_test.dart"
else
	@echo "🎯 Running specific test: $(FILE)"
	$(call flutter_cmd,test test/$(FILE))
endif

# Quick development workflow
.PHONY: dev
dev: deps analyze format test
	@echo "🎉 Development workflow completed!"

.PHONY: quick-test
quick-test:
	@echo "⚡ Quick test run (main tests only)..."
	$(call flutter_cmd,test test/widget_test.dart test/main_unit_test.dart --concurrency=4)

# Show project info
.PHONY: info
info:
	@echo "📋 Project Information"
	@echo "====================="
	@echo "Project: Cannasol Technologies Automation"
	@echo "Framework: Flutter"
	@echo "Language: Dart"
	@echo "Test Framework: flutter_test + mocktail"
	@echo ""
	@echo "📁 Project Structure:"
	@echo "├── $(PROJECT_DIR)/"
	@echo "│   ├── lib/                 # Source code"
	@echo "│   ├── test/                # Test files"
	@echo "│   ├── assets/              # Images and documents"
	@echo "│   └── pubspec.yaml         # Dependencies"
	@echo "├── hardware_simulation/     # Hardware simulation"
	@echo "└── Makefile                 # This file"
