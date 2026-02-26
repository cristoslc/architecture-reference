Architecture Katas Online
                  h  i s
              d t        ?
          d i        o m
      r e        f r
  h e       m e
W c       o
   e a
id
          n …
       h e
    d t
 a n
…




             http://fundamentalsofsoftwarearchitecture.com/katas/
          n …
       h e
    d t
 a n
…
…and now.
The deliverables
Your Architectural Kata is...

Going Going Gone!
1. Separate Queues for Bid Streamer and Tracker Services
Status
Accepted

Context
The Bid Capture Services, upon receiving a bid, must forward that bid to the Bid Streamer Service and the Bidder Tracker
Service. This could be done using a single topic (pub/sub) or separate queues (p2p) for each service.


Decision
We will use separate queues for the Bid Streamer and Bidder Tracker services.

Multiple bids will come in for the same ask amount. The Streamer service only needs the first bid received for that amount,
whereas the Bidder Tracker needs all bids received. Using a topic (pub/sub) would require the Bid Streamer to contain logic
to ignore bids that are the same as the prior amount, forcing the Bid Streamer to store shared state between instances.

The Bid Streamer Service stores the bids for an item in an in-memory cache, whereas the Bidder Tracker stored bids in a
database. The Bidder Tracker will therefore be slower and might require back pressure. Using a dedicated Bidder Tracker
queue provides this dedicated back pressure point.


Consequences
This decision will require the Bid Capture services to send the same information to multiple queues.
architecture katas
identifying characteristics
Your Architectural Kata is...

Going Going Gone!
An auction company wants to take their auctions online to a nationwide scale--customers choose the auction to
participate in, wait until the auction begins, then bid during the live auction as if they were there in the room,
with the auctioneer.
 • Users: scale up to hundreds of participants (per auction), potentially up to thousands of participants, and as
    many simultaneous auctions as possible
 • Requirements:
     ◦ bidders can see a live video stream of the auction and see all bids as they occur
     ◦ auctions must be as real-time as possible
     ◦ both online and live bids must be received in the order in which they are placed
     ◦ bidders register with credit card; system automatically charges card if bidder wins
     ◦ participants must be tracked via a reputation index
 • Additional Context:
     ◦ auction company is expanding aggressively by merging with smaller competitors
     ◦ if nationwide auction is a success, replicate the model overseas
     ◦ budget is not constrained--this is a strategic direction
     ◦ company just exited a lawsuit where they settled a suit alleging fraud
Your Architectural Kata is...

Going Going Gone!
                                                      ?
An auction company wants to take their auctions online to a nationwide scale--customers choose the auction to
participate in, wait until the auction begins, then bid during the live auction as if they were there in the room,
with the auctioneer.
 • Users: scale up to hundreds of participants (per auction), potentially up to thousands of participants, and as
    many simultaneous auctions as possible
 • Requirements:
     ◦ bidders can see a live video stream of the auction and see all bids as they occur
     ◦ auctions must be as real-time as possible
                                                     ?
     ◦ both online and live bids must be received in the order in which they are placed
     ◦ bidders register with credit card; system automatically charges card if bidder wins
     ◦ participants must be tracked via a reputation index
 • Additional Context:
     ◦ auction company is expanding aggressively by merging with smaller competitors
     ◦ if nationwide auction is a success, replicate the model overseas
     ◦ budget is not constrained--this is a strategic direction
     ◦ company just exited a lawsuit where they settled a suit alleging fraud
Your Architectural Kata is...

Going Going Gone!
An auction company wants to take their auctions online to a nationwide scale--customers choose the auction to
participate in, wait until the auction begins, then bid during the live auction as if they were there in the room,
with the auctioneer.
 • Users: scale up to hundreds of participants (per auction), potentially up to thousands of participants, and as
    many simultaneous auctions as possible
 • Requirements:
     ◦ bidders can see a live video stream of the auction and see all bids as they occur
     ◦ auctions must be as real-time as possible
     ◦ both online and live bids must be received in the order in which they are placed
     ◦ bidders register with credit card; system automatically charges card if bidder wins
     ◦ participants must be tracked via a reputation index
 • Additional Context:
     ◦ auction company is expanding aggressively by merging with smaller competitors
     ◦ if nationwide auction is a success, replicate the model overseas
     ◦ budget is not constrained--this is a strategic direction
     ◦ company just exited a lawsuit where they settled a suit alleging fraud

  availability       reliability      performance
Your Architectural Kata is...

Going Going Gone!
                                                                              ?
An auction company wants to take their auctions online to a nationwide scale--customers choose the auction to

                                                                                                                 ?
participate in, wait until the auction begins, then bid during the live auction as if they were there in the room,
with the auctioneer.
 • Users: scale up to hundreds of participants (per auction), potentially up to thousands of participants, and as
    many simultaneous auctions as possible
 • Requirements:
     ◦ bidders can see a live video stream of the auction and see all bids as they occur
     ◦ auctions must be as real-time as possible
     ◦ both online and live bids must be received in the order in which they are placed
     ◦ bidders register with credit card; system automatically charges card if bidder wins
     ◦ participants must be tracked via a reputation index
 • Additional Context:                                                                        ?
     ◦ auction company is expanding aggressively by merging with smaller competitors
     ◦ if nationwide auction is a success, replicate the model overseas
     ◦ budget is not constrained--this is a strategic direction
     ◦ company just exited a lawsuit where they settled a suit alleging fraud

  availability       reliability      performance
Your Architectural Kata is...

Going Going Gone!
An auction company wants to take their auctions online to a nationwide scale--customers choose the auction to
participate in, wait until the auction begins, then bid during the live auction as if they were there in the room,
with the auctioneer.
 • Users: scale up to hundreds of participants (per auction), potentially up to thousands of participants, and as
    many simultaneous auctions as possible
 • Requirements:
     ◦ bidders can see a live video stream of the auction and see all bids as they occur
     ◦ auctions must be as real-time as possible
     ◦ both online and live bids must be received in the order in which they are placed
     ◦ bidders register with credit card; system automatically charges card if bidder wins
     ◦ participants must be tracked via a reputation index
 • Additional Context:
     ◦ auction company is expanding aggressively by merging with smaller competitors
     ◦ if nationwide auction is a success, replicate the model overseas
     ◦ budget is not constrained--this is a strategic direction
     ◦ company just exited a lawsuit where they settled a suit alleging fraud

  availability       reliability      performance          scalability
Your Architectural Kata is...

Going Going Gone!
An auction company wants to take their auctions online to a nationwide scale--customers choose the auction to
participate in, wait until the auction begins, then bid during the live auction as if they were there in the room,
with the auctioneer.
 • Users: scale up to hundreds of participants (per auction), potentially up to thousands of participants, and as
                                                                                                                 ?
    many simultaneous auctions as possible
 • Requirements:
     ◦ bidders can see a live video stream of the auction and see all bids as they occur
     ◦ auctions must be as real-time as possible
     ◦ both online and live bids must be received in the order in which they are placed
     ◦ bidders register with credit card; system automatically charges card if bidder wins
     ◦ participants must be tracked via a reputation index
 • Additional Context:
     ◦ auction company is expanding aggressively by merging with smaller competitors
     ◦ if nationwide auction is a success, replicate the model overseas
     ◦ budget is not constrained--this is a strategic direction
     ◦ company just exited a lawsuit where they settled a suit alleging fraud

  availability       reliability      performance          scalability
Your Architectural Kata is...

Going Going Gone!
An auction company wants to take their auctions online to a nationwide scale--customers choose the auction to
participate in, wait until the auction begins, then bid during the live auction as if they were there in the room,
with the auctioneer.
 • Users: scale up to hundreds of participants (per auction), potentially up to thousands of participants, and as
    many simultaneous auctions as possible
 • Requirements:
     ◦ bidders can see a live video stream of the auction and see all bids as they occur
     ◦ auctions must be as real-time as possible
     ◦ both online and live bids must be received in the order in which they are placed
     ◦ bidders register with credit card; system automatically charges card if bidder wins
     ◦ participants must be tracked via a reputation index
 • Additional Context:
     ◦ auction company is expanding aggressively by merging with smaller competitors
     ◦ if nationwide auction is a success, replicate the model overseas
     ◦ budget is not constrained--this is a strategic direction
     ◦ company just exited a lawsuit where they settled a suit alleging fraud

  availability       reliability      performance          scalability       elasticity
scalability:



users




        time
elasticity:



users




        time
Your Architectural Kata is...

Going Going Gone!
An auction company wants to take their auctions online to a nationwide scale--customers choose the auction to
participate in, wait until the auction begins, then bid during the live auction as if they were there in the room,
with the auctioneer.
 • Users: scale up to hundreds of participants (per auction), potentially up to thousands of participants, and as
    many simultaneous auctions as possible
 • Requirements:
     ◦ bidders can see a live video stream of the auction and see all bids as they occur
     ◦ auctions must be as real-time as possible
     ◦ both online and live bids must be received in the order in which they are placed
                                                              ?
     ◦ bidders register with credit card; system automatically charges card if bidder wins
     ◦ participants must be tracked via a reputation index
 • Additional Context:
     ◦ auction company is expanding aggressively by merging with smaller competitors
     ◦ if nationwide auction is a success, replicate the model overseas
     ◦ budget is not constrained--this is a strategic direction
     ◦ company just exited a lawsuit where they settled a suit alleging fraud

  availability       reliability      performance          scalability       elasticity
Your Architectural Kata is...

Going Going Gone!
An auction company wants to take their auctions online to a nationwide scale--customers choose the auction to
participate in, wait until the auction begins, then bid during the live auction as if they were there in the room,
with the auctioneer.
 • Users: scale up to hundreds of participants (per auction), potentially up to thousands of participants, and as
    many simultaneous auctions as possible
 • Requirements:
     ◦ bidders can see a live video stream of the auction and see all bids as they occur

                                                                                             ?
     ◦ auctions must be as real-time as possible
     ◦ both online and live bids must be received in the order in which they are placed
     ◦ bidders register with credit card; system automatically charges card if bidder wins
     ◦ participants must be tracked via a reputation index
 • Additional Context:
     ◦ auction company is expanding aggressively by merging with smaller competitors
     ◦ if nationwide auction is a success, replicate the model overseas
     ◦ budget is not constrained--this is a strategic direction
     ◦ company just exited a lawsuit where they settled a suit alleging fraud

  availability       reliability      performance          scalability       elasticity
Your Architectural Kata is...

Going Going Gone!
An auction company wants to take their auctions online to a nationwide scale--customers choose the auction to
participate in, wait until the auction begins, then bid during the live auction as if they were there in the room,
with the auctioneer.
 • Users: scale up to hundreds of participants (per auction), potentially up to thousands of participants, and as
    many simultaneous auctions as possible
 • Requirements:
     ◦ bidders can see a live video stream of the auction and see all bids as they occur
     ◦ auctions must be as real-time as possible
     ◦ both online and live bids must be received in the order in which they are placed
     ◦ bidders register with credit card; system automatically charges card if bidder wins
     ◦ participants must be tracked via a reputation index
 • Additional Context:
     ◦ auction company is expanding aggressively by merging with smaller competitors
     ◦ if nationwide auction is a success, replicate the model overseas
     ◦ budget is not constrained--this is a strategic direction
     ◦ company just exited a lawsuit where they settled a suit alleging fraud

  availability       reliability      performance          scalability       elasticity     (security)
Your Architectural Kata is...

Going Going Gone!
An auction company wants to take their auctions online to a nationwide scale--customers choose the auction to
participate in, wait until the auction begins, then bid during the live auction as if they were there in the room,
with the auctioneer.
 • Users: scale up to hundreds of participants (per auction), potentially up to thousands of participants, and as
    many simultaneous auctions as possible
 • Requirements:
     ◦ bidders can see a live video stream of the auction and see all bids as they occur
     ◦ auctions must be as real-time as possible
     ◦ both online and live bids must be received in the order in which they are placed
     ◦ bidders register with credit card; system automatically charges card if bidder wins
     ◦ participants must be tracked via a reputation index
 • Additional Context:
     ◦ auction company is expanding aggressively by merging with smaller competitors
     ◦ if nationwide auction is a success, replicate the model overseas
     ◦ budget is not constrained--this is a strategic direction
     ◦ company just exited a lawsuit where they settled a suit alleging fraud

  availability       reliability      performance          scalability       elasticity     (security)
Your Architectural Kata is...

Going Going Gone!
An auction company wants to take their auctions online to a nationwide scale--customers choose the auction to
participate in, wait until the auction begins, then bid during the live auction as if they were there in the room,
with the auctioneer.
 • Users: scale up to hundreds of participants (per auction), potentially up to thousands of participants, and as
    many simultaneous auctions as possible
 • Requirements:
     ◦ bidders can see a live video stream of the auction and see all bids as they occur
     ◦ auctions must be as real-time as possible
     ◦ both online and live bids must be received in the order in which they are placed
     ◦ bidders register with credit card; system automatically charges card if bidder wins
     ◦ participants must be tracked via a reputation index
 • Additional Context:
     ◦ auction company is expanding aggressively by merging with smaller competitors
     ◦ if nationwide auction is a success, replicate the model overseas
     ◦ budget is not constrained--this is a strategic direction
     ◦ company just exited a lawsuit where they settled a suit alleging fraud

  availability       reliability      performance          scalability       elasticity     (security)
 architecture katas
identifying major components
                Your Architectural Kata is...


                Silicon Sandwiches
component identification
Your Architectural Kata is...

Going Going Gone!
An auction company wants to take their auctions online to a nationwide scale--customers choose the auction to
participate in, wait until the auction begins, then bid during the live auction as if they were there in the room,
with the auctioneer.
 • Users: scale up to hundreds of participants (per auction), potentially up to thousands of participants, and as
    many simultaneous auctions as possible
 • Requirements:
     ◦ bidders can see a live video stream of the auction and see all bids as they occur
     ◦ auctions must be as real-time as possible
     ◦ both online and live bids must be received in the order in which they are placed
     ◦ bidders register with credit card; system automatically charges card if bidder wins
     ◦ participants must be tracked via a reputation index
 • Additional Context:
     ◦ auction company is expanding aggressively by merging with smaller competitors
     ◦ if nationwide auction is a success, replicate the model overseas
     ◦ budget is not constrained--this is a strategic direction
     ◦ company just exited a lawsuit where they settled a suit alleging fraud
Your Architectural Kata is...

Going Going Gone!
Your Architectural Kata is...

Going Going Gone!
                                 the “entity trap”

                      auctions         items         bids
Your Architectural Kata is...

Going Going Gone!
                                 the “entity trap”

                       auction
                      auctions         items         bids
                       manager




                    create auction
                     browse auctions
                    schedule auction
Your Architectural Kata is...

Going Going Gone!
                                 the “entity trap”

                       auction             item
                      auctions           items        bids
                       manager           manager




                    create auction     create item
                     browse auctions   display item
                    schedule auction   upload image
Your Architectural Kata is...

Going Going Gone!
                                 the “entity trap”

                       auction             item
                      auctions           items        bid bids
                                                          manager
                       manager           manager




                    create auction     create item    place bids
                     browse auctions   display item   display bids
                    schedule auction   upload image   track bids
Your Architectural Kata is...

Going Going Gone!
                                workflow approach
       create auction      find auction   sign up   watch auction   place bid
Your Architectural Kata is...

Going Going Gone!
                                workflow approach
       create auction      find auction   sign up        watch auction   place bid




            auction             auction     auction           video         bid
            creator             browser   registration      streamer      capture
Your Architectural Kata is...

Going Going Gone!
                           actor/action approach


             bidder               auctioneer       system
Your Architectural Kata is...

Going Going Gone!
                               actor/action approach


             bidder                   auctioneer       system




      view live video stream
       view live bid stream
           place a bid
Your Architectural Kata is...

Going Going Gone!
                               actor/action approach


             bidder                      auctioneer              system




      view live video stream       enter live bids into system
       view live bid stream           receive online bid
           place a bid                mark item as sold
Your Architectural Kata is...

Going Going Gone!
                               actor/action approach


             bidder                      auctioneer                    system




      view live video stream       enter live bids into system       start auction
       view live bid stream           receive online bid           make payment
           place a bid                mark item as sold          track bidder activity
Your Architectural Kata is...

Going Going Gone!
               view live video stream
               view live bid stream
    bidder     place a bid

               receive online bid
               enter live bids into system
  auctioneer   mark item as sold

               start auction
               make payment
    system     track bidder activity
Your Architectural Kata is...

Going Going Gone!
               view live video stream
               view live bid stream
    bidder     place a bid

               receive online bid
               enter live bids into system
  auctioneer   mark item as sold

               start auction
               make payment
    system     track bidder activity
Your Architectural Kata is...

Going Going Gone!
               view live video stream
               view live bid stream
    bidder     place a bid

               receive online bid
               enter live bids into system
  auctioneer   mark item as sold
                                             auction
               start auction                 session
               make payment
    system     track bidder activity
