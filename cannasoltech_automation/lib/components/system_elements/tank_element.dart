import 'system_element.dart';
import '../alarm_message.dart';
import '../system_images/tank_image.dart';
import '../system_images/system_image.dart';
import '../sensor_display/temp_display.dart';
import '../sensor_display/sensor_display.dart';


class TankElement extends SystemElement{
    @override String type = "Temp"; 
    @override SystemImage image = const TankImage();
    @override get alarmMessages => tankAlarmMessages();
    @override SensorDisplay sensorDisplay = const TemperatureDisplay();
}
