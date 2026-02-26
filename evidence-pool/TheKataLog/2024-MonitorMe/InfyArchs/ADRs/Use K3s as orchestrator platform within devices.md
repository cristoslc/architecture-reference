# Use K3s as orchestrator platform within devices

## Status
ACCEPTED

## Context
Applications running on IOT devices which is used to capture patient vitals should be able to recover from unexpected failures without manual intervensions.

## Decision
The applications running on the hardware device needs to have an orchestrator which will ensure the applications are having the right availability. Typically in a cloud or on-premise environment, the Kubernetes software is used as the orchestrator to ensure the availability of the applications running in the cluster. The ***MonitorMe*** system needs such high availabilityon the applications running on the hardware devices as well. So we have decided to choose a light-weight kubernetes distributions which can run on edge devices and ensures the uptime of the applications running in the device.

There are different edge-compatible kubernetes distributions available like ***K3s***, ***KubeEdge*** etc. Out of which we have decided to use ***K3S*** as the distribution which will be running on the edge devices mainly due to following reasons
- K3s is optimized to run on ARM architectures. 
- Its small footprint and simplicity make it easier to run and manage in the smaller, more resource-constrained world of edge computing.

The IOT devices needs to have [K3s](https://k3s.io/) installed which will be the orchestrator platform to monitor all software components running inside the device. This ***K3s*** cluster can be monitored remotely using tools like [Rancher](https://www.rancher.com/products/k3s).

## Consequences
Whenever application components crashes unexpectedly, the [K3s](https://k3s.io/) will make sure the components are restarted automatically without manual intervention. 
