import 'package:logging/logging.dart';

final Logger log = Logger('AppLogger');

void setupLogging() {
  Logger.root.level = Level.ALL; // Capture all log levels
  Logger.root.onRecord.listen((record) {
    // Optionally send logs to external services (e.g., Firebase, Sentry)
  });
}