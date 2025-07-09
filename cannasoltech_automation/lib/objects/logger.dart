import 'package:logging/logging.dart';
import '../services/logging_service.dart';

// Backward compatibility: expose LoggingService as global log
final LoggingService _loggingService = LoggingService();
final Logger log = _loggingService.logger;

// Deprecated: Use LoggingService instead
@deprecated
void setupLogging() {
  // LoggingService handles this internally now
}