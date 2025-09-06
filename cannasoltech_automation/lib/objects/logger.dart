/**
 * @file logger.dart
 * @author Stephen Boyett
 * @date 2025-09-06
 * @brief Application logging configuration and setup.
 * @details Provides centralized logging functionality for the Cannasol Technologies
 *          application with configurable log levels and external service integration.
 * @version 1.0
 * @since 1.0
 */

import 'package:logging/logging.dart';

/// Global application logger instance
final Logger log = Logger('AppLogger');

/**
 * @brief Sets up application-wide logging configuration.
 * @details Configures the root logger to capture all log levels and sets up
 *          listeners for potential external service integration (Firebase, Sentry).
 * @since 1.0
 */
void setupLogging() {
  Logger.root.level = Level.ALL; // Capture all log levels
  Logger.root.onRecord.listen((record) {
    // Optionally send logs to external services (e.g., Firebase, Sentry)
  });
}