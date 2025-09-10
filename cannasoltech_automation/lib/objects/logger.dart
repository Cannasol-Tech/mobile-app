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
import '../services/logging_service.dart';

// Backward compatibility: expose LoggingService as global log
final LoggingService _loggingService = LoggingService();
final Logger log = _loggingService.logger;

// Deprecated: Use LoggingService instead
@deprecated
/// Global application logger instance
final Logger log = Logger('AppLogger');
void setupLogging() {
  // LoggingService handles this internally now
}