import 'package:logging/logging.dart';

/// Service class to encapsulate logging functionality
/// Replaces the global log variable
class LoggingService {
  static LoggingService? _instance;
  LoggingService._internal() {
    _setupLogging();
  }
  
  factory LoggingService() {
    _instance ??= LoggingService._internal();
    return _instance!;
  }
  
  final Logger _logger = Logger('AppLogger');
  
  /// Setup logging configuration
  void _setupLogging() {
    Logger.root.level = Level.ALL; // Capture all log levels
    Logger.root.onRecord.listen((record) {
      // Optionally send logs to external services (e.g., Firebase, Sentry)
    });
  }
  
  /// Log an info message
  void info(Object? message) {
    _logger.info(message);
  }
  
  /// Log a warning message
  void warning(Object? message) {
    _logger.warning(message);
  }
  
  /// Log an error message
  void severe(Object? message, [Object? error, StackTrace? stackTrace]) {
    _logger.severe(message, error, stackTrace);
  }
  
  /// Log a debug message
  void fine(Object? message) {
    _logger.fine(message);
  }
  
  /// Log a config message
  void config(Object? message) {
    _logger.config(message);
  }
  
  /// Log a finer message
  void finer(Object? message) {
    _logger.finer(message);
  }
  
  /// Log a finest message
  void finest(Object? message) {
    _logger.finest(message);
  }
  
  /// Get the underlying logger (for compatibility)
  Logger get logger => _logger;
}