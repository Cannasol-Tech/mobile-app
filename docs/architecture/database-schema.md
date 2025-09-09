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

    "B5C5-8C17-178D-5A53": {
      "Alarms": {
        "flow_alarm": false,
        "flow_warn": false,
        "freq_lock_alarm": false,
        "ign_flow_alarm": true,
        "ign_freqlock_alarm": 0,
        "ign_overload_alarm": 0,
        "ign_pressure_alarm": 0,
        "ign_temp_alarm": 0,
        "overload_alarm": false,
        "pressure_alarm": true,
        "pressure_warn": false,
        "temp_alarm": true,
        "temp_warn": false
      },
      "Config": {
        "abort_run": 0,
        "batch_size": 0,
        "cool_down_temp": 45,
        "enable_cooldown": 0,
        "end_run": 0,
        "flow_thresh": 0,
        "load_slot": 0,
        "pressure_thresh": 0,
        "pump_control": 0,
        "restart": 0,
        "resume": 0,
        "save_slot": 0,
        "set_hours": 0,
        "set_minutes": 0,
        "set_temp": 4,
        "start": 0,
        "temp_thresh": 24.34000015
      },
      "Info": {
        "id": "B5C5-8C17-178D-5A53",
        "name": "newsystemname",
        "status": "ONLINE",
        "type": "ESP32_REV_0"
      },
      "SaveSlots": {
        "slot_1": {
          "batch_size": 0,
          "cool_down_temp": 50,
          "enable_cooldown": 0,
          "hours": 0,
          "min_flow": 4.400000095,
          "min_pressure": 5.525000095,
          "minutes": 0,
          "set_temp": 0,
          "temp_var": 9.800000191
        },
        "slot_2": {
          "batch_size": 0,
          "cool_down_temp": 50,
          "enable_cooldown": 0,
          "hours": 0,
          "min_flow": 4.400000095,
          "min_pressure": 5.525000095,
          "minutes": 0,
          "set_temp": 0,
          "temp_var": 9.800000191
        },
        "slot_3": {
          "batch_size": 0,
          "cool_down_temp": 50,
          "enable_cooldown": 0,
          "hours": 0,
          "min_flow": 4.400000095,
          "min_pressure": 5.525000095,
          "minutes": 0,
          "set_temp": 0,
          "temp_var": 9.800000191
        },
        "slot_4": {
          "batch_size": 0,
          "cool_down_temp": 45,
          "enable_cooldown": 0,
          "hours": 0,
          "min_flow": 0,
          "min_pressure": 0,
          "minutes": 0,
          "set_temp": 0,
          "temp_var": 9.699999809
        },
        "slot_5": {
          "batch_size": 0,
          "cool_down_temp": 45,
          "enable_cooldown": 0,
          "hours": 0,
          "min_flow": 0,
          "min_pressure": 0,
          "minutes": 0,
          "set_temp": 0,
          "temp_var": 9.699999809
        }
      },
      "State": {
        "alarms_cleared": false,
        "avg_flow_rate": 0,
        "avg_temp": 0,
        "flow": 0,
        "freq_lock": true,
        "num_passes": 0,
        "params_valid": false,
        "pressure": 0,
        "pump_status": false,
        "run_hours": 0,
        "run_minutes": 0,
        "run_seconds": 0,
        "state": 4,
        "temperature": 0,
        "warming_up": false
      }
    },
    "D540-B217-1917-4853": {
      "Alarms": {
        "flow_alarm": false,
        "flow_warn": false,
        "freq_lock_alarm": false,
        "ign_flow_alarm": false,
        "ign_freqlock_alarm": false,
        "ign_overload_alarm": false,
        "ign_pressure_alarm": false,
        "ign_temp_alarm": false,
        "overload_alarm": false,
        "pressure_alarm": false,
        "pressure_warn": false,
        "temp_alarm": false,
        "temp_warn": false
      },
      "CloudLogging": {
        "export_history": false
      },
      "Config": {
        "abort_run": false,
        "batch_size": 0,
        "cool_down_temp": 45,
        "enable_cooldown": false,
        "end_run": false,
        "flow_thresh": 15,
        "load_slot": 0,
        "pressure_thresh": 49,
        "pump_control": false,
        "restart": false,
        "resume": false,
        "save_slot": 0,
        "set_hours": 0,
        "set_minutes": 0,
        "set_temp": 0,
        "start": false,
        "temp_thresh": 5
      },
      "History": {
        "-OTZZw-RkDOsCTH1SXFG": {
          "alarm_logs": {
            "-OT-uIrFCHADoAo9ZA98": {
              "cleared_time": 1750216272,
              "start_time": 1750214458,
              "type": "Freq lock alarm"
            },
            "-OT-ur7NF0r1hK3SoJuG": {
              "cleared_time": 1750290648,
              "start_time": 1750214603,
              "type": "Pressure alarm"
            },
            "-OT-urY-Op6K-R2-GTA_": {
              "cleared_time": 1750290649,
              "start_time": 1750214604,
              "type": "Overload alarm"
            },
            "-OT00E5vqmLPIpPeWJSO": {
              "cleared_time": 1750216280,
              "start_time": 1750216274,
              "type": "Freq lock alarm"
            },
            "-OT00IqHli0gRUbf8Sbm": {
              "cleared_time": 1750217035,
              "start_time": 1750216293,
              "type": "Freq lock alarm"
            },
            "-OT01DyjS0VYEpr_1OJ4": {
              "cleared_time": 1750216982,
              "start_time": 1750216535,
              "type": "Flow alarm"
            },
            "-OT038qlKpiRMcfdxN03": {
              "cleared_time": 1750290649,
              "start_time": 1750217039,
              "type": "Freq lock alarm"
            },
            "-OT0QHjO5Fkr0VH4tIPD": {
              "cleared_time": 1750223111,
              "start_time": 1750223104,
              "type": "Flow alarm"
            },
            "-OT0SAN84lgUXxMkQkHb": {
              "cleared_time": 1750290648,
              "start_time": 1750223599,
              "type": "Flow alarm"
            },
            "-OT4iyYEa5Jwb10YS0Hv": {
              "cleared_time": 1750295381,
              "start_time": 1750295374,
              "type": "Flow alarm"
            },
            "-OTBC-di8U6aeLStmd1-": {
              "cleared_time": 1750405274,
              "start_time": 1750403910,
              "type": "Freq lock alarm"
            },
            "-OTZZJqzrIi3vHj5pBQR": {
              "cleared_time": 1750812693,
              "start_time": 1750812675,
              "type": "Flow alarm"
            },
            "-OTZZKFq9vkMNk8IDJCc": {
              "cleared_time": 1750812696,
              "start_time": 1750812677,
              "type": "Pressure alarm"
            },
            "-OTZZuWzrlHU-ZeeJ3bB": {
              "cleared_time": 1750812834,
              "start_time": 1750812829,
              "type": "Flow alarm"
            },
            "-OTZZvJNsC9iK8cnqAAC": {
              "cleared_time": 1750812834,
              "start_time": 1750812833,
              "type": "Pressure alarm"
            },
            "-OTZZvJsm9cdahbDq8nh": {
              "cleared_time": 1750812834,
              "start_time": 1750812833,
              "type": "Temp alarm"
            }
          },
          "avg_flow_rate": 0,
          "avg_temp": 0,
          "end_time": 1750812835,
          "num_passes": 0,
          "run_hours": 0,
          "run_minutes": 2,
          "run_seconds": 165,
          "system_config": {
            "batch_size": 0,
            "cool_down_temp": 0,
            "enable_cooldown": false,
            "flow_thresh": 0,
            "pressure_thresh": 0,
            "set_hours": 1,
            "set_minutes": 0,
            "set_temp": 0
          }
        },
        "-OTeGh_0FxeS_IwV55sg": {
          "alarm_logs": {
            "-OTeG_332xs2nZfd1zDb": {
              "cleared_time": 1750908437,
              "start_time": 1750908424,
              "type": "Flow alarm"
            },
            "-OTeG_38GpiTjvCS3-u1": {
              "cleared_time": 1750908425,
              "start_time": 1750908424,
              "type": "Freq lock alarm"
            },
            "-OTeG_39PJRmsvvSe_L1": {
              "cleared_time": 1750908437,
              "start_time": 1750908424,
              "type": "Pressure alarm"
            },
            "-OTeGfSqzWYjsfKjdkiN": {
              "cleared_time": 1750908452,
              "start_time": 1750908450,
              "type": "Freq lock alarm"
            }
          },
          "avg_flow_rate": 0,
          "avg_temp": 0,
          "end_time": 1750908458,
          "num_passes": 0,
          "run_hours": 0,
          "run_minutes": 0,
          "run_seconds": 12,
          "start_time": 1750908411,
          "start_user": "GdoDAfiqvPVgb3PN09FsFKYGlLF2",
          "system_config": {
            "batch_size": 696.9,
            "cool_down_temp": 45,
            "enable_cooldown": false,
            "flow_thresh": 7.6,
            "pressure_thresh": 8.7,
            "set_hours": 1,
            "set_minutes": 9,
            "set_temp": 26
          }
        },
        "-OUhAe7HrNHFGZSmQidg": {
          "avg_flow_rate": 30.6,
          "avg_temp": 26.24,
          "end_time": 1752030945,
          "num_passes": 0.06,
          "run_hours": 0,
          "run_minutes": 1,
          "run_seconds": 82,
          "start_time": 1752030716,
          "start_user": "GdoDAfiqvPVgb3PN09FsFKYGlLF2",
          "system_config": {
            "batch_size": 690,
            "cool_down_temp": 45,
            "enable_cooldown": true,
            "flow_thresh": 15,
            "pressure_thresh": 49,
            "set_hours": 0,
            "set_minutes": 30,
            "set_temp": 69
          }
        },
        "-OUhCgtXvgonf-lA9e1x": {
          "alarm_logs": {
            "-OUhBwBiabFksYJleNmi": {
              "cleared_time": 1752031289,
              "start_time": 1752031281,
              "type": "Overload alarm"
            }
          },
          "avg_flow_rate": 30.17,
          "avg_temp": 26.08,
          "end_time": 1752031480,
          "num_passes": 0.06,
          "run_hours": 0,
          "run_minutes": 0,
          "run_seconds": 57,
          "start_user": "GdoDAfiqvPVgb3PN09FsFKYGlLF2",
          "system_config": {
            "batch_size": 450,
            "cool_down_temp": 45,
            "enable_cooldown": true,
            "flow_thresh": 15,
            "pressure_thresh": 49,
            "set_hours": 1,
            "set_minutes": 9,
            "set_temp": 27
          }
        },
        "-OUhHOOLeCPX08GxRvIy": {
          "alarm_logs": {
            "-OUhHBrhNWumQDyLGZMS": {
              "cleared_time": 1752032669,
              "start_time": 1752032660,
              "type": "Overload alarm"
            }
          },
          "avg_flow_rate": 29.48,
          "avg_temp": 27.64,
          "end_time": 1752032711,
          "num_passes": 0.03,
          "run_hours": 0,
          "run_minutes": 10,
          "run_seconds": 20,
          "start_time": 1752032656,
          "start_user": "GdoDAfiqvPVgb3PN09FsFKYGlLF2",
          "system_config": {
            "batch_size": 400,
            "cool_down_temp": 45,
            "enable_cooldown": false,
            "flow_thresh": 15,
            "pressure_thresh": 49,
            "set_hours": 0,
            "set_minutes": 25,
            "set_temp": 35
          }
        },
        "-OUhNxwVAsJQhTk6gzvU": {
          "alarm_logs": {
            "-OUhLIbKOh5jDEsSZq7P": {
              "cleared_time": 1752033748,
              "start_time": 1752033737,
              "type": "Overload alarm"
            }
          },
          "avg_flow_rate": 30.86,
          "avg_temp": 29.26,
          "end_time": 1752034434,
          "num_passes": 0.49,
          "run_hours": 0,
          "run_minutes": 10,
          "run_seconds": 658,
          "start_time": 1752033711,
          "start_user": "GdoDAfiqvPVgb3PN09FsFKYGlLF2",
          "system_config": {
            "batch_size": 696.9,
            "cool_down_temp": 27,
            "enable_cooldown": false,
            "flow_thresh": 15,
            "pressure_thresh": 49,
            "set_hours": 0,
            "set_minutes": 11,
            "set_temp": 30
          }
        },
        "-OUhPlbt2CCtC_d9LvpU": {
          "alarm_logs": {
            "-OUhPcjt-U_IlHyyjJAY": {
              "cleared_time": 1752034881,
              "start_time": 1752034872,
              "type": "Overload alarm"
            }
          },
          "avg_flow_rate": 30.94,
          "avg_temp": 29.32,
          "end_time": 1752034908,
          "num_passes": 0,
          "run_hours": 0,
          "run_minutes": 0,
          "run_seconds": 6,
          "start_time": 1752034867,
          "start_user": "GdoDAfiqvPVgb3PN09FsFKYGlLF2",
          "system_config": {
            "batch_size": 696.9,
            "cool_down_temp": 32,
            "enable_cooldown": false,
            "flow_thresh": 15,
            "pressure_thresh": 49,
            "set_hours": 0,
            "set_minutes": 30,
            "set_temp": 32
          }
        }
      },
      "Info": {
        "id": "D540-B217-1917-4853",
        "name": "DEVICE~70",
        "status": "ONLINE",
        "type": "CTESP32V2"
      },
      "SaveSlots": {
        "slot_1": {
          "batch_size": 600,
          "cool_down_temp": 69,
          "enable_cooldown": false,
          "hours": 2,
          "min_flow": 4,
          "min_pressure": 8,
          "minutes": 15,
          "set_temp": 40,
          "temp_var": 4.7
        },
        "slot_2": {
          "batch_size": 6.9,
          "cool_down_temp": 6.9,
          "enable_cooldown": true,
          "hours": 6,
          "min_flow": 6.9,
          "min_pressure": 6.9,
          "minutes": 9,
          "set_temp": 6.9,
          "temp_var": 6.9
        },
        "slot_3": {
          "batch_size": 600,
          "cool_down_temp": 69,
          "enable_cooldown": false,
          "hours": 2,
          "min_flow": 4,
          "min_pressure": 8,
          "minutes": 15,
          "set_temp": 40,
          "temp_var": 4.7
        },
        "slot_4": {
          "batch_size": 6.9,
          "cool_down_temp": 6.9,
          "enable_cooldown": true,
          "hours": 6,
          "min_flow": 6.9,
          "min_pressure": 6.9,
          "minutes": 9,
          "set_temp": 6.9,
          "temp_var": 6.9
        },
        "slot_5": {
          "batch_size": 6.9,
          "cool_down_temp": 6.9,
          "enable_cooldown": true,
          "hours": 6,
          "min_flow": 6.9,
          "min_pressure": 6.9,
          "minutes": 9,
          "set_temp": 6.9,
          "temp_var": 6.9
        }
      },
      "State": {
        "alarms_cleared": false,
        "avg_flow_rate": 0,
        "avg_temp": 0,
        "flow": 0,
        "freq_lock": true,
        "num_passes": 0,
        "params_valid": false,
        "pressure": 0,
        "pump_status": false,
        "run_hours": 0,
        "run_minutes": 0,
        "run_seconds": 0,
        "state": 0,
        "temperature": 0,
        "warming_up": false
      },
      "Watchers": {
        "GdoDAfiqvPVgb3PN09FsFKYGlLF2": true
      }
    },
    "ON-TARGET-TEST-DEVICE": {
      "AlarmLogs": {
        "-OIJuKifOl0koTK2AvEP": {
          "cleared_time": 1738738860,
          "start_time": 1738738850,
          "type": "Flow alarm"
        },
        "-OIJuPcIWUqDGjDvlrpW": {
          "cleared_time": 1738738880,
          "start_time": 1738738870,
          "type": "Pressure alarm"
        },
        "-OIJuUgg2eXhLzeaAriA": {
          "cleared_time": 1738738901,
          "start_time": 1738738891,
          "type": "Temp alarm"
        },
        "-OIJuZUqcTYblrHp1_jb": {
          "cleared_time": 1738738921,
          "start_time": 1738738911,
          "type": "Freq lock alarm"
        },
        "-OIJudfKosE4sTDmdYUg": {
          "cleared_time": 1738738943,
          "start_time": 1738738932,
          "type": "Overload alarm"
        },
        "-OTSj8JW2PTR3X_gsvaP": {
          "cleared_time": 0,
          "start_time": 1750698071,
          "type": "Freq lock alarm"
        },
        "-OTSj8JYHqmn0z4iaZWb": {
          "cleared_time": 0,
          "start_time": 1750698071,
          "type": "Pressure alarm"
        },
        "-OTSj8YxVGIXO0G2cJUC": {
          "cleared_time": 0,
          "start_time": 1750698072,
          "type": "Temp alarm"
        }
      },
      "Alarms": {
        "flow_alarm": false,
        "flow_warn": true,
        "freq_lock_alarm": true,
        "ign_flow_alarm": true,
        "ign_freqlock_alarm": false,
        "ign_overload_alarm": true,
        "ign_pressure_alarm": false,
        "ign_temp_alarm": false,
        "overload_alarm": false,
        "pressure_alarm": true,
        "pressure_warn": true,
        "temp_alarm": true,
        "temp_warn": false
      },
      "CloudLogging": {
        "export_history": false
      },
      "Config": {
        "abort_run": false,
        "batch_size": 50,
        "cool_down_temp": 25,
        "enable_cooldown": true,
        "end_run": false,
        "flow_thresh": 10,
        "load_slot": 2,
        "pressure_thresh": 15,
        "pump_control": false,
        "restart": true,
        "resume": true,
        "save_slot": 1,
        "set_hours": 10,
        "set_minutes": 30,
        "set_temp": 23.5,
        "start": true,
        "temp_thresh": 2.5
      },
      "CurrentRun": {
        "end_time": "N/A",
        "start_time": 1750691821,
        "start_user": "None"
      },
      "History": {
        "-OHL3ef8ZSwCrBw1XwdJ": {
          "avg_flow_rate": 6.80450885312056,
          "avg_temp": 16.22938094801517,
          "end_time": 1737684592,
          "num_passes": 0.0008834216755008834,
          "run_hours": 0,
          "run_minutes": 0,
          "run_seconds": 58,
          "start_time": 1737684496,
          "start_user": "None",
          "system_config": {
            "batch_size": 999.9,
            "cool_down_temp": 10,
            "enable_cooldown": true,
            "flow_thresh": 5,
            "pressure_thresh": 26,
            "set_hours": 0,
            "set_minutes": 6,
            "set_temp": 28
          }
        },
        "-OIJv_UhcmtqfyTPQiMW": {
          "alarm_logs": {
            "-OIJuKifOl0koTK2AvEP": {
              "cleared_time": 1738738860,
              "start_time": 1738738850,
              "type": "Flow alarm"
            },
            "-OIJuPcIWUqDGjDvlrpW": {
              "cleared_time": 1738738880,
              "start_time": 1738738870,
              "type": "Pressure alarm"
            },
            "-OIJuUgg2eXhLzeaAriA": {
              "cleared_time": 1738738901,
              "start_time": 1738738891,
              "type": "Temp alarm"
            },
            "-OIJuZUqcTYblrHp1_jb": {
              "cleared_time": 1738738921,
              "start_time": 1738738911,
              "type": "Freq lock alarm"
            },
            "-OIJudfKosE4sTDmdYUg": {
              "cleared_time": 1738738943,
              "start_time": 1738738932,
              "type": "Overload alarm"
            }
          },
          "avg_flow_rate": 6.115802952805361,
          "avg_temp": 18.239891604237826,
          "end_time": 1738739177,
          "num_passes": 0.005917258392505917,
          "run_hours": 0,
          "run_minutes": 6,
          "run_seconds": 1,
          "start_time": 1738738715,
          "start_user": "None",
          "system_config": {
            "batch_size": 999.9,
            "cool_down_temp": 10,
            "enable_cooldown": true,
            "flow_thresh": 5,
            "pressure_thresh": 26,
            "set_hours": 0,
            "set_minutes": 6,
            "set_temp": 28
          }
        }
      },
      "Info": {
        "id": "ESP32_PROD_001",
        "name": "Production ESP32 Device",
        "status": "ONLINE",
        "type": "CTESP32V2_PROD"
      },
      "SaveSlots": {
        "slot_1": {
          "batch_size": 25,
          "cool_down_temp": 10,
          "enable_cooldown": true,
          "hours": 0,
          "min_flow": 7,
          "min_pressure": 20,
          "minutes": 3,
          "set_temp": 25,
          "temp_var": 5
        },
        "slot_2": {
          "batch_size": 25,
          "cool_down_temp": 10,
          "enable_cooldown": true,
          "hours": 0,
          "min_flow": 7,
          "min_pressure": 20,
          "minutes": 9,
          "set_temp": 25,
          "temp_var": 5
        },
        "slot_3": {
          "batch_size": 20,
          "cool_down_temp": 10,
          "enable_cooldown": true,
          "hours": 0,
          "min_flow": 4,
          "min_pressure": 6,
          "minutes": 20,
          "set_temp": 25,
          "temp_var": 5
        },
        "slot_4": {
          "batch_size": 20,
          "cool_down_temp": 10,
          "enable_cooldown": true,
          "hours": 0,
          "min_flow": 4,
          "min_pressure": 6,
          "minutes": 20,
          "set_temp": 25,
          "temp_var": 5
        },
        "slot_5": {
          "batch_size": 20,
          "cool_down_temp": 10,
          "enable_cooldown": true,
          "hours": 0,
          "min_flow": 4,
          "min_pressure": 6,
          "minutes": 20,
          "set_temp": 25,
          "temp_var": 5
        }
      },
      "Simulation": {
        "status": "stopped",
        "timer_expired": false
      },
      "State": {
        "alarms_cleared": true,
        "avg_flow_rate": 25.1,
        "avg_temp": 29.2,
        "flow": 24.3,
        "freq_lock": false,
        "num_passes": 142.7,
        "params_valid": false,
        "pressure": 67.8,
        "pump_status": true,
        "run_hours": 3,
        "run_minutes": 12,
        "run_seconds": 45,
        "state": 1,
        "temperature": 28.5,
        "warming_up": true
      },
      "Watchers": {
        "74v9t4ipxKZXhdIhLD2V7eEuLRG3": true,
        "GdoDAfiqvPVgb3PN09FsFKYGlLF2": true,
        "xcEhHSpkbyQnZkthyhigPrmSUpg2": true
      }
    },
    "SIMULATION-DEVICE-1": {
      "Alarms": {
        "flow_alarm": false,
        "flow_warn": false,
        "freq_lock_alarm": false,
        "ign_flow_alarm": false,
        "ign_freqlock_alarm": false,
        "ign_overload_alarm": false,
        "ign_pressure_alarm": false,
        "ign_temp_alarm": false,
        "overload_alarm": false,
        "pressure_alarm": false,
        "pressure_warn": false,
        "temp_alarm": false,
        "temp_warn": false
      },
      "CloudLogging": {
        "export_history": false
      },
      "Config": {
        "abort_run": false,
        "batch_size": 111,
        "cool_down_temp": 10,
        "enable_cooldown": true,
        "end_run": false,
        "flow_thresh": 5,
        "load_slot": 0,
        "pressure_thresh": 26,
        "pump_control": true,
        "restart": false,
        "resume": false,
        "save_slot": 0,
        "set_hours": 0,
        "set_minutes": 6,
        "set_temp": 37,
        "start": false,
        "temp_thresh": 5
      },
      "CurrentRun": {
        "end_time": "N/A",
        "start_time": 1756848682,
        "start_user": "GdoDAfiqvPVgb3PN09FsFKYGlLF2"
      },
      "History": {
        "-OHL3ef8ZSwCrBw1XwdJ": {
          "avg_flow_rate": 6.80450885312056,
          "avg_temp": 16.22938094801517,
          "end_time": 1737684592,
          "num_passes": 0.0008834216755008834,
          "run_hours": 0,
          "run_minutes": 0,
          "run_seconds": 58,
          "start_time": 1737684496,
          "start_user": "None",
          "system_config": {
            "batch_size": 999.9,
            "cool_down_temp": 10,
            "enable_cooldown": true,
            "flow_thresh": 5,
            "pressure_thresh": 26,
            "set_hours": 0,
            "set_minutes": 6,
            "set_temp": 28
          }
        },
        "-OIJv_UhcmtqfyTPQiMW": {
          "alarm_logs": {
            "-OIJuKifOl0koTK2AvEP": {
              "cleared_time": 1738738860,
              "start_time": 1738738850,
              "type": "Flow alarm"
            },
            "-OIJuPcIWUqDGjDvlrpW": {
              "cleared_time": 1738738880,
              "start_time": 1738738870,
              "type": "Pressure alarm"
            },
            "-OIJuUgg2eXhLzeaAriA": {
              "cleared_time": 1738738901,
              "start_time": 1738738891,
              "type": "Temp alarm"
            },
            "-OIJuZUqcTYblrHp1_jb": {
              "cleared_time": 1738738921,
              "start_time": 1738738911,
              "type": "Freq lock alarm"
            },
            "-OIJudfKosE4sTDmdYUg": {
              "cleared_time": 1738738943,
              "start_time": 1738738932,
              "type": "Overload alarm"
            }
          },
          "avg_flow_rate": 6.115802952805361,
          "avg_temp": 18.239891604237826,
          "end_time": 1738739177,
          "num_passes": 0.005917258392505917,
          "run_hours": 0,
          "run_minutes": 6,
          "run_seconds": 1,
          "start_time": 1738738715,
          "start_user": "None",
          "system_config": {
            "batch_size": 999.9,
            "cool_down_temp": 10,
            "enable_cooldown": true,
            "flow_thresh": 5,
            "pressure_thresh": 26,
            "set_hours": 0,
            "set_minutes": 6,
            "set_temp": 28
          }
        }
      },
      "Info": {
        "id": "SIMULATION-DEVICE-1",
        "name": "Test Device 1",
        "status": "ONLINE",
        "type": "ESP32_REV_0"
      },
      "SaveSlots": {
        "slot_1": {
          "batch_size": 25,
          "cool_down_temp": 10,
          "enable_cooldown": true,
          "hours": 0,
          "min_flow": 7,
          "min_pressure": 20,
          "minutes": 3,
          "set_temp": 25,
          "temp_var": 5
        },
        "slot_2": {
          "batch_size": 25,
          "cool_down_temp": 10,
          "enable_cooldown": true,
          "hours": 0,
          "min_flow": 7,
          "min_pressure": 20,
          "minutes": 9,
          "set_temp": 25,
          "temp_var": 5
        },
        "slot_3": {
          "batch_size": 20,
          "cool_down_temp": 10,
          "enable_cooldown": true,
          "hours": 0,
          "min_flow": 4,
          "min_pressure": 6,
          "minutes": 20,
          "set_temp": 25,
          "temp_var": 5
        },
        "slot_4": {
          "batch_size": 20,
          "cool_down_temp": 10,
          "enable_cooldown": true,
          "hours": 0,
          "min_flow": 4,
          "min_pressure": 6,
          "minutes": 20,
          "set_temp": 25,
          "temp_var": 5
        },
        "slot_5": {
          "batch_size": 20,
          "cool_down_temp": 10,
          "enable_cooldown": true,
          "hours": 0,
          "min_flow": 4,
          "min_pressure": 6,
          "minutes": 20,
          "set_temp": 25,
          "temp_var": 5
        }
      },
      "Simulation": {
        "status": "running",
        "timer_expired": false
      },
      "State": {
        "Simulation": {
          "timer_expired": true
        },
        "alarms_cleared": true,
        "avg_flow_rate": 0,
        "avg_temp": 0,
        "flow": 8.049627288355726,
        "flow_rate": 11.482063703870649,
        "freq_lock": false,
        "num_passes": 0,
        "params_valid": true,
        "pressure": 30.08301970229317,
        "pump_status": false,
        "run_hours": 0,
        "run_minutes": 0,
        "run_seconds": 0,
        "state": 2,
        "temperature": 37.491558066745974,
        "warming_up": false
      },
      "Watchers": {
        "74v9t4ipxKZXhdIhLD2V7eEuLRG3": true,
        "GdoDAfiqvPVgb3PN09FsFKYGlLF2": true,
        "xcEhHSpkbyQnZkthyhigPrmSUpg2": true
      }
    },
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
