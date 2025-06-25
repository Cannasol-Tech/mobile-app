import 'system_element.dart';
import '../alarm_message.dart';
import '../system_images/system_image.dart';
import '../sensor_display/sensor_display.dart';
import '../system_images/sonicator_image.dart';
import '../sensor_display/pressure_display.dart';


class SonicatorElement extends SystemElement{
    @override String type = "Air"; 
    @override get alarmMessages => sonicAlarmMessages();
    @override SensorDisplay sensorDisplay = const PressureDisplay();
    @override SystemImage image = const SonicatorImage() as SystemImage;
}
