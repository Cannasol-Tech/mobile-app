import 'package:logging/logging.dart';
import '../services/logging_service.dart';

// Deprecated: Use LoggingService instead
@deprecated
final Logger log = Logger('AppLogger');

// Deprecated: Use LoggingService instead
@deprecated
void setupLogging() {
  Logger.root.level = Level.ALL; // Capture all log levels
  Logger.root.onRecord.listen((record) {
    // Optionally send logs to external services (e.g., Firebase, Sentry)
  });
}