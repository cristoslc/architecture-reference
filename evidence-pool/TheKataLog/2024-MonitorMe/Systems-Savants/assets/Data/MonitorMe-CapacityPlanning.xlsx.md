## DataCapacityPlan-Writes

| |  |  |  |  |  |  |  |  | 
| | --- | --- | --- | --- | --- | --- | --- | --- | 
| |  | MonitorMe Sytem Storage Capacity Planning |  |  |  |  |  |  | 
| |  |  |  |  |  |  |  |  | 
| |  | Inputs/Config |  |  |  |  |  |  | 
| |  | Num Instances | 1 |  |  |  |  |  | 
| |  | NumPatients | 500 |  |  |  |  |  | 
| |  | Num Stations | 25 |  |  |  |  |  | 
| |  | NumDevices | 8 |  |  |  |  |  | 
| |  |  |  |  |  |  |  |  | 
| |  |  |  | Est. rate of event writes/captures from devices |  |  |  |  | 
| |  | Vitals | Rate | Per Sec | Per Min | Per Hr | Per Day (24h) |  | 
| |  | HeartRate | 500ms | 2 | 120 | 7200 | 172800 |  | 
| |  | Blood Pressure | 1hr | - | - | 1 | 24 |  | 
| |  | Oxygen Level | 5s | - | 12 | 720 | 17280 |  | 
| |  | Blood Sugar | 2 min | - | - | 30 | 720 |  | 
| |  | Respiration | 1s | 1 | 60 | 3600 | 86400 |  | 
| |  | ECG | 1s | 1 | 60 | 3600 | 86400 |  | 
| |  | Body Temperature | 5min | - | - | 12 | 288 |  | 
| |  | Sleep Status | 2min | - | - | 30 | 720 |  | 
| |  | Events Per Patient |  |  | 253.21666666666667 | 15193 | 364632 |  | 
| |  |  |  |  |  |  |  |  | 
| |  | # Vital Events (24hrs) | 182316000 | Events |  |  |  |  | 
| |  | # Vital Events Per Station (24hrs) | 3646320000 | Events |  |  |  |  | 
| |  |  |  |  |  |  |  |  | 
| |  | Est. Storage per event | 1 | KB | Input/Config |  |  |  | 
| |  | Required Storage (KB) | 182316000 | KB |  |  |  |  | 
| |  | Required Storage (MB) | 178042.96875 | MB |  |  |  |  | 
| |  | Required Storage (GB) | 173.87008666992188 | GB |  |  |  |  | 
| |  | Required Storage (TB) | 0.16979500651359558 | TB | *Event storage |  |  |  | 
| |  | Est. Misc. Storage (GB) | 0.042448751628398895 | TB | *Other operational storage @ 25% of required storage. |  |  |  | 
| |  | Daily Required Storage (GB) | 217.33760833740234 | GB |  |  |  |  | 
| |  | Daily Required Storage (TB) | 0.21224375814199448 | TB |  |  |  |  | 
