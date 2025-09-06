# Database Schema

## Firestore Collections Structure

```javascript
// Users Collection
users/{userId} {
  uid: string,
  email: string,
  displayName: string,
  role: 'admin' | 'manager' | 'technician' | 'viewer',
  facilities: string[], // Array of facility IDs
  preferences: {
    notifications: boolean,
    theme: 'light' | 'dark' | 'system',
    units: 'metric' | 'imperial'
  },
  createdAt: Timestamp,
  lastLoginAt: Timestamp
}

// Facilities Collection
facilities/{facilityId} {
  id: string,
  name: string,
  address: {
    street: string,
    city: string,
    state: string,
    zipCode: string,
    country: string
  },
  timezone: string,
  environments: string[], // Array of environment IDs
  settings: {
    alertThresholds: Map<string, number>,
    operatingHours: {
      start: string,
      end: string
    },
    emergencyContacts: string[]
  },
  status: 'active' | 'maintenance' | 'offline',
  createdAt: Timestamp,
  updatedAt: Timestamp
}

// Environments Collection
environments/{environmentId} {
  id: string,
  facilityId: string,
  name: string,
  type: 'vegetative' | 'flowering' | 'drying' | 'storage',
  devices: string[], // Array of device IDs
  currentConditions: {
    temperature: number,
    humidity: number,
    co2: number,
    lightLevel: number,
    soilMoisture: number,
    ph: number,
    lastUpdated: Timestamp
  },
  targetRanges: {
    temperature: { min: number, max: number },
    humidity: { min: number, max: number },
    co2: { min: number, max: number },
    lightLevel: { min: number, max: number },
    soilMoisture: { min: number, max: number },
    ph: { min: number, max: number }
  },
  status: 'optimal' | 'warning' | 'critical' | 'offline',
  createdAt: Timestamp,
  updatedAt: Timestamp
}

// Devices Collection
devices/{deviceId} {
  id: string,
  facilityId: string,
  environmentId: string,
  type: 'temperature_sensor' | 'humidity_sensor' | 'co2_sensor' | 'camera' | 'hvac_controller' | 'irrigation_controller',
  model: string,
  firmware: string,
  status: 'online' | 'offline' | 'error' | 'maintenance',
  lastSeen: Timestamp,
  configuration: {
    reportingInterval: number, // seconds
    alertThresholds: Map<string, number>,
    calibration: Map<string, number>
  },
  location: {
    x: number,
    y: number,
    z: number
  },
  createdAt: Timestamp,
  updatedAt: Timestamp
}

// Alerts Collection
alerts/{alertId} {
  id: string,
  facilityId: string,
  environmentId?: string,
  deviceId?: string,
  type: 'environmental' | 'device' | 'security' | 'system',
  severity: 'low' | 'medium' | 'high' | 'critical',
  message: string,
  status: 'active' | 'acknowledged' | 'resolved' | 'suppressed',
  triggeredAt: Timestamp,
  acknowledgedAt?: Timestamp,
  acknowledgedBy?: string,
  resolvedAt?: Timestamp,
  resolvedBy?: string,
  metadata: {
    threshold?: number,
    currentValue?: number,
    duration?: number
  }
}

// Sensor Readings Collection (Subcollection under environments)
environments/{environmentId}/readings/{readingId} {
  id: string,
  deviceId: string,
  timestamp: Timestamp,
  sensorType: 'temperature' | 'humidity' | 'co2' | 'light' | 'soil_moisture' | 'ph',
  value: number,
  unit: string,
  quality: number, // 0-1 quality score
  metadata?: {
    calibrated: boolean,
    anomaly: boolean,
    interpolated: boolean
  }
}
```

## Firestore Security Rules

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can only access their own user document
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }

    // Facilities access based on user's facility list
    match /facilities/{facilityId} {
      allow read: if request.auth != null &&
        facilityId in get(/databases/$(database)/documents/users/$(request.auth.uid)).data.facilities;
      allow write: if request.auth != null &&
        hasRole('admin') || hasRole('manager');
    }

    // Environments inherit facility permissions
    match /environments/{environmentId} {
      allow read: if request.auth != null &&
        canAccessFacility(resource.data.facilityId);
      allow write: if request.auth != null &&
        (hasRole('admin') || hasRole('manager')) &&
        canAccessFacility(resource.data.facilityId);

      // Sensor readings subcollection
      match /readings/{readingId} {
        allow read: if request.auth != null &&
          canAccessFacility(get(/databases/$(database)/documents/environments/$(environmentId)).data.facilityId);
        allow write: if false; // Only backend services can write readings
      }
    }

    // Devices inherit facility permissions
    match /devices/{deviceId} {
      allow read: if request.auth != null &&
        canAccessFacility(resource.data.facilityId);
      allow write: if request.auth != null &&
        (hasRole('admin') || hasRole('manager')) &&
        canAccessFacility(resource.data.facilityId);
    }

    // Alerts inherit facility permissions
    match /alerts/{alertId} {
      allow read: if request.auth != null &&
        canAccessFacility(resource.data.facilityId);
      allow update: if request.auth != null &&
        canAccessFacility(resource.data.facilityId) &&
        // Only allow status updates (acknowledge/resolve)
        request.resource.data.diff(resource.data).affectedKeys().hasOnly(['status', 'acknowledgedAt', 'acknowledgedBy', 'resolvedAt', 'resolvedBy']);
    }

    // Helper functions
    function hasRole(role) {
      return request.auth.token.role == role;
    }

    function canAccessFacility(facilityId) {
      return facilityId in get(/databases/$(database)/documents/users/$(request.auth.uid)).data.facilities;
    }
  }
}
```
