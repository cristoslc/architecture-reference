# Data Amount Calculations

As we need to find a suitable solution we also need to consider the amount of data we need to handle.  


## Known Metrics

- Multiple Nurse Station
- 8 Vital Sign Devices per Patient
- up to 20 Patients per station

## Assumptions

- We assume 160 Bytes of data per data point on average

## Device Specifics

- Heart Rate: every 500ms
- Blood Pressure: every 60 minutes
- Oxygen Level: every 5 seconds
- Blood Sugar: every 2 minutes
- Respiration: every second
- Electrocardiogram: every second
- Body Temperature: every 5 minutes
- Sleep Status: every 2 minutes

*New devices to be added in the future* 


## Calculations

| Device              	    | Frequency 	| Data Points (24h) 	 | Size (Bytes)  	     |
|--------------------------|-----------	|---------------------|---------------------|
| Heart Rate          	    | 500ms     	| 172800           	  | 27648000      	     |
| Blood Pressure      	    | 60min     	| 24               	  | 3840          	     |
| Oxygen level        	    | 5s        	| 17280            	  | 2764800       	     |
| Blood sugar         	    | 2min      	| 720              	  | 115200        	     |
| Respiration         	    | 1s        	| 86400            	  | 13824000      	     |
| ECG                 	    | 1s        	| 86400            	  | 13824000      	     |
| Body temperature    	    | 5min      	| 288              	  | 46080         	     |
| Sleep status        	    | 2min      	| 720              	  | 115200        	     |
| Total (per Patient) 	    |           	| 	                   | 58.341.120    	     |
| Total (per Station) 	    |           	| 	                   | **1.166.822.400** 	 |

If a station is completely filled, the do have a maximum of 1.166.822.400 Bytes (~1.09 GB) per day and station that needs to be processed.
As we only need to process this for a timeframe of 24 hrs for short term analysis, we will design the system around that.


---
[> Home](../README.md)    [>  Problem Background](README.md)
[< Prev](Requirements.md)  |  [Next >](StakeholderConcerns.md)