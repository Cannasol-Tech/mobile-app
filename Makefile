# Makefile for Cannasol Technologies Mobile App
# Flutter project located in cannasoltech_automation/

# Variables
FLUTTER_DIR = cannasoltech_automation
FLUTTER = flutter
DEVICE ?= chrome

# Default target
.DEFAULT_GOAL := help

# Help target - shows available commands
.PHONY: help
help:
	@echo "Available targets:"
	@echo "  preview     - Launch Flutter app in development mode"
	@echo "  preview-web - Launch Flutter app in web browser (Chrome)"
	@echo "  preview-ios - Launch Flutter app in iOS simulator"
	@echo "  preview-android - Launch Flutter app in Android emulator"
	@echo "  install     - Install Flutter dependencies"
	@echo "  clean       - Clean Flutter build cache"
	@echo "  test        - Run complete Flutter test suite"
	@echo "  test-unit   - Run unit tests (≥85% coverage, mocking allowed)"
	@echo "  test-widget - Run widget tests (≥70% coverage, NO mocking)"
	@echo "  test-widget-compliant - Run only compliant widget tests (no violations)"
	@echo "  test-widget-legacy - Run legacy widget tests (TEMPORARY - allows mocking)"
	@echo "  test-integration - Run integration tests"
	@echo "  test-golden - Run golden tests (visual regression)"
	@echo "  coverage    - Generate coverage report"
	@echo "  build       - Build Flutter app for production"
	@echo "  devices     - List available devices"
	@echo ""
	@echo "Usage examples:"
	@echo "  make preview              # Launch on default device (Chrome)"
	@echo "  make preview DEVICE=macos # Launch on specific device"
	@echo "  make preview-ios          # Launch on iOS simulator"

# Main preview target - launches Flutter app for development
.PHONY: preview
preview: install
	@echo "🚀 Launching Flutter app preview..."
	@cd $(FLUTTER_DIR) && $(FLUTTER) run -d $(DEVICE) --hot

# Web preview (Chrome)
.PHONY: preview-web
preview-web: install
	@echo "🌐 Launching Flutter app in web browser..."
	@cd $(FLUTTER_DIR) && $(FLUTTER) run -d chrome --hot

# iOS preview
.PHONY: preview-ios
preview-ios: install
	@echo "📱 Launching Flutter app in iOS simulator..."
	@cd $(FLUTTER_DIR) && $(FLUTTER) run -d ios --hot

# Android preview
.PHONY: preview-android
preview-android: install
	@echo "🤖 Launching Flutter app in Android emulator..."
	@cd $(FLUTTER_DIR) && $(FLUTTER) run -d android --hot

# Install dependencies
.PHONY: install
install:
	@echo "📦 Installing Flutter dependencies..."
	@cd $(FLUTTER_DIR) && $(FLUTTER) pub get

# Clean build cache
.PHONY: clean
clean:
	@echo "🧹 Cleaning Flutter build cache..."
	@cd $(FLUTTER_DIR) && $(FLUTTER) clean

# Testing targets (delegate to cannasoltech_automation/Makefile)
.PHONY: test test-unit test-widget test-widget-compliant test-widget-legacy test-integration test-golden coverage

# Complete test suite
test:
	@echo "🧪 Running complete Flutter test suite..."
	@cd $(FLUTTER_DIR) && $(MAKE) test

# Unit tests (mocking allowed)
test-unit:
	@echo "🧪 Running unit tests..."
	@cd $(FLUTTER_DIR) && $(MAKE) test-unit

# Widget tests (NO mocking - Company Standard)
test-widget:
	@echo "🎨 Running widget tests (Company Standard - NO mocking)..."
	@cd $(FLUTTER_DIR) && $(MAKE) test-widget

# Legacy widget tests (TEMPORARY - allows mocking)
test-widget-legacy:
	@echo "🎨⚠️  Running LEGACY widget tests (bypasses standards)..."
	@cd $(FLUTTER_DIR) && $(MAKE) test-widget-legacy

# Integration tests
test-integration:
	@echo "🔗 Running integration tests..."
	@cd $(FLUTTER_DIR) && $(MAKE) test-integration

# Golden tests (visual regression)
test-golden:
	@echo "🖼️  Running golden tests..."
	@cd $(FLUTTER_DIR) && $(MAKE) test-golden

# Coverage report
coverage:
	@echo "📊 Generating coverage report..."
	@cd $(FLUTTER_DIR) && $(MAKE) coverage

# Build for production
.PHONY: build
build: install
	@echo "🏗️  Building Flutter app for production..."
	@cd $(FLUTTER_DIR) && $(FLUTTER) build web

# List available devices
.PHONY: devices
devices:
	@echo "📱 Available devices:"
	@cd $(FLUTTER_DIR) && $(FLUTTER) devices

# Development utilities
.PHONY: doctor upgrade
doctor:
	@echo "🩺 Running Flutter doctor..."
	@cd $(FLUTTER_DIR) && $(FLUTTER) doctor

# Upgrade dependencies
.PHONY: upgrade
upgrade:
	@echo "⬆️  Upgrading Flutter dependencies..."
	@cd $(FLUTTER_DIR) && $(FLUTTER) pub upgrade
