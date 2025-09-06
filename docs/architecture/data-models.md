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

**Purpose:** Represents a cannabis cultivation facility with multiple growing environments

**Key Attributes:**
- id: string - Unique facility identifier
- name: string - Facility display name
- address: Address - Physical location
- timezone: string - Facility timezone for scheduling
- environments: string[] - Array of environment IDs within facility
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
  environments: string[];
  settings: {
    alertThresholds: Record<string, number>;
    operatingHours: {
      start: string;
      end: string;
    };
    emergencyContacts: string[];
  };
  status: 'active' | 'maintenance' | 'offline';
  createdAt: FirebaseFirestore.Timestamp;
  updatedAt: FirebaseFirestore.Timestamp;
}
```

### Relationships
- One-to-many with Environments (facility contains multiple grow environments)
- Many-to-many with Users (multiple users can access facility)
- One-to-many with Devices (facility contains multiple monitoring devices)

## Environment

**Purpose:** Represents a specific growing environment within a facility (room, tent, greenhouse section)

**Key Attributes:**
- id: string - Unique environment identifier
- facilityId: string - Parent facility reference
- name: string - Environment display name
- type: EnvironmentType - Type of growing environment
- devices: string[] - Array of device IDs monitoring this environment
- currentConditions: EnvironmentConditions - Latest sensor readings
- targetRanges: EnvironmentTargets - Desired environmental parameters

### TypeScript Interface

```typescript
interface Environment {
  id: string;
  facilityId: string;
  name: string;
  type: 'vegetative' | 'flowering' | 'drying' | 'storage';
  devices: string[];
  currentConditions: {
    temperature: number;
    humidity: number;
    co2: number;
    lightLevel: number;
    soilMoisture: number;
    ph: number;
    lastUpdated: FirebaseFirestore.Timestamp;
  };
  targetRanges: {
    temperature: { min: number; max: number };
    humidity: { min: number; max: number };
    co2: { min: number; max: number };
    lightLevel: { min: number; max: number };
    soilMoisture: { min: number; max: number };
    ph: { min: number; max: number };
  };
  status: 'optimal' | 'warning' | 'critical' | 'offline';
  createdAt: FirebaseFirestore.Timestamp;
  updatedAt: FirebaseFirestore.Timestamp;
}
```

### Relationships
- Many-to-one with Facility (environment belongs to one facility)
- One-to-many with Devices (environment monitored by multiple devices)
- One-to-many with SensorReadings (environment generates sensor data)
- One-to-many with Alerts (environment can trigger alerts)

## Device

**Purpose:** Represents IoT devices that monitor and control environmental conditions

**Key Attributes:**
- id: string - Unique device identifier
- facilityId: string - Parent facility reference
- environmentId: string - Environment being monitored
- type: DeviceType - Type of device (sensor, controller, camera)
- model: string - Device model/manufacturer info
- status: DeviceStatus - Current operational status
- lastSeen: Timestamp - Last communication timestamp
- configuration: DeviceConfig - Device-specific settings

### TypeScript Interface

```typescript
interface Device {
  id: string;
  facilityId: string;
  environmentId: string;
  type: 'temperature_sensor' | 'humidity_sensor' | 'co2_sensor' | 'camera' | 'hvac_controller' | 'irrigation_controller';
  model: string;
  firmware: string;
  status: 'online' | 'offline' | 'error' | 'maintenance';
  lastSeen: FirebaseFirestore.Timestamp;
  configuration: {
    reportingInterval: number; // seconds
    alertThresholds: Record<string, number>;
    calibration: Record<string, number>;
  };
  location: {
    x: number;
    y: number;
    z: number;
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

**Purpose:** Time-series data from IoT sensors with high-frequency updates

**Key Attributes:**
- id: string - Unique reading identifier
- deviceId: string - Source device reference
- environmentId: string - Environment reference
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
  environmentId: string;
  timestamp: FirebaseFirestore.Timestamp;
  sensorType: 'temperature' | 'humidity' | 'co2' | 'light' | 'soil_moisture' | 'ph';
  value: number;
  unit: string;
  quality: number; // 0-1 quality score
  metadata?: {
    calibrated: boolean;
    anomaly: boolean;
    interpolated: boolean;
  };
}
```

### Relationships
- Many-to-one with Device (reading from one device)
- Many-to-one with Environment (reading for one environment)

## Alert

**Purpose:** System alerts triggered by environmental conditions or device issues

**Key Attributes:**
- id: string - Unique alert identifier
- facilityId: string - Facility reference
- environmentId: string - Environment reference (optional)
- deviceId: string - Device reference (optional)
- type: AlertType - Category of alert
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
  environmentId?: string;
  deviceId?: string;
  type: 'environmental' | 'device' | 'security' | 'system';
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
  };
}
```

### Relationships
- Many-to-one with Facility (alert for one facility)
- Many-to-one with Environment (alert for one environment, optional)
- Many-to-one with Device (alert from one device, optional)
- Many-to-one with User (alert acknowledged/resolved by user)
