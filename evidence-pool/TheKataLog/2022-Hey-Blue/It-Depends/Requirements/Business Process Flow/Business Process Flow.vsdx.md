# Visio Diagram: Business Process Flow.vsdx

## background 4:3 on A4

*No labeled shapes on this page.*

## Register

**Components:**

- [Component] UC001 : Creating an Interaction
- [Component] Citizen
- [Component] Officer
- [Component] Business
- [Component] Charity
- [Component] Citizen
- [Component] Register
- [Component] Use Case UC001 Creating an Interaction / Business Workflow: Register
- [Component] Select Storefront
- [Component] Add Products
- [Component] Select  / Front Page
- [Component] Add Vision
- [Component] Enter Details
- [Component] Add Vision
- [Component] Enable / Notifications?
- [Component] N
- [Component] Create / Profile
- [Component] Enable / Location?
- [Component] Y
- [Component] Set “prompt  / on login”
- [Component] Y
- [Component] Start registration
- [Component] Enter Details
- [Component] Set “prompt  / on login”
- [Component] N
- [Component] Complete registration
- [Component] If notifications or location is turned off then user will be prompted at login to consent
- [Component] Delete Profile
- [Component] Delete all user data

**Connections:**

- Delete Profile --> Shape-1494
- Shape-1492 --> Delete Profile
- Enable --(N)--> Set “prompt 
- Set “prompt  --> Enable
- Enter Details --> Enable
- Add Vision --> Shape-1061
- Enter Details --> Add Vision
- Shape-1059 --> Enter Details
- Add Vision --> Shape-1008
- Select  --> Add Vision
- Shape-1006 --> Select 
- Add Products --> Shape-955
- Select Storefront --> Add Products
- Shape-924 --> Select Storefront
- Create --> Shape-869
- Enable --(Y)--> Enable
- Enable --(N)--> Set “prompt 
- Shape-835 --> Enter Details
- Enable --(Y)--> Create
- Set “prompt  --> Create

## Template

**Components:**

- [Component] UC001 : Creating an Interaction
- [Component] Citizen
- [Component] Officer
- [Component] Share
- [Component] Use Case UC001 Creating an Interaction / Business Workflow: Notify Proximity, Interact, Share, Earn Points
- [Component] Accept
- [Component] Scan QR Code at hub
- [Component] Notify of opportunity
- [Component] N
- [Component] Hub location sent
- [Component] Upload interaction
- [Component] Upload interaction
- [Component] Y

**Connections:**

- Accept --(Y)--> Hub location sent
- Upload interaction --> Shape-1586
- Upload interaction --> Shape-1582
- Shape-1533 --> Upload interaction
- Shape-1531 --> Upload interaction
- Hub location sent --> Shape-1505
- Shape-1453 --> Scan QR Code at hub
- Scan QR Code at hub --> Notify of opportunity
- Notify of opportunity --> Accept
- Accept --(N)--> Shape-1505

## Redeem

**Components:**

- [Component] UC002, 3, 4: Donate or Redeem Points
- [Component] Citizen
- [Component] Officer
- [Component] Charity
- [Component] Business
- [Component] Donate or Redeem
- [Component] Browse
- [Component] Notify of / purchase
- [Component] Login to app
- [Component] Browse  / Charities
- [Component] Donate
- [Component] Browse  / Retailers
- [Component] Select / Items
- [Component] Spend
- [Component] Charity or Retailer?
- [Component] Login to app
- [Component] Browse  / Charities
- [Component] Donate
- [Component] Login to app
- [Component] Browse  / Retailers
- [Component] Select / Items
- [Component] Spend
- [Component] Use Case UC002, UC003, UC004 Donate or Redeem Points / Business Workflow: Browse retail stores, donate or spend

**Connections:**

- Browse  --> Select
- Shape-391 --> Login to app
- Shape-93 --> Login to app
- Shape-319 --> Login to app
- Notify of --> Shape-536
- Select --> Spend
- Spend --> Shape-438
- Donate --> Shape-533
- Browse  --> Donate
- Login to app --> Browse 
- Login to app --> Browse 
- Spend --> Shape-218
- Select --> Spend
- Browse  --> Select
- Charity or Retailer? --> Browse 
- Login to app --> Charity or Retailer?
- Charity or Retailer? --> Browse 
- Browse  --> Donate
- Donate --> Shape-94
- Shape-218 --> Notify of

---
*Converted from Visio VSDX (shape text and connections extracted)*
