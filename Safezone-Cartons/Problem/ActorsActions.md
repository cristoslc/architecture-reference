# Actors & Actions

## Who are Actors and Actions

Identified actors of “MonitorMe” and their actions.

---

**Actor:** Leading Nurse

Leading Nurse is the person who can manage specific in the Nurse Station system

**Actions:**

- Setup new patient in the system
- Remove patient from the system
- Modify patient threshold
- Everything what a *Nurse* can do

---

**Actor:** Nurse

Nurse is the person who is observing the Nurse Station system

**Actions:**

- Modify patient data
- Add device to patient
- Create snapshot of patient data
- View patient threshold values
- Set focus for patient on Monitoring screen
- Read consolidated health metrics for patients on screen

---

**Actor:** Doctor

Medical Staff who manages several patients in different stations and floors

**Actions:**

- Watch combined health metrics of selected patients (mobile app)
- Setup alerts for specific patients s/he is responsible for
- Sends a patient back home after recovery
- Everything what a *leading nurse* can do
- ...

---

**Actor:** Patient

Person who is monitored by the MonitorMe system

**Actions:**

- Accidentally removes a device

--- 

**Actor:** System Administrator

Person who is responsible for maintaining the overall MonitorMe system

**Actions:**

- Integrate new Vital Sign device into the system
- Takes vital sign devices out of order after replacement



---
[> Home](../README.md)    [>  Problem Background](README.md)
[< Prev](ArchitectureAnalysis.md)  |  [Next >](ConstraintsAndAssumptions.md)