import 'package:flutter_test/flutter_test.dart';
import 'package:cannasoltech_automation/services/navigation_service.dart';
import 'package:cannasoltech_automation/services/logging_service.dart';
import 'package:cannasoltech_automation/services/style_service.dart';
import 'package:cannasoltech_automation/shared/app_constants.dart';

void main() {
  group('Service Tests', () {
    test('NavigationService is singleton', () {
      final service1 = NavigationService();
      final service2 = NavigationService();
      expect(service1, same(service2));
    });

    test('NavigationService has required keys', () {
      final service = NavigationService();
      expect(service.navigatorKey, isNotNull);
      expect(service.scaffoldMessengerKey, isNotNull);
    });

    test('LoggingService is singleton', () {
      final service1 = LoggingService();
      final service2 = LoggingService();
      expect(service1, same(service2));
    });

    test('LoggingService provides logging methods', () {
      final service = LoggingService();
      expect(() => service.info('test message'), returnsNormally);
      expect(() => service.warning('test warning'), returnsNormally);
      expect(() => service.severe('test error'), returnsNormally);
    });

    test('StyleService is singleton', () {
      final service1 = StyleService();
      final service2 = StyleService();
      expect(service1, same(service2));
    });

    test('StyleService provides styles', () {
      final service = StyleService();
      expect(service.getNoDeviceStyle(), isNotNull);
      expect(service.getConfigHeaderStyle(), isNotNull);
    });
  });

  group('Constants Tests', () {
    test('DeviceState enum has correct values', () {
      expect(DeviceState.reset.value, 100);
      expect(DeviceState.init.value, 0);
      expect(DeviceState.warmUp.value, 1);
      expect(DeviceState.running.value, 2);
      expect(DeviceState.alarm.value, 3);
      expect(DeviceState.finished.value, 4);
      expect(DeviceState.coolDown.value, 5);
    });

    test('DeviceState fromValue works correctly', () {
      expect(DeviceState.fromValue(100), DeviceState.reset);
      expect(DeviceState.fromValue(0), DeviceState.init);
      expect(DeviceState.fromValue(2), DeviceState.running);
    });

    test('DisplayElement enum has correct values', () {
      expect(DisplayElement.noElement.value, -1);
      expect(DisplayElement.showSonicator.value, 0);
      expect(DisplayElement.showPump.value, 1);
      expect(DisplayElement.showTank.value, 2);
    });

    test('AssetPaths contains expected paths', () {
      expect(AssetPaths.tankPath, 'assets/images/Tank.png');
      expect(AssetPaths.pumpPath, 'assets/images/pump.png');
      expect(AssetPaths.logFilePath, 'log.txt');
    });

    test('Backward compatibility constants exist', () {
      expect(RESET, 100);
      expect(INIT, 0);
      expect(WARM_UP, 1);
      expect(RUNNING, 2);
      expect(ALARM, 3);
      expect(FINISHED, 4);
      expect(COOL_DOWN, 5);
      
      expect(NO_ELEMENT, -1);
      expect(SHOW_SONICATOR, 0);
      expect(SHOW_PUMP, 1);
      expect(SHOW_TANK, 2);
      
      expect(RUN_TITLE, 'System Running');
      expect(LOG_FILE_PATH, 'log.txt');
    });
  });
}