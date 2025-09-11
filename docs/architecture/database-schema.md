# Database Schema Documentation

## Firebase RTDB Industrial Automation System Schema

> This document defines the Firebase Real-Time Database schema for the Industrial Automation System mobile application.
> **Version:** 2.0.0
> **Last Updated:** 2025-01-09
> **Authors:** CannaSol Technologies Development Team

---

## Table of Contents

1. [Overview](#overview)
2. [Root Structure](#root-structure)
3. [Device Schema](#device-schema)
4. [Module Definitions](#module-definitions)
5. [Users Schema](#users-schema)
6. [Validation Rules](#validation-rules)
7. [Performance Optimization](#performance-optimization)
8. [Security Best Practices](#security-best-practices)
9. [Migration Guidelines](#migration-guidelines)

---

## Overview

This schema defines a hierarchical NoSQL structure optimized for real-time industrial automation monitoring. The design prioritizes:

- **Real-time Performance**: Optimized for frequent reads and targeted writes
- **Scalability**: Supports multiple devices and users with efficient querying
- **Data Integrity**: Comprehensive validation and type safety
- **Security**: Role-based access control and data isolation

### Key Design Principles

1. **Hierarchical Organization**: Devices → Modules → Data points
2. **Normalized Structure**: Avoid data duplication while maintaining query efficiency
3. **Type Consistency**: Strict data typing for reliability
4. **Version Control**: Schema versioning for backward compatibility

---

## Root Structure

```json
{
  "Devices": {
    "[DEVICE_ID]": {
      // Device-specific data structure (see Device Schema below)
    }
  },
  "users": {
    "[USER_ID]": {
      // User-specific data structure (see Users Schema below)
    }
  },
  "_metadata": {
    "version": "2.0.0",
    "last_updated": 1736380800000,
    "schema_hash": "abc123def456"
  }
}
```

---

## Device Schema

Each device follows a standardized structure with optional modules based on device capabilities.

### Core Structure

```json
{
  "[DEVICE_ID]": {
    "Info": {
      // Required: Device identification and status
    },
    "State": {
      // Required: Real-time operational state
    },
    "Config": {
      // Required: Device configuration parameters
    },
    "Alarms": {
      // Required: Current alarm states
    },
    "AlarmLogs": {
      // Optional: Historical alarm records
    },
    "History": {
      // Optional: Historical run data
    },
    "SaveSlots": {
      // Optional: Configuration presets
    },
    "Watchers": {
      // Optional: User access control
    },
    "CloudLogging": {
      // Optional: Cloud export settings
    },
    "CurrentRun": {
      // Optional: Active run information
    },
    "Logging": {
      // Optional: Local logging data
    },
    "Simulation": {
      // Optional: Simulation mode settings
    }
  }
}
```

---

## Module Definitions

### Info Module (Required)

Device identification and metadata.

```json
"Info": {
  "id": "35C9-B297-0575-5A53",        // String: Unique device identifier (UUID format)
  "name": "CTESP32C01",               // String: Human-readable device name (1-50 chars)
  "status": "ONLINE",                 // Enum: Device status ["ONLINE", "OFFLINE", "ERROR", "MAINTENANCE"]
  "type": "CTESP32V2",                // Enum: Device type (see Device Types section)
  "firmware_version": "2.1.0",        // String: Current firmware version (semver)
  "last_seen": 1736380800000,         // Number: Unix timestamp of last communication
  "ip_address": "192.168.1.100",      // String: Device IP address (optional)
  "mac_address": "AA:BB:CC:DD:EE:FF" // String: Device MAC address (optional)
}
```

**Validation Rules:**

- `id`: Required, 1-50 characters, alphanumeric + spaces + hyphens
  - UUID format: `^[A-F0-9]{4}-[A-F0-9]{4}-[A-F0-9]{4}-[A-F0-9]{4}$`
    (required for real Hardware devices - Simulated devices can use a random string.)
- `name`: Required, 1-50 characters, alphanumeric + spaces + hyphens
- `status`: Required, enum validation
- `type`: Required, enum validation
- `last_seen`: Required, valid Unix timestamp

### State Module (Required)

Real-time operational state data.

```json
"State": {
  "alarms_cleared": false,           // Boolean: All alarms cleared flag
  "avg_flow_rate": 26.16431,         // Number: Current average flow rate (0-1000, 2 decimals)
  "avg_temp": 27.94433,              // Number: Current average temperature (-50-200, 2 decimals)
  "flow": 26.23536,                  // Number: Current flow rate (0-1000, 2 decimals)
  "freq_lock": false,                // Boolean: Frequency lock status
  "num_passes": 3.739647,            // Number: Current number of passes (0+, 6 decimals)
  "params_valid": true,              // Boolean: Parameters validation status
  "pressure": 59.56364,              // Number: Current pressure reading (0-200, 2 decimals)
  "pump_status": false,              // Boolean: Pump operational status
  "run_hours": 0,                    // Integer: Current run hours (0-999)
  "run_minutes": 14,                 // Integer: Current run minutes (0-59)
  "run_seconds": 849,                // Integer: Current run seconds (0-59)
  "state": 1,                        // Integer: System state code (see State Codes)
  "temperature": 29.8,               // Number: Current temperature (-50-200, 1 decimal)
  "warming_up": true,                // Boolean: Warming up phase flag
  "last_updated": 1736380800000      // Number: Unix timestamp of last state update
}
```

**Validation Rules:**
- All numeric fields: Range validation as specified
- Boolean fields: Strict boolean type (no 0/1 integers)
- `state`: Must be valid state code (0-4)
- `last_updated`: Required, valid Unix timestamp

### Config Module (Required)

Device configuration parameters with strict type consistency.

```json
"Config": {
  "abort_run": false,                 // Boolean: Abort current run
  "batch_size": 99.0,                 // Number: Batch size parameter (0-1000, 1 decimal)
  "cool_down_temp": 25.0,             // Number: Cooldown temperature threshold (-50-200, 1 decimal)
  "enable_cooldown": true,            // Boolean: Enable cooldown phase
  "end_run": false,                   // Boolean: End current run
  "flow_thresh": 15.0,                // Number: Flow rate threshold (0-1000, 1 decimal)
  "load_slot": 0,                     // Integer: Load configuration from slot (0-5)
  "pressure_thresh": 50.0,            // Number: Pressure threshold (0-200, 1 decimal)
  "pump_control": true,               // Boolean: Pump control enabled
  "restart": false,                   // Boolean: Restart system
  "resume": true,                     // Boolean: Resume operation
  "save_slot": 0,                     // Integer: Save configuration to slot (0-5)
  "set_hours": 5,                     // Integer: Target run hours (0-999)
  "set_minutes": 0,                   // Integer: Target run minutes (0-59)
  "set_temp": 61.3,                   // Number: Target temperature (-50-200, 1 decimal)
  "start": false,                     // Boolean: Start operation
  "temp_thresh": 5.0,                 // Number: Temperature threshold variance (0-50, 1 decimal)
  "last_modified": 1736380800000,     // Number: Unix timestamp of last config change
  "modified_by": "user123"            // String: User ID who last modified config
}
```

**Validation Rules:**
- Boolean fields: Strict boolean type
- Numeric fields: Range validation with specified precision
- Integer fields: Must be whole numbers within ranges
- Cross-field validation: `set_hours` + `set_minutes` > 0 for valid run duration

### Alarms Module (Required)

Current alarm states with consistent boolean typing.

```json
"Alarms": {
  "flow_alarm": false,         // Boolean: Flow rate alarm active
  "flow_warn": false,          // Boolean: Flow rate warning active
  "freq_lock_alarm": false,    // Boolean: Frequency lock alarm active
  "ign_flow_alarm": false,     // Boolean: Ignore flow alarm flag
  "ign_freqlock_alarm": false, // Boolean: Ignore frequency lock alarm flag
  "ign_overload_alarm": false, // Boolean: Ignore overload alarm flag
  "ign_pressure_alarm": false, // Boolean: Ignore pressure alarm flag
  "ign_temp_alarm": false,     // Boolean: Ignore temperature alarm flag
  "overload_alarm": false,     // Boolean: Overload alarm active
  "pressure_alarm": false,     // Boolean: Pressure alarm active
  "pressure_warn": false,      // Boolean: Pressure warning active
  "temp_alarm": false,         // Boolean: Temperature alarm active
  "temp_warn": false          // Boolean: Temperature warning active
}
```

**Validation Rules:**
- All fields: Strict boolean type only
- No integer 0/1 values allowed

### AlarmLogs Module (Optional)

Historical alarm records with proper timestamp validation.

```json
"AlarmLogs": {
  "[ LOG_ID]": {
    "cleared_time": 0,              // Number: Unix timestamp when alarm was cleared (0 if active)
    "start_time": 1750200755,       // Number: Unix timestamp when alarm started
    "type": "Flow alarm",           // String: Alarm type (see Alarm Types)
    "severity": "warning",          // String: Alarm severity ["info", "warning", "error", "critical"]
    "acknowledged": false,          // Boolean: Whether alarm was acknowledged
    "acknowledged_by": null,        // String: User ID who acknowledged (null if not acknowledged)
    "acknowledged_at": null         // Number: Timestamp of acknowledgment (null if not acknowledged)
  }
}
```

**Validation Rules:**
- `cleared_time`: 0 or valid Unix timestamp
- `start_time`: Valid Unix timestamp, required
- `type`: Must be from predefined alarm types
- `severity`: Must be from predefined severity levels

### History Module (Optional)

Historical run data with comprehensive validation.

```json
"History": {
  "[RUN_ID]": {
    "alarm_logs": {                 // Optional: Alarms during this run
      "[ALARM_ID]": {
        "cleared_time": 1750216272,
        "start_time": 1750214458,
        "type": "Flow alarm",
        "severity": "warning"
      }
    },
    "avg_flow_rate": 0.437753,      // Number: Average flow rate (0-1000, 6 decimals)
    "avg_temp": 31.7333,            // Number: Average temperature (-50-200, 4 decimals)
    "end_time": 1744395791,         // Number: Unix timestamp: Run end time
    "num_passes": 0.024213,         // Number: Number of process passes (0+, 6 decimals)
    "run_hours": 0,                 // Integer: Total run hours (0-999)
    "run_minutes": 2,               // Integer: Total run minutes (0-59)
    "run_seconds": 151,             // Integer: Total run seconds (0-59)
    "start_time": 1744395637,       // Number: Unix timestamp: Run start time
    "start_user": "user123",        // String: User who started the run
    "system_config": {              // Configuration used for this run
      "batch_size": 45.5,
      "cool_down_temp": 45.0,
      "enable_cooldown": false,
      "flow_thresh": 6.5,
      "pressure_thresh": 10.0,
      "set_hours": 1,
      "set_minutes": 36,
      "set_temp": 45.0
    },
    "total_energy": 1250.5,         // Number: Total energy consumption in Wh (optional)
    "efficiency_rating": 85.2       // Number: Process efficiency percentage (0-100, 1 decimal)
  }
}
```

**Validation Rules:**
- `start_time` < `end_time`
- Duration fields must be consistent with timestamp difference
- All numeric fields within specified ranges

### SaveSlots Module (Optional)

Configuration presets with validation.

```json
"SaveSlots": {
  "slot_1": {
    "batch_size": 0.0,              // Number: Saved batch size (0-1000, 1 decimal)
    "cool_down_temp": 45.0,         // Number: Saved cooldown temperature (-50-200, 1 decimal)
    "enable_cooldown": true,        // Boolean: Saved cooldown setting
    "hours": 0,                     // Integer: Saved target hours (0-999)
    "min_flow": 4.0,                // Number: Saved minimum flow rate (0-1000, 1 decimal)
    "min_pressure": 8.0,            // Number: Saved minimum pressure (0-200, 1 decimal)
    "minutes": 0,                   // Integer: Saved target minutes (0-59)
    "set_temp": 0.0,                // Number: Saved target temperature (-50-200, 1 decimal)
    "temp_var": 3.0,                // Number: Saved temperature variance (0-50, 1 decimal)
    "name": "Default Config",       // String: Slot name (optional, 1-30 chars)
    "created_at": 1736380800000,    // Number: Creation timestamp
    "created_by": "user123"         // String: User who created the slot
  },
  "slot_2": { /* Same structure */ },
  "slot_3": { /* Same structure */ },
  "slot_4": { /* Same structure */ },
  "slot_5": { /* Same structure */ }
}
```

### Simulation Module (Optional)

```json
"Simulation": {
  "status": "stopped",              // String: Simulation status ["running", "stopped", "paused"]
  "timer_expired": false,           // Boolean: Timer expiration flag
  "alarm_active_time": 0,           // Number: Total time alarms were active (seconds)
  "alarm_count": 0,                 // Integer: Number of alarms triggered
  "warn_count": 0,                  // Integer: Number of warnings triggered
  "start_time": 1736380800000,      // Number: Simulation start timestamp
  "end_time": null,                 // Number: Simulation end timestamp (null if running)
  "scenario": "normal_operation"    // String: Simulation scenario type
}
```

### Watchers Module (Optional)

```json
"Watchers": {
  "[USER_ID]": true                 // Boolean: User has access to watch this device
}
```

---

## Users Schema

User management and preferences.

```json
"users": {
  "[USER_ID]": {
    "does_accept_tac": true,         // Boolean: Terms and conditions acceptance
    "email": "user@example.com",     // String: User email address
    "email_on_alarm": true,          // Boolean: Email notifications for alarms
    "name": "John Doe",              // String: Display name
    "selected_device": "device123",  // String: Currently selected device ID
    "watched_devices": {             // Object: Devices user can access
      "device123": true,
      "device456": true
    },
    "notification_tokens": {         // Object: Push notification tokens
      "token123": "firebase_token_value"
    },
    "role": "technician",            // String: User role ["admin", "manager", "technician", "viewer"]
    "preferences": {                 // Object: User preferences
      "theme": "dark",               // String: UI theme ["light", "dark", "system"]
      "units": "metric",             // String: Measurement units ["metric", "imperial"]
      "timezone": "America/New_York" // String: User timezone
    },
    "created_at": 1736380800000,     // Number: Account creation timestamp
    "last_login": 1736380800000,     // Number: Last login timestamp
    "is_active": true                // Boolean: Account active status
  }
}
```

---

## Validation Rules

### JSON Schema Definition

```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "type": "object",
  "properties": {
    "Devices": {
      "type": "object",
      "patternProperties": {
        "^[A-F0-9]{4}-[A-F0-9]{4}-[A-F0-9]{4}-[A-F0-9]{4}$": {
          "$ref": "#/definitions/device"
        }
      }
    },
    "users": {
      "type": "object",
      "patternProperties": {
        "^[a-zA-Z0-9_-]{28}$": {
          "$ref": "#/definitions/user"
        }
      }
    }
  },
  "definitions": {
    "device": {
      "type": "object",
      "required": ["Info", "State", "Config", "Alarms"],
      "properties": {
        "Info": { "$ref": "#/definitions/info" },
        "State": { "$ref": "#/definitions/state" },
        "Config": { "$ref": "#/definitions/config" },
        "Alarms": { "$ref": "#/definitions/alarms" }
      }
    },
    "info": {
      "type": "object",
      "required": ["id", "name", "status", "type", "last_seen"],
      "properties": {
        "id": { "type": "string", "pattern": "^[A-F0-9]{4}-[A-F0-9]{4}-[A-F0-9]{4}-[A-F0-9]{4}$" },
        "name": { "type": "string", "minLength": 1, "maxLength": 50 },
        "status": { "enum": ["ONLINE", "OFFLINE", "ERROR", "MAINTENANCE"] },
        "type": { "enum": ["CTESP32V2", "CTESP32V2_PROD", "ESP32_REV_0"] },
        "last_seen": { "type": "number", "minimum": 0 }
      }
    },
    "state": {
      "type": "object",
      "required": ["alarms_cleared", "params_valid", "last_updated"],
      "properties": {
        "alarms_cleared": { "type": "boolean" },
        "avg_flow_rate": { "type": "number", "minimum": 0, "maximum": 1000 },
        "avg_temp": { "type": "number", "minimum": -50, "maximum": 200 },
        "params_valid": { "type": "boolean" },
        "last_updated": { "type": "number", "minimum": 0 }
      }
    },
    "config": {
      "type": "object",
      "properties": {
        "abort_run": { "type": "boolean" },
        "batch_size": { "type": "number", "minimum": 0, "maximum": 1000 },
        "cool_down_temp": { "type": "number", "minimum": -50, "maximum": 200 },
        "enable_cooldown": { "type": "boolean" },
        "last_modified": { "type": "number", "minimum": 0 },
        "modified_by": { "type": "string" }
      }
    },
    "alarms": {
      "type": "object",
      "properties": {
        "flow_alarm": { "type": "boolean" },
        "flow_warn": { "type": "boolean" },
        "freq_lock_alarm": { "type": "boolean" },
        "ign_flow_alarm": { "type": "boolean" },
        "ign_freqlock_alarm": { "type": "boolean" },
        "ign_overload_alarm": { "type": "boolean" },
        "ign_pressure_alarm": { "type": "boolean" },
        "ign_temp_alarm": { "type": "boolean" },
        "overload_alarm": { "type": "boolean" },
        "pressure_alarm": { "type": "boolean" },
        "pressure_warn": { "type": "boolean" },
        "temp_alarm": { "type": "boolean" },
        "temp_warn": { "type": "boolean" }
      }
    },
    "user": {
      "type": "object",
      "required": ["email", "name"],
      "properties": {
        "does_accept_tac": { "type": "boolean" },
        "email": { "type": "string", "format": "email" },
        "email_on_alarm": { "type": "boolean" },
        "name": { "type": "string", "minLength": 1, "maxLength": 100 },
        "role": { "enum": ["admin", "manager", "technician", "viewer"] },
        "is_active": { "type": "boolean" }
      }
    }
  }
}
```

---

## Performance Optimization

### Indexing Strategy

1. **Device Queries**: Index on `/Devices/{deviceId}/Info/status` for status filtering
2. **User Queries**: Index on `/users/{userId}/watched_devices` for device access
3. **Time-based Queries**: Index on timestamp fields for historical data
4. **Alarm Queries**: Compound index on `/Devices/{deviceId}/Alarms/{alarmType}`

### Query Optimization

```javascript
// Efficient device status query
const onlineDevices = await db.ref('Devices')
  .orderByChild('Info/status')
  .equalTo('ONLINE')
  .limitToFirst(50)
  .once('value');

// Efficient user device access
const userDevices = await db.ref(`users/${userId}/watched_devices`)
  .once('value');
```

### Data Denormalization Strategy

- **Read Optimization**: Duplicate user info in device watchers for fast access
- **Write Optimization**: Use atomic updates for related data changes
- **Cache Strategy**: Implement client-side caching for frequently accessed data

### Connection Optimization

- **Persistence**: Enable offline persistence for critical data
- **Bandwidth**: Use compression for large datasets
- **Batch Operations**: Group related updates in single transactions

---

## Security Best Practices

### Access Control Patterns

```javascript
// Device access validation
function canAccessDevice(userId, deviceId) {
  return db.ref(`users/${userId}/watched_devices/${deviceId}`)
    .once('value')
    .then(snapshot => snapshot.exists());
}

// Role-based permissions
const permissions = {
  admin: ['read', 'write', 'delete', 'manage_users'],
  manager: ['read', 'write', 'manage_devices'],
  technician: ['read', 'write'],
  viewer: ['read']
};
```

### Data Validation

- **Input Sanitization**: Validate all user inputs before database writes
- **Type Checking**: Enforce strict typing to prevent injection attacks
- **Rate Limiting**: Implement rate limiting for write operations
- **Audit Logging**: LOG all configuration changes with user context

### Encryption Strategy

- **Data at Rest**: Encrypt sensitive configuration data
- **Data in Transit**: Use HTTPS for all Firebase communications
- **API Keys**: Store API keys securely, never in client code

---

## Migration Guidelines

### Version Control

```json
"_metadata": {
  "version": "2.0.0",
  "last_updated": 1736380800000,
  "schema_hash": "abc123def456",
  "migration_history": [
    {
      "from_version": "1.0.0",
      "to_version": "2.0.0",
      "migrated_at": 1736380800000,
      "migrated_by": "system"
    }
  ]
}
```

### Migration Scripts

```javascript
// Example migration from v1.0.0 to v2.0.0
async function migrateToV2() {
  const devicesRef = db.ref('Devices');

  const snapshot = await devicesRef.once('value');
  const updates = {};

  snapshot.forEach(deviceSnapshot => {
    const deviceId = deviceSnapshot.key;
    const deviceData = deviceSnapshot.val();

    // Add new required fields
    updates[`Devices/${deviceId}/Info/last_seen`] = Date.now();
    updates[`Devices/${deviceId}/State/last_updated`] = Date.now();
    updates[`Devices/${deviceId}/Config/last_modified`] = Date.now();

    // Convert integer booleans to actual booleans
    Object.keys(deviceData.Config).forEach(key => {
      if (typeof deviceData.Config[key] === 'number' && (deviceData.Config[key] === 0 || deviceData.Config[key] === 1)) {
        updates[`Devices/${deviceId}/Config/${key}`] = Boolean(deviceData.Config[key]);
      }
    });
  });

  await db.ref().update(updates);
}
```

### Backward Compatibility

- **Graceful Degradation**: Support old clients with new schema
- **Feature Flags**: Use feature flags for new functionality
- **Version Negotiation**: Client-server version compatibility checking

---

## Error Handling and Edge Cases

### Common Error Scenarios

1. **Network Connectivity**: Handle offline/online state transitions
2. **Data Corruption**: Implement data integrity checks
3. **Concurrent Writes**: Use transactions for atomic operations
4. **Schema Violations**: Validate data before writes

### Error Recovery Patterns

```javascript
// Transaction with retry logic
async function updateDeviceConfig(deviceId, newConfig, maxRetries = 3) {
  let retries = 0;

  while (retries < maxRetries) {
    try {
      await db.ref(`Devices/${deviceId}/Config`).transaction(currentConfig => {
        if (!currentConfig) return null;

        // Validate new configuration
        if (!isValidConfig(newConfig)) {
          throw new Error('Invalid configuration');
        }

        return {
          ...currentConfig,
          ...newConfig,
          last_modified: Date.now(),
          modified_by: getCurrentUserId()
        };
      });
      break; // Success
    } catch (error) {
      retries++;
      if (retries >= maxRetries) {
        throw new Error(`Failed to update config after ${maxRetries} attempts: ${error.message}`);
      }
      await delay(Math.pow(2, retries) * 1000); // Exponential backoff
    }
  }
}
```

### Data Integrity Checks

- **Checksum Validation**: Add checksums for critical data blocks
- **Timestamp Validation**: Ensure timestamps are reasonable and sequential
- **Reference Integrity**: Validate foreign key relationships
- **Constraint Validation**: Enforce business rules at database level

---

## Device Types

- `CTESP32V2`: Standard ESP32 device version 2
- `CTESP32V2_PROD`: Production ESP32 device version 2
- `ESP32_REV_0`: ESP32 revision 0

## State Codes

- `0`: Idle/Stopped
- `1`: Running/Active
- `2`: Warming up
- `3`: Cooling down
- `4`: Error/Fault state

## Alarm Types

- `Flow alarm`: Flow rate outside acceptable range
- `Pressure alarm`: Pressure outside acceptable range
- `Temp alarm`: Temperature outside acceptable range
- `Freq lock alarm`: Frequency lock failure
- `Overload alarm`: System overload condition

---

## Implementation Notes

### Client Libraries

- **Web**: Use Firebase JavaScript SDK with TypeScript for type safety
- **Mobile**: Use Firebase iOS/Android SDKs with platform-specific optimizations
- **Backend**: Use Firebase Admin SDK for server-side operations

### Monitoring and Alerting

- **Performance Metrics**: Monitor query performance and data usage
- **Error Tracking**: Implement comprehensive error logging
- **Usage Analytics**: Track data access patterns for optimization

### Testing Strategy

- **Unit Tests**: Test individual schema validation functions
- **Integration Tests**: Test full data flow with Firebase emulator
- **Load Tests**: Validate performance under high concurrency
- **Migration Tests**: Test schema migrations with production data

---

*This document is maintained by the CannaSol Technologies development team. For questions or contributions, please contact the architecture team.*
