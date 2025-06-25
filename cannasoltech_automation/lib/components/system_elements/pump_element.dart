import 'system_element.dart';
import '../alarm_message.dart';
import '../system_images/pump_image.dart';
import '../system_images/system_image.dart';
import '../sensor_display/flow_display.dart';
import '../sensor_display/sensor_display.dart';


class PumpElement extends SystemElement{
    @override String type = "Flow"; 
    @override SystemImage image = const PumpImage();
    @override get alarmMessages => pumpAlarmMessages();
    @override SensorDisplay sensorDisplay = const FlowDisplay();
}
