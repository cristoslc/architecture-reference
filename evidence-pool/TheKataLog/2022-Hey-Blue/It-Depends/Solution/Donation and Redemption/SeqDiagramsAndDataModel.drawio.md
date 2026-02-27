# SeqDiagramsAndDataModel

*Extracted text labels from `SeqDiagramsAndDataModel.drawio`*

## Redemption

- Civilian/Charity
- ECommerce Engine
- Redeem Points
- Signs In
- HeyBlue UI
- StoreFront /MunicipalitySystem
- Render Store/Municipality
- return
- return
- Software System: HeyBlue AppContainer: Donation and  RedemptionUsecase: 1. Civilian/Charity Redeems Points for Goods at the Store       2. Civilian Redeems Points at the Municipality to cover Fees/Penalties
- return
- return
- Select Store/Municipality
- launch App
- Buy Products Or Pay Penalty with Point
- Points Accounting
- return
- Update Points
- Points
- Redeem Points
- Debit Points
- return
- StreFront/Municipality
- Redeem Points

## Donation

- Civilian/Officer
- ECommerce Engine
- Donate Points
- Sings In
- HeyBlue UI
- Gateway
- return
- Software System: HeyBlue AppContainer: Donation and RedemptionUsecase: Civilian/Office Donates Points to charity
- return
- return
- Select Charity to Donate
- Donate Points
- Points Accounting
- return
- Update Pointsto Charity
- Points
- Donate Points
- Credit Points
- return

## Payment

- ECommerce Engine
- Software System: HeyBlue AppContainer: Donation and RedemptionUsecases: 1. End of Month Recon Job2. Storefront Pays HeyBlue
- Points Accounting
- Send ReconFile
- Points
- End Of MonthRecon
- HeyBlue Treasurer
- Retail Store System
- Wire/ACH/Other Payment Rails of Payment to HeyBlue Account From Store Account
- Compare Store Activity against Confirm File
- Send ReconFile
- Send Confirmation File
- Compute  HeyBlue Dues
- Recon
- Get Point Activity for Storefront
- Run Query
- return
- Send Confirmation File
- Make payment to HeyBlue Account
- Online Bankwith HeyBlue Account
- Check Payment Activity
- Books & Records
- Cash Accounting
- HeyBlue Accounting App
- Signs In
- Updaet Account Activity Of Shadow Account
- Update Payment
- Update Payment
- return
- return
- Payment

## Administration

- Software System: HeyBlue AppContainer: Donation and RedemptionUsecases: 1. StoreFront/Charity/Municipality Administrators Registers & Configures their respective Interfaces
- StoreFront/Charity/Municipality Administrators
- EComm Config
- return
- Points DB
- Gateway
- Manage Configuration
- HeyBlue UI
- Signs In
- return
- Manage Configuration
- Configs
- Manage Config
- CRUD
- Manage Config
- return
- return
- return

## Data Model

- PointsHistory
- +MemberID ( Of Donor/Redemption )
  +PointAmount
  +Credi/Debit
  +MemberID ( Of Charity/Store/Municipality
  Recieving Donation / Redemption )
  +Amount
  +ActivityTimeStamp
- Member
- +MemberID
  +MemberType ( Civilian/
  Officer/Charity/Municipality/Storefront) 
  +Name
  +Address
  +Points ( Balance - Pertains only 
  to Officer/Civilian & Charity )
- Store
- +MemberID
  +MTDPointsRedeemed ( Aggregated 
  by Month )
  +YTDPointsRedeemed ( Aggregated
  by Month )
- CashForecast
- +MemberID ( of Store )
  +MTDFees
  +MTDAdminChargeBack
  +MTDCommunityShare
- ShadowAccountActivity
- +ActivityID
  +Amount
  +Debit/Credit
  +FromAccount ( Payment from Store )
  +ToAccount ( Payment made to Community )
- Actuals
- +MemberID ( of Store )
  +MTDFees
  +MTDAdminChargeBack
  +MTDCommunityShare
- Cash Management App shows Forecast vs Actual
- Treasurer
- Analytics Store
- Send To Analytics

## Template

- Media Manager
- HeyBlue UI
- Media Outlets
- Interaction Manager
- HeyBlue Social Media
- Civilian Social Media
- Analytics & Reporting
- Label
- Member
