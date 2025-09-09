# Database Schema

## Firebase RTDB Industrial Automation System Schema

> This document defines the Firebase Real-Time Database schema for the Industrial Automation System mobile application.

---

## Root Structure

```json
{
  "Devices": {
    "[DEVICE_ID]": {
      // Device-specific data structure (see Device Schema below)
    }
  }
}
```

## Device Schema

Each device in the system follows this standardized structure:

```json
{
  "[DEVICE_ID]": {
    "AlarmLogs": {
      // Historical alarm records
    },
    "Alarms": {
      // Current alarm states
    },
    "CloudLogging": {
      // Cloud export settings (optional)
    },
    "Config": {
      // Device configuration parameters
    },
    "CurrentRun": {
      // Active run information (optional)
    },
    "History": {
      // Historical run data
    },
    "Info": {
      // Device identification and status
    },
    "Logging": {
      // Local logging data (optional)
    },
    "SaveSlots": {
      // Saved configuration presets
    },
    "Simulation": {
      // Simulation mode settings (optional)
    },
    "State": {
      // Real-time device state
    },
    "Watchers": {
      // User access control
    }
  }
}
```

## Module Definitions

### AlarmLogs Module

```json
"AlarmLogs": {
  "[LOG_ID]": {
    "cleared_time": 0,           // Unix timestamp when alarm was cleared (0 if active)
    "start_time": 1750200755,    // Unix timestamp when alarm started
    "type": "Flow alarm"         // Type of alarm (Flow, Pressure, Temp, Freq lock, Overload)
  }
}
```

### Alarms Module

```json
"Alarms": {
  "flow_alarm": false,         // Boolean: Flow rate alarm active
  "flow_warn": false,          // Boolean: Flow rate warning active
  "freq_lock_alarm": false,    // Boolean: Frequency lock alarm active
  "ign_flow_alarm": 0,         // Integer: Ignore flow alarm flag
  "ign_freqlock_alarm": 0,     // Integer: Ignore frequency lock alarm flag
  "ign_overload_alarm": 0,     // Integer: Ignore overload alarm flag
  "ign_pressure_alarm": 0,     // Integer: Ignore pressure alarm flag
  "ign_temp_alarm": 0,         // Integer: Ignore temperature alarm flag
  "overload_alarm": false,     // Boolean: Overload alarm active
  "pressure_alarm": false,     // Boolean: Pressure alarm active
  "pressure_warn": false,      // Boolean: Pressure warning active
  "temp_alarm": false,         // Boolean: Temperature alarm active
  "temp_warn": false           // Boolean: Temperature warning active
}
```

### CloudLogging Module (Optional)

```json
"CloudLogging": {
  "export_history": false,     // Boolean: Enable cloud export
  "Spreadsheet": {             // Export file information
    "download_url": "string",
    "file_name": "string",
    "time_stamp": "string"
  },
  "download_links": {
    "[LINK_ID]": {
      "downloadUrl": "string"
    }
  }
}
```

### Config Module

```json
"Config": {
  "abort_run": 0,              // Integer/Boolean: Abort current run
  "batch_size": 99,            // Number: Batch size parameter
  "cool_down_temp": 25,        // Number: Cooldown temperature threshold
  "enable_cooldown": 1,        // Integer/Boolean: Enable cooldown phase
  "end_run": 0,                // Integer/Boolean: End current run
  "flow_thresh": 15,           // Number: Flow rate threshold
  "load_slot": 0,              // Integer: Load configuration from slot
  "pressure_thresh": 50,       // Number: Pressure threshold
  "pump_control": 1,           // Integer/Boolean: Pump control enabled
  "restart": 0,                // Integer/Boolean: Restart system
  "resume": 1,                 // Integer/Boolean: Resume operation
  "save_slot": 0,              // Integer: Save configuration to slot
  "set_hours": 5,              // Integer: Target run hours
  "set_minutes": 0,            // Integer: Target run minutes
  "set_temp": 61.3,            // Number: Target temperature
  "start": 0,                  // Integer/Boolean: Start operation
  "temp_thresh": 5             // Number: Temperature threshold variance
}
```

### CurrentRun Module (Optional)

```json
"CurrentRun": {
  "end_time": "N/A",           // String: End time or "N/A" if running
  "start_time": 1750691821,    // Unix timestamp: Run start time
  "start_user": "[USER_ID]"    // String: User who started the run
}
```

### History Module

```json
"History": {
  "[RUN_ID]": {
    "alarm_logs": {             // Optional: Alarms during this run
      "[ALARM_ID]": {
        "cleared_time": 1750216272,
        "start_time": 1750214458,
        "type": "Flow alarm"
      }
    },
    "avg_flow_rate": 0.437753,  // Number: Average flow rate
    "avg_temp": 31.7333,        // Number: Average temperature
    "end_time": 1744395791,     // Unix timestamp: Run end time
    "num_passes": 0.024213,     // Number: Number of process passes
    "run_hours": 0,             // Integer: Total run hours
    "run_minutes": 2,           // Integer: Total run minutes
    "run_seconds": 151,         // Integer: Total run seconds
    "start_time": 1744395637,   // Unix timestamp: Run start time
    "start_user": "[USER_ID]",  // String: User who started the run
    "system_config": {          // Configuration used for this run
      "batch_size": 45.5,
      "cool_down_temp": 45,
      "enable_cooldown": 0,
      "flow_thresh": 6.5,
      "pressure_thresh": 10,
      "set_hours": 1,
      "set_minutes": 36,
      "set_temp": 45
    }
  }
}
```

### Info Module

```json
"Info": {
  "id": "[DEVICE_ID]",         // String: Unique device identifier
  "name": "Device Name",       // String: Human-readable device name
  "status": "ONLINE",          // String: Device status (ONLINE/OFFLINE)
  "type": "CTESP32V2"          // String: Device type/model
}
```

### Logging Module (Optional)

```json
"Logging": {
  "[LOG_ID]": {
    "avg_flow_rate": 0,         // Number: Average flow rate
    "avg_temp": 0,              // Number: Average temperature
    "num_passes": 0,            // Number: Number of passes
    "run_hours": 0,             // Integer: Run hours
    "run_minutes": 0,           // Integer: Run minutes
    "run_seconds": 0,           // Integer: Run seconds
    "system_config": {          // System configuration at log time
      // Same structure as Config module
    },
    "timestamp": "2024-12-22 06:08:42"  // String: Human-readable timestamp
  }
}
```

### SaveSlots Module

```json
"SaveSlots": {
  "slot_1": {
    "batch_size": 0,            // Number: Saved batch size
    "cool_down_temp": 45,       // Number: Saved cooldown temperature
    "enable_cooldown": 1,       // Integer/Boolean: Saved cooldown setting
    "hours": 0,                 // Integer: Saved target hours
    "min_flow": 4,              // Number: Saved minimum flow rate
    "min_pressure": 8,          // Number: Saved minimum pressure
    "minutes": 0,               // Integer: Saved target minutes
    "set_temp": 0,              // Number: Saved target temperature
    "temp_var": 3               // Number: Saved temperature variance
  },
  "slot_2": {
    // Same structure as slot_1
  },
  "slot_3": {
    // Same structure as slot_1
  },
  "slot_4": {
    // Same structure as slot_1
  },
  "slot_5": {
    // Same structure as slot_1
  }
}
```

### Simulation Module (Optional)

```json
"Simulation": {
  "status": "stopped",         // String: Simulation status (running/stopped)
  "timer_expired": false       // Boolean: Timer expiration flag
}
```

### State Module

```json
"State": {
  "Simulation": {              // Optional: Simulation-specific state
    "timer_expired": true
  },
  "alarms_cleared": false,     // Boolean: All alarms cleared flag
  "avg_flow_rate": 26.16431,   // Number: Current average flow rate
  "avg_temp": 27.94433,        // Number: Current average temperature
  "flow": 26.23536,            // Number: Current flow rate
  "flow_rate": 11.48,          // Number: Alternative flow rate reading (optional)
  "freq_lock": false,          // Boolean: Frequency lock status
  "num_passes": 3.739647,      // Number: Current number of passes
  "params_valid": true,        // Boolean: Parameters validation status
  "pressure": 59.56364,        // Number: Current pressure reading
  "pump_status": false,        // Boolean: Pump operational status
  "run_hours": 0,              // Integer: Current run hours
  "run_minutes": 14,           // Integer: Current run minutes
  "run_seconds": 849,          // Integer: Current run seconds
  "state": 1,                  // Integer: System state code
  "temperature": 29.8,         // Number: Current temperature reading
  "warming_up": true           // Boolean: Warming up phase flag
}
```

### Watchers Module

```json
"Watchers": {
  "[USER_ID]": true            // Boolean: User has access to watch this device
}
```

## Device Types

The system supports multiple device types:

- `CTESP32V2`: Standard ESP32 device version 2
- `CTESP32V2_PROD`: Production ESP32 device version 2
- `ESP32_REV_0`: ESP32 revision 0

## State Codes

System state codes indicate the current operational mode:

- `0`: Idle/Stopped
- `1`: Running/Active
- `2`: Warming up
- `4`: Error/Fault state

## Alarm Types

The system monitors these alarm conditions:

- `Flow alarm`: Flow rate outside acceptable range
- `Pressure alarm`: Pressure outside acceptable range
- `Temp alarm`: Temperature outside acceptable range
- `Freq lock alarm`: Frequency lock failure
- `Overload alarm`: System overload condition




    "SIMULATION-DEVICE-2": {
      "AlarmLogs": {
        "-OKhFeHFmti2Nq6DoJZl": {
          "cleared_time": 1741294849,
          "start_time": 1741294838,
          "type": "Flow alarm"
        },
        "-OKhFjCZAt6JwBERrSrN": {
          "cleared_time": 1741294869,
          "start_time": 1741294859,
          "type": "Pressure alarm"
        },
        "-OKhFo7MzFmg--f7LwZY": {
          "cleared_time": 1741294889,
          "start_time": 1741294879,
          "type": "Temp alarm"
        },
        "-OKhFtArP0uwdx3WYSTm": {
          "cleared_time": 1741294910,
          "start_time": 1741294899,
          "type": "Freq lock alarm"
        },
        "-OKhFyTi-Y3H9euo-8XW": {
          "cleared_time": 1741294932,
          "start_time": 1741294921,
          "type": "Overload alarm"
        }
      },
      "Alarms": {
        "flow_alarm": false,
        "flow_warn": false,
        "freq_lock_alarm": false,
        "ign_flow_alarm": 0,
        "ign_freqlock_alarm": 0,
        "ign_overload_alarm": false,
        "ign_pressure_alarm": 0,
        "ign_temp_alarm": 0,
        "overload_alarm": false,
        "pressure_alarm": false,
        "pressure_warn": false,
        "temp_alarm": false,
        "temp_warn": false
      },
      "CloudLogging": {
        "Spreadsheet": {
          "download_url": "<https://storage.googleapis.com/cannasoltech.firebasestorage.app/exports/SIMULATION-DEVICE-2/RunLogs_SIMULATION-DEVICE-2_1737591712.xlsx?X-Goog-Algorithm=GOOG4-RSA-SHA256&X-Goog-Credential=firebase-adminsdk-37xto%40cannasoltech.iam.gserviceaccount.com%2F20250123%2Fauto%2Fstorage%2Fgoog4_request&X-Goog-Date=20250123T002152Z&X-Goog-Expires=3600&X-Goog-SignedHeaders=host&X-Goog-Signature=0bc19f1a26f5c67e5f444d267b2cc4ef99d525aa21bfea655f26946c349dcebb2b41a00b3329e8314ee34beb1ee9367cb4f6f66318bc19603988648ddd4b037c6ecd0778803bb30e11ed395277fd860f1d91fcaa68dbca98f44d2803c58d07f962d04ffc8b871fde38f2aa4335851a4d11122d98fc5c7a5020b2186a289caee40459c4ddfca770baaa6b600a1cbff6ae002aefe01122d4525c141d40aef587949f9dd3bd19410ac62bc13350d0163b764e11287abb872547c690150844ce069d8362f3b91e7aebf57c4e71a967abc69efe4bbd4e157233442bb02d1fb51a23edf8349ac73c2279e39d23874b63b8b567fd9281322a454b754cafe0329fe8d05f>",
          "file_name": "RunLogs_SIMULATION-DEVICE-2_1737591712.xlsx",
          "time_stamp": "2025-01-23T00:21:52.944150+00:00"
        },
        "download_links": {
          "-OHFJ_362ORZQ2w4BO4B": {
            "downloadUrl": "<https://storage.googleapis.com/cannasoltech.firebasestorage.app/exports/SIMULATION-DEVICE-2/RunLogs_SIMULATION-DEVICE-2_1737588101.xlsx?X-Goog-Algorithm=GOOG4-RSA-SHA256&X-Goog-Credential=firebase-adminsdk-37xto%40cannasoltech.iam.gserviceaccount.com%2F20250122%2Fauto%2Fstorage%2Fgoog4_request&X-Goog-Date=20250122T232141Z&X-Goog-Expires=3600&X-Goog-SignedHeaders=host&X-Goog-Signature=1aa7f8afbf2d505753fdf79bdb8d82e15dc415a37b177bd25591bd07c0fde916a372cebec6872b12406c266496a0f33133c803f3d5052db9adb646b4610a2875c2260c532089998f76c4c50ba907608cb0b90b04cb546e953bb48c9f551e9d74d0277c4054eb0e6ca60b336fdc06dd9640e5f28f35692a67854717e11cdd19d1ea188148b2fa918df56435e61ede5066b3cede06c880614c4fdec06e76dd923cfa83e91f8203a6d2027c4aea81fb416eb285f2939c60aa820346df540116ed9dab0eb6e8e1f9f1950845a5195e5b7a792072b9554a246ac3969bb7635387d9d1a1b24880f7e4653b85d001388d763c42a5e3a7eba14cdf544532d7f3c002dfe6>",
            "fileName": "RunLogs_SIMULATION-DEVICE-2_1737588101.xlsx",
            "timestamp": "2025-01-22T23:21:41.352312+00:00"
          }
        },
        "export_history": false
      },
      "Config": {
        "abort_run": false,
        "batch_size": 22,
        "cool_down_temp": 10,
        "enable_cooldown": true,
        "end_run": false,
        "flow_thresh": 5.3,
        "load_slot": 0,
        "pressure_thresh": 43.6,
        "pump_control": true,
        "restart": false,
        "resume": false,
        "save_slot": 0,
        "set_hours": 1,
        "set_minutes": 0,
        "set_temp": 55,
        "start": false,
        "temp_thresh": 5.3
      },
      "CurrentRun": {
        "end_time": "N/A",
        "start_time": 1741294698,
        "start_user": "GdoDAfiqvPVgb3PN09FsFKYGlLF2"
      },
      "History": {
        "-OJuHS0_EtJ1F-r5Uw3c": {
          "alarm_logs": {
            "-OJuG8f8vfmZKutxybg-": {
              "cleared_time": 1740439339,
              "start_time": 1740439329,
              "type": "Flow alarm"
            },
            "-OJuGDZyldnGGvNwSlVw": {
              "cleared_time": 1740439359,
              "start_time": 1740439349,
              "type": "Pressure alarm"
            },
            "-OJuGIV79uFgd71umHW1": {
              "cleared_time": 1740439379,
              "start_time": 1740439369,
              "type": "Temp alarm"
            },
            "-OJuGNcU7v2jJBPRXWZt": {
              "cleared_time": 1740439400,
              "start_time": 1740439390,
              "type": "Freq lock alarm"
            },
            "-OJuGSnPjrsJFZB6pe65": {
              "cleared_time": 1740439423,
              "start_time": 1740439411,
              "type": "Overload alarm"
            }
          },
          "avg_flow_rate": 7.868838465592858,
          "avg_temp": 17.96606230547815,
          "end_time": 1740439670,
          "num_passes": 0.35932721712538224,
          "run_hours": 0,
          "run_minutes": 4,
          "run_seconds": 1,
          "start_time": 1740439203,
          "start_user": "GdoDAfiqvPVgb3PN09FsFKYGlLF2",
          "system_config": {
            "batch_size": 10.9,
            "cool_down_temp": 10,
            "enable_cooldown": true,
            "flow_thresh": 5.3,
            "pressure_thresh": 43.6,
            "set_hours": 0,
            "set_minutes": 4,
            "set_temp": 25.7
          }
        },
        "-OJyO8aiXCEzKJIEWkDp": {
          "avg_flow_rate": 7.488515889915601,
          "avg_temp": 23.1062107726215,
          "end_time": 1740508534,
          "num_passes": 0.04393939393939394,
          "run_hours": 0,
          "run_minutes": 1,
          "run_seconds": 2,
          "start_time": 1740508387,
          "start_user": "GdoDAfiqvPVgb3PN09FsFKYGlLF2",
          "system_config": {
            "batch_size": 22,
            "cool_down_temp": 10,
            "enable_cooldown": true,
            "flow_thresh": 5.3,
            "pressure_thresh": 43.6,
            "set_hours": 1,
            "set_minutes": 0,
            "set_temp": 55
          }
        }
      },
      "Info": {
        "id": "SIMULATION-DEVICE-2",
        "name": "Test Device 2",
        "status": "ONLINE",
        "type": "ESP32_REV_0"
      },
      "SaveSlots": {
        "slot_1": {
          "batch_size": 20,
          "cool_down_temp": 0,
          "enable_cooldown": 0,
          "hours": 0,
          "min_flow": 4,
          "min_pressure": 6,
          "minutes": 21,
          "set_temp": 25,
          "temp_var": 5
        },
        "slot_2": {
          "batch_size": 0,
          "cool_down_temp": 0,
          "enable_cooldown": 0,
          "hours": 0,
          "min_flow": 4,
          "min_pressure": 6,
          "minutes": 0,
          "set_temp": 0,
          "temp_var": 5
        },
        "slot_3": {
          "batch_size": 0,
          "cool_down_temp": 0,
          "enable_cooldown": 0,
          "hours": 0,
          "min_flow": 4,
          "min_pressure": 6,
          "minutes": 0,
          "set_temp": 0,
          "temp_var": 5
        },
        "slot_4": {
          "batch_size": 0,
          "cool_down_temp": 0,
          "enable_cooldown": 0,
          "hours": 0,
          "min_flow": 4,
          "min_pressure": 6,
          "minutes": 0,
          "set_temp": 0,
          "temp_var": 5
        },
        "slot_5": {
          "batch_size": 0,
          "cool_down_temp": 0,
          "enable_cooldown": 0,
          "hours": 0,
          "min_flow": 4,
          "min_pressure": 6,
          "minutes": 0,
          "set_temp": 0,
          "temp_var": 5
        }
      },
      "Simulation": {
        "alarm_active_time": 9,
        "alarm_count": 0,
        "alarm_start_time": 0,
        "alarming": false,
        "status": "running",
        "timer_expired": false,
        "total_alarm_time": 0,
        "warn_count": 0,
        "warn_start_time": 0,
        "warning": false
      },
      "State": {
        "alarms_cleared": true,
        "avg_flow_rate": 6.452194106035094,
        "avg_temp": 24.57104686139266,
        "flow": 10.17792536624654,
        "flow_rate": 7.640253882672756,
        "freq_lock": false,
        "num_passes": 0.10681818181818183,
        "params_valid": true,
        "pressure": 48.4735266359248,
        "pump_status": false,
        "run_hours": 0,
        "run_minutes": 2,
        "run_seconds": 23,
        "state": 3,
        "temperature": 55.19674473223186,
        "warming_up": false
      },
      "Watchers": {
        "GdoDAfiqvPVgb3PN09FsFKYGlLF2": true,
        "p2TxU66e8nVO4py5GtGvT6EuCmt1": true
      }
    }
  },
  "users": {
    "3tlus5NLEHaUWPRsHJ8hshr17Oh2": {
      "does_accept_tac": true,
      "email": "<alterabeats@gmail.com>",
      "email_on_alarm": true,
      "name": "Stephen3",
      "selected_device": "None"
    },
    "74v9t4ipxKZXhdIhLD2V7eEuLRG3": {
      "does_accept_tac": true,
      "email": "<josh.detzel@cannasolusa.com>",
      "email_on_alarm": true,
      "name": "Josh",
      "selected_device": "35C9-B297-0575-5A53",
      "watched_devices": {
        "35C9-B297-0575-5A53": true,
        "454B-4E31-3237-0010": true,
        "SIMULATION-DEVICE-1": true,
        "SIMULATION-DEVICE-2": true
      }
    },
    "7JKHj9pplXP8S5LpRwlgo2VaQzo2": {
      "email": "<bbphst@aol.com>",
      "name": "Ryan",
      "selected_device": "454B-4E31-3237-0010",
      "watched_devices": {
        "454B-4E31-3237-0010": true
      }
    },
    "GdoDAfiqvPVgb3PN09FsFKYGlLF2": {
      "does_accept_tac": true,
      "email": "<s.boyett31@gmail.com>",
      "email_on_alarm": true,
      "name": "Stephen Boyett",
      "notification_tokens": {
        "106F7705-E2A0-42F2-B30E-9677474B2BA8": "fhHVI6M_-kKtoP8mQF3Yjy:APA91bF5NQ7rHbpfEFEELNZvDoH7IY_LYVb2jrMXQE1wMmAr-uKj4U2epPszuFxoTJElbgFde7YpvdpaPjQwNBTeBwblloPbpgglu6NcHWvU3TZj2_XUUYg"
      },
      "selected_device": "SIMULATION-DEVICE-1",
      "watched_devices": {
        "35C9-B297-0575-5A53": true,
        "D540-B217-1917-4853": true,
        "SIMULATION-DEVICE-1": true,
        "SIMULATION-DEVICE-2": true
      }
    },
    "bfRHfSpZ6fPi5ThpJST0xlFUl0J3": {
      "does_accept_tac": true,
      "email": "<aortyxofficial@gmail.com>",
      "name": "new user"
    },
    "p2TxU66e8nVO4py5GtGvT6EuCmt1": {
      "does_accept_tac": true,
      "email": "<cannasol.appletest@gmail.com>",
      "email_on_alarm": true,
      "name": "Apple Tester",
      "selected_device": "SIMULATION-DEVICE-2",
      "watched_devices": {
        "SIMULATION-DEVICE-2": true
      }
    },
    "xcEhHSpkbyQnZkthyhigPrmSUpg2": {
      "does_accept_tac": true,
      "email": "<ekyliep@gmail.com>",
      "email_on_alarm": false,
      "name": "Kylie Peebles",
      "selected_device": "SIMULATION-DEVICE-1",
      "watched_devices": {
        "SIMULATION-DEVICE": true,
        "SIMULATION-DEVICE-1": true
      }
    }
  }
}

```


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
