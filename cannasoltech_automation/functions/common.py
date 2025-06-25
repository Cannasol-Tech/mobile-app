from dataclasses import asdict, dataclass
from typing import List

@dataclass
class UserEntry:
    id: str
    name: str
    notification_tokens: List[str]
    email: str
    email_on_alarm: bool

@dataclass
class SystemRunLog:
    start_time: int
    end_time: int
    start_user: str
    system_config: dict
    alarm_logs: dict
    run_hours: int
    run_minutes: int
    run_seconds: int
    avg_flow_rate: float
    avg_temp: float 
    num_passes: float