# state-machine-and-activity-diagram

*Extracted text labels from `state-machine-and-activity-diagram.drawio`*

## Pick up meal activity diagram

- Subscribers (inventory or order)
- Transaction updaters
- Smart Fridge mgmt system
- Smart Fridge
- Customer opens the smart fridge and gets meals
- Smart fridge mgmt system updates this internal inventory
- Call smart mgmt system to get recent transaction
- Time elapsed for polling new transaction?
- Yes
- No
- Confirm order at  fridge UI
- Connect to smart fridge mgmt system
- Respond to recent transactions request
- Inventory  event
- Inventory event
- Order event
- Proccess recent transactions
- Order event
- Process order
- Update inventory
- Fridge Transactions

## Fridge state machine

- Fridge On
- Installed and off
- Operativeoffline
- Operativeoffline
- Operativeonline
- Temporarilyout of order
- Being checked tby replenisher
- Decommissioned
- In maintenance by smart fridgetechnician
- connection established
- fridge is decommissioned
- autorecovery
- technical problem
- technician startsmaintenance
- recovered fromtechnicalproblem
- fridge is decommissioned
- turn off orpower loss
- connectionlost
- technical problem
- finishedreplenishingfridge
- technicalproblem
- technician startsmaintenance
- technician startsmaintenance
- turn fridge on
- replenish modeactivated
- technical problem persists
