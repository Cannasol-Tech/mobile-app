# Data Models

## User

**Purpose:** Represents system users including facility managers, technicians, and administrators

**Key Attributes:**
- uid: string - Firebase Auth unique identifier
- email: string - User email address
- displayName: string - User's display name
- role: UserRole - User permission level (admin, manager, technician, viewer)
- facilities: string[] - Array of facility IDs user has access to
- preferences: UserPreferences - User-specific app settings
- createdAt: Timestamp - Account creation date
- lastLoginAt: Timestamp - Last login timestamp

### TypeScript Interface

```typescript
interface User {
  uid: string;
  email: string;
  displayName: string;
  role: 'admin' | 'manager' | 'technician' | 'viewer';
  facilities: string[];
  preferences: {
    notifications: boolean;
    theme: 'light' | 'dark' | 'system';
    units: 'metric' | 'imperial';
  };
  createdAt: FirebaseFirestore.Timestamp;
  lastLoginAt: FirebaseFirestore.Timestamp;
}
```

### Relationships
- One-to-many with Facilities (user can access multiple facilities)
- One-to-many with AlertSubscriptions (user can subscribe to various alerts)

## Facility

**Purpose:** Represents an industrial facility with multiple ultrasonic liquid processing systems

**Key Attributes:**
- id: string - Unique facility identifier
- name: string - Facility display name
- address: Address - Physical location
- timezone: string - Facility timezone for scheduling
- systems: string[] - Array of processing system IDs within facility
- settings: FacilitySettings - Facility-wide configuration
- status: FacilityStatus - Current operational status

### TypeScript Interface

```typescript
interface Facility {
  id: string;
  name: string;
  address: {
    street: string;
    city: string;
    state: string;
    zipCode: string;
    country: string;
  };
  timezone: string;
  systems: string[];
  settings: {
    alertThresholds: Record<string, number>;
    operatingHours: {
      start: string;
      end: string;
    };
    emergencyContacts: string[];
    processParameters: {
      maxFlowRate: number;
      maxPressure: number;
      maxTemperature: number;
      ultrasonicFrequency: number;
    };
  };
  status: 'active' | 'maintenance' | 'offline';
  createdAt: FirebaseFirestore.Timestamp;
  updatedAt: FirebaseFirestore.Timestamp;
}
```

### Relationships
- One-to-many with ProcessingSystems (facility contains multiple ultrasonic processing systems)
- Many-to-many with Users (multiple users can access facility)
- One-to-many with Devices (facility contains multiple monitoring and control devices)

## ProcessingSystem

**Purpose:** Represents a specific ultrasonic liquid processing system within a facility (sonicator, pump, temperature control unit)

**Key Attributes:**
- id: string - Unique processing system identifier
- facilityId: string - Parent facility reference
- name: string - Processing system display name
- type: SystemType - Type of processing system (sonicator, pump, tank)
- devices: string[] - Array of device IDs monitoring this system
- currentParameters: ProcessingParameters - Latest sensor readings
- targetRanges: ProcessingTargets - Desired operational parameters

### TypeScript Interface

```typescript
interface ProcessingSystem {
  id: string;
  facilityId: string;
  name: string;
  type: 'sonicator' | 'pump' | 'tank' | 'temperature_control';
  devices: string[];
  currentParameters: {
    flowRate: number;        // L/min
    pressure: number;        // psi
    temperature: number;     // °C
    ultrasonicFrequency: number; // kHz
    powerLevel: number;      // %
    runTime: number;         // minutes
    lastUpdated: FirebaseFirestore.Timestamp;
  };
  targetRanges: {
    flowRate: { min: number; max: number };
    pressure: { min: number; max: number };
    temperature: { min: number; max: number };
    ultrasonicFrequency: { min: number; max: number };
    powerLevel: { min: number; max: number };
  };
  status: 'running' | 'stopped' | 'alarm' | 'maintenance' | 'offline';
  createdAt: FirebaseFirestore.Timestamp;
  updatedAt: FirebaseFirestore.Timestamp;
}
```

### Relationships
- Many-to-one with Facility (processing system belongs to one facility)
- One-to-many with Devices (processing system monitored by multiple devices)
- One-to-many with SensorReadings (processing system generates sensor data)
- One-to-many with Alerts (processing system can trigger alerts)

## Device

**Purpose:** Represents IoT devices that monitor and control industrial ultrasonic processing equipment

**Key Attributes:**
- id: string - Unique device identifier
- facilityId: string - Parent facility reference
- systemId: string - Processing system being monitored
- type: DeviceType - Type of device (flow_sensor, pressure_sensor, temperature_sensor, sonicator_controller, pump_controller)
- model: string - Device model/manufacturer info
- status: DeviceStatus - Current operational status
- lastSeen: Timestamp - Last communication timestamp
- configuration: DeviceConfig - Device-specific settings

### TypeScript Interface

```typescript
interface Device {
  id: string;
  facilityId: string;
  systemId: string;
  type: 'flow_sensor' | 'pressure_sensor' | 'temperature_sensor' | 'ultrasonic_frequency_monitor' | 'sonicator_controller' | 'pump_controller' | 'valve_controller';
  model: string;
  firmware: string;
  status: 'online' | 'offline' | 'error' | 'maintenance';
  lastSeen: FirebaseFirestore.Timestamp;
  configuration: {
    reportingInterval: number; // seconds
    alertThresholds: Record<string, number>;
    calibration: Record<string, number>;
    controlParameters: Record<string, number>; // For controllers
  };
  location: {
    systemPosition: string; // e.g., "inlet", "outlet", "main_chamber"
    coordinates: {
      x: number;
      y: number;
      z: number;
    };
  };
  createdAt: FirebaseFirestore.Timestamp;
  updatedAt: FirebaseFirestore.Timestamp;
}
```

### Relationships
- Many-to-one with Facility (device belongs to one facility)
- Many-to-one with Environment (device monitors one environment)
- One-to-many with SensorReadings (device generates sensor data)

## SensorReading

**Purpose:** Time-series data from industrial sensors monitoring ultrasonic processing parameters

**Key Attributes:**
- id: string - Unique reading identifier
- deviceId: string - Source device reference
- systemId: string - Processing system reference
- timestamp: Timestamp - Reading timestamp
- sensorType: string - Type of sensor measurement
- value: number - Sensor reading value
- unit: string - Measurement unit
- quality: number - Data quality score (0-1)

### TypeScript Interface

```typescript
interface SensorReading {
  id: string;
  deviceId: string;
  systemId: string;
  timestamp: FirebaseFirestore.Timestamp;
  sensorType: 'flow_rate' | 'pressure' | 'temperature' | 'ultrasonic_frequency' | 'power_level' | 'vibration' | 'liquid_level';
  value: number;
  unit: string;
  quality: number; // 0-1 quality score
  metadata?: {
    calibrated: boolean;
    anomaly: boolean;
    interpolated: boolean;
    processingCycle: string; // Current processing cycle ID
  };
}
```

### Relationships
- Many-to-one with Device (reading from one device)
- Many-to-one with Environment (reading for one environment)

## Alert

**Purpose:** System alerts triggered by processing parameter deviations or equipment malfunctions

**Key Attributes:**
- id: string - Unique alert identifier
- facilityId: string - Facility reference
- systemId: string - Processing system reference (optional)
- deviceId: string - Device reference (optional)
- type: AlertType - Category of alert (process_parameter, equipment_malfunction, safety, maintenance)
- severity: AlertSeverity - Alert priority level
- message: string - Human-readable alert description
- status: AlertStatus - Current alert state
- triggeredAt: Timestamp - When alert was first triggered
- acknowledgedAt: Timestamp - When alert was acknowledged
- resolvedAt: Timestamp - When alert was resolved

### TypeScript Interface

```typescript
interface Alert {
  id: string;
  facilityId: string;
  systemId?: string;
  deviceId?: string;
  type: 'process_parameter' | 'equipment_malfunction' | 'safety' | 'maintenance' | 'system';
  severity: 'low' | 'medium' | 'high' | 'critical';
  message: string;
  status: 'active' | 'acknowledged' | 'resolved' | 'suppressed';
  triggeredAt: FirebaseFirestore.Timestamp;
  acknowledgedAt?: FirebaseFirestore.Timestamp;
  acknowledgedBy?: string;
  resolvedAt?: FirebaseFirestore.Timestamp;
  resolvedBy?: string;
  metadata: {
    threshold?: number;
    currentValue?: number;
    duration?: number;
    parameterType?: string; // e.g., 'flow_rate', 'pressure', 'temperature'
    processingCycle?: string;
    recommendedAction?: string;
  };
}
```

### Relationships
- Many-to-one with Facility (alert for one facility)
- Many-to-one with Environment (alert for one environment, optional)
- Many-to-one with Device (alert from one device, optional)
- Many-to-one with User (alert acknowledged/resolved by user)
