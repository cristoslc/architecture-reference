Architecture Katas Online




                            2021-04-21
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
            * …
         * 2
      e 2
 at
L
      …and now …

Architecture Katas 2021   *




           part 1
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
    system     track bidder activity                   bidder
                                                       tracker
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
    system     track bidder activity                   bidder
                                                       tracker
Your Architectural Kata is...

Going Going Gone!
                                                         video
                                                       streamer
               view live video stream
               view live bid stream
    bidder     place a bid

               receive online bid
               enter live bids into system
  auctioneer   mark item as sold
                                             auction
               start auction                 session
               make payment
    system     track bidder activity                     bidder
                                                         tracker
Your Architectural Kata is...

Going Going Gone!
                                                         video
                                                       streamer
               view live video stream
               view live bid stream
    bidder     place a bid

               receive online bid
               enter live bids into system
  auctioneer   mark item as sold
                                             auction
               start auction                 session
               make payment
    system     track bidder activity                     bidder
                                                         tracker
Your Architectural Kata is...

Going Going Gone!
                                                                    video
                                                                  streamer
               view live video stream
               view live bid stream                       bid
    bidder     place a bid                             streamer


               receive online bid
               enter live bids into system
  auctioneer   mark item as sold
                                             auction
               start auction                 session
               make payment
    system     track bidder activity                                bidder
                                                                    tracker
Your Architectural Kata is...

Going Going Gone!
                                                                    video
                                                                  streamer
               view live video stream
               view live bid stream                       bid
    bidder     place a bid                             streamer


               receive online bid
               enter live bids into system
  auctioneer   mark item as sold
                                             auction
               start auction                 session
               make payment
    system     track bidder activity                                bidder
                                                                    tracker
Your Architectural Kata is...

Going Going Gone!
                                                                              video
                                                                            streamer
               view live video stream
               view live bid stream                       bid
    bidder     place a bid                             streamer


               receive online bid
               enter live bids into system
                                                                    bid
  auctioneer   mark item as sold                                  capture

                                             auction
               start auction                 session
               make payment
    system     track bidder activity                                          bidder
                                                                              tracker
Your Architectural Kata is...

Going Going Gone!
                                                                              video
                                                                            streamer
               view live video stream
               view live bid stream                       bid
    bidder     place a bid                             streamer


               receive online bid
               enter live bids into system
                                                                    bid
  auctioneer   mark item as sold                                  capture

                                             auction
               start auction                 session
               make payment
    system     track bidder activity                                          bidder
                                                                              tracker
Your Architectural Kata is...

Going Going Gone!
                                                                              video
                                                                            streamer
               view live video stream
               view live bid stream                       bid
    bidder     place a bid                             streamer


               receive online bid
               enter live bids into system
                                                                    bid
  auctioneer   mark item as sold                                  capture

                                             auction
               start auction                 session
               make payment
    system     track bidder activity                                          bidder
                                                                              tracker
Your Architectural Kata is...

Going Going Gone!
                                                                              video
                                                                            streamer
               view live video stream
               view live bid stream                       bid
    bidder     place a bid                             streamer


               receive online bid
               enter live bids into system
                                                                    bid
  auctioneer   mark item as sold                                  capture

                                             auction
               start auction                 session
               make payment
    system     track bidder activity                                          bidder
                                                                              tracker
Your Architectural Kata is...

Going Going Gone!
                                                                              video
                                                                            streamer
               view live video stream
               view live bid stream                       bid
    bidder     place a bid                             streamer


               receive online bid
               enter live bids into system
                                                                    bid
  auctioneer   mark item as sold                                  capture

                                             auction
               start auction                 session
               make payment
    system     track bidder activity                                          bidder
                                                                              tracker
Your Architectural Kata is...

Going Going Gone!
                                                                              video
                                                                            streamer
               view live video stream
               view live bid stream                       bid
    bidder     place a bid                             streamer


               receive online bid
               enter live bids into system
                                                                    bid
  auctioneer   mark item as sold                                  capture

                                             auction
               start auction                 session
               make payment
    system     track bidder activity                                          bidder
                                                                              tracker
Your Architectural Kata is...

Going Going Gone!
                                                                              video
                                                                            streamer
               view live video stream
               view live bid stream                       bid
    bidder     place a bid                             streamer


               receive online bid
               enter live bids into system
                                                                    bid
  auctioneer   mark item as sold                                  capture

                                             auction
               start auction                 session
               make payment
    system     track bidder activity                                          bidder
                                                                              tracker
Your Architectural Kata is...

Going Going Gone!
                                                                              video
                                                                            streamer
               view live video stream
               view live bid stream                       bid
    bidder     place a bid                             streamer


               receive online bid
               enter live bids into system
                                                                    bid
  auctioneer   mark item as sold                                  capture

                                             auction
               start auction                 session
               make payment
    system     track bidder activity                                          bidder
                                                                              tracker
Your Architectural Kata is...

Going Going Gone!
                                                                                video
                                                                              streamer
               view live video stream
               view live bid stream                         bid
    bidder     place a bid                               streamer


               receive online bid
               enter live bids into system
                                                                      bid
  auctioneer   mark item as sold                                    capture

                                             auction
               start auction                 session
               make payment
    system     track bidder activity                                            bidder
                                                                                tracker
                                                         auto
                                                       payment
Your Architectural Kata is...

Going Going Gone!
                                                                                video
                                                                              streamer
               view live video stream
               view live bid stream                         bid
    bidder     place a bid                               streamer


               receive online bid
               enter live bids into system
                                                                      bid
  auctioneer   mark item as sold                                    capture

                                             auction
               start auction                 session
               make payment
    system     track bidder activity                                            bidder
                                                                                tracker
                                                         auto
                                                       payment
Your Architectural Kata is...

Going Going Gone!
Your Architectural Kata is...

Going Going Gone!
                                                                                video
                                                                              streamer
               view live video stream
               view live bid stream                         bid
    bidder     place a bid                               streamer


               receive online bid
               enter live bids into system
                                                                      bid
  auctioneer   mark item as sold                                    capture

                                             auction
               start auction                 session
               make payment
    system     track bidder activity                                            bidder
                                                                                tracker
                                                         auto
                                                       payment
Your Architectural Kata is...

Going Going Gone!
                                                                                video
                                                                              streamer
               view live video stream
               view live bid stream                         bid
    bidder     place a bid                               streamer


               receive online bid                                                    online bid
                                                                                      capture
               enter live bids into system
  auctioneer   mark item as sold                                 auctioneer
                                                                  capture
                                             auction
               start auction                 session
               make payment
    system     track bidder activity                                            bidder
                                                                                tracker
                                                         auto
                                                       payment
Your Architectural Kata is...

Going Going Gone!

                   auctioneer                   bidder




         auction            auctioneer                      bid       video
         session              capture     online bid     streamer   streamer
                                           capture


                                bidder
                                tracker


         auto
        payment
Your Architectural Kata is...

Going Going Gone!

                   auctioneer                   bidder




         auction            auctioneer                      bid       video
         session              capture     online bid     streamer   streamer
                                           capture


                                bidder
                                tracker


         auto
        payment
Your Architectural Kata is...

Going Going Gone!

                   auctioneer                   bidder




         auction            auctioneer                      bid       video
         session              capture     online bid     streamer   streamer
                                           capture


                                bidder
                                tracker


         auto
        payment
 Your Architectural Kata is...

 Going Going Gone!
                                 microservices               event-driven
                                 architecture                architecture




Auction        Auctioneer        Online Bid         Bid      Video       Video
Session         Capture           Capture        Streamer   Capture    Streamer
Service         Service           Service         Service   Service     Service




  Auto                            Bidder
Payment                           Tracker
 Service                          Service
        Your Architectural Kata is...

        Going Going Gone!
                                        microservices                    event-driven
                                        architecture                     architecture




                              queue     Online Bid
    Auction      Auctioneer              Capture                Bid      Video       Video
    Session       Capture                Service             Streamer   Capture    Streamer
    Service       Service                                     Service   Service     Service

                                                     queue

queue
                              queue
                    queue
      Auto                               Bidder
    Payment                              Tracker
     Service                             Service
documenting
  software
architecture
documenting software architecture
documenting software architecture
           Second Law of Software Architecture

                “Why is more important
                      than how”
 documenting software architecture

                “We will keep a collection of records for
                architecturally significant decisions: those
                that affect the structure, non-functional
                characteristics, dependencies, interfaces, or
                construction techniques.”
                                                      - Michael Nygard




http://thinkrelevance.com/blog/2011/11/15/documenting-architecture-decisions
    documenting software architecture

                  short text file; 1-2 pages long, one file per decision
                  markdown, textile, asciidoc, plaintext, etc.
# Title

## Status                  short noun phrase
…
                           proposed, accepted, superseded
## Context
…
                           forces at play
## Decision                response to forces
…

## Consequences            context after decision is applied
…
    documenting software architecture

                  short text file; 1-2 pages long, one file per decision
                  markdown, textile, asciidoc, plaintext, etc.
# Title

## Status                  forces criteria for knowing when an architect
…                          must seek approval for a decision
## Context                 description of the problem and alternative
…
                           solutions available (documentation)
## Decision
…
                           justification (the “why”)
## Consequences
…                          tradeoffs and impact of decision
documenting software architecture
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
                                Going Going Gone!
Your Architectural Kata is...
                                                    separate queues for Bid
                                                    Streamer and Bidder
                                                    Tracker services

                                                             ?
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
# Use of Micro-kernel Architecture

## Status
_PROPOSED_

## Context
Two key requirements of the system (_promotions_ and _location services_) have both global (affects all stores) and local (specific to location) requirements.

The current design features a modular monolith architecture, allowing individual stores to upload their behavior using JAR files, shown in _Figure 1_.

![modular monolith](fig1_modular_monolith.jpg) <br>
_Figure 1: the current state architecture_

Currently, stores must specify custom behavior (product specials, promotions, location exemptions) via a JAR file, uploaded to the global site via FTP. Operations must certify the JAR, leading to delays in depl

All local customizations reside in one service and in one set of tables in the master database. Over time, as new customizations accrued, it has become a tangled mess.

To allow stores to most easily add and customize local behavior, the architects propose moving to a micro-kernel architecture, shown in _Figure 2_.

![microkernel architecture](fig2_microkernel.jpg) <br>
_Figure 2: proposed microkernel architecture_

The new design allows easy update of global policy (products, inventory, promotions) while allowing local stores to selectively those choices when appropriate.

## Decision
The architects decided to migrate the current monolith to become the core system for the new microkernel architecture, and build new functionality via plug-ins.

## Consequences
The architects take advantage of the restructuring opportunity to localize databases to individual domains. Communication between services now occurs via messaging.

The new design also incorporates the BFF patterns, discussed in [004 BFF for device independence](001-use-of-microkernel.html).

The new design will greatly improve the customization workflow.

- the local store plug-in architecture certifies customizations automatically
- promotions within threshold values go live within 15 minutes
- all stores work with generic workflows via the core system, but locations can override to create custom behavior for:
  - promotions
  - location exemptions
  - local products
# Use of Micro-kernel Architecture

## Status
_PROPOSED_

## Context
Two key requirements of the system (_promotions_ and _location services_) have both global (affects all stores) and local (specific to location) requirements.

The current design features a modular monolith architecture, allowing individual stores to upload their behavior using JAR files, shown in _Figure 1_.

![modular monolith](fig1_modular_monolith.jpg) <br>
_Figure 1: the current state architecture_

Currently, stores must specify custom behavior (product specials, promotions, location exemptions) via a JAR file, uploaded to the global site via FTP. Operations must certify the JAR, leading to delays in depl

All local customizations reside in one service and in one set of tables in the master database. Over time, as new customizations accrued, it has become a tangled mess.

To allow stores to most easily add and customize local behavior, the architects propose moving to a micro-kernel architecture, shown in _Figure 2_.

![microkernel architecture](fig2_microkernel.jpg) <br>
_Figure 2: proposed microkernel architecture_

The new design allows easy update of global policy (products, inventory, promotions) while allowing local stores to selectively those choices when appropriate.

## Decision
The architects decided to migrate the current monolith to become the core system for the new microkernel architecture, and build new functionality via plug-ins.

## Consequences
The architects take advantage of the restructuring opportunity to localize databases to individual domains. Communication between services now occurs via messaging.

The new design also incorporates the BFF patterns, discussed in [004 BFF for device independence](001-use-of-microkernel.html).

The new design will greatly improve the customization workflow.

- the local store plug-in architecture certifies customizations automatically
- promotions within threshold values go live within 15 minutes
- all stores work with generic workflows via the core system, but locations can override to create custom behavior for:
  - promotions
  - location exemptions
  - local products
Meet the
Judges!
Meet the
Client !!
The Sysops Squad
Penultimate Electronics is a large electronics giant that has numerous retail stores throughout the country.
When customers buy computers, TV’s, stereos, and other electronic equipment, they can choose to
purchase a support plan. Customer-facing technology experts (the “Sysops Squad”) will then come to the
customers residence (or work office) to fix problems with the electronic device.
  Four Main Sysop Squad Users

The administrator user maintains the internal users of the system,
including the list of experts and their corresponding skillset, location,
and availability. The administrator also manages all of the billing
processing for customers using the system, and maintains static
reference data (such as supported products, name- value pairs in the
system, and so on).
  Four Main Sysop Squad Users


The customer registers for the Sysops Squad service, maintains their
customer profile, support contracts, and billing information. Customers
enter problem tickets into the system, and also fill out surveys after the
work has been completed.
  Four Main Sysop Squad Users


Experts are assigned problem tickets and fix problems based on the
ticket. They also interact with the knowledge base to search for
solutions to customer problems and also enter notes about repairs.
  Four Main Sysop Squad Users


The manager keeps track of problem ticket operations and receives
operational and analytical reports about the overall Sysops Squad
problem ticket system.
                 Non-ticket Workflow
The manager keeps track of problem ticket operations and receives
operational and analytical reports about the overall Sysops Squad problem
ticket system.

•   Sysops Squad experts are added and maintained in the system through
    an administrator, who enters in their locale, availability, and skills.

•   Customers register with the Sysops Squad system and have multiple
    support plans based on the products they purchased.

•   Customers are automatically billed monthly based on credit card
    information contained in their profile. Customers can view billing history
    and statements through the system.

•   Managers request and receive various operational and analytical reports,
    including financial reports, expert performance reports, and ticketing
    reports.
                   Ticketing Workflow
The ticketing workflow starts when a customer enters a problem ticket into
the system, and ends when the customer completes the survey after the
repair is done. This workflow is outlined as follows:

•   Customers who have purchased the support plan enter a problem ticket
    using the Sysops Squad website.

•   Once a problem ticket is entered in the system, the system then
    determines which Sysops Squad expert would be the best fit for the job
    based on skills, cur‐ rent location, service area, and availability (free or
    currently on a job).

•   Once assigned, the problem ticket is uploaded to a dedicated custom
    mobile app on the Sysops Squad expert’s mobile device. The expert is
    also notified via a text message that they have a new problem ticket.
                   Ticketing Workflow
•   The customer is notified through an SMS text message or email (based on their
    profile preference) that the expert is on their way.

•   The expert uses the custom mobile application on their phone to retrieve the
    ticket information and location. The sysops squad expert can also access a
    knowledge base through the mobile app to find out what things have been done
    in the past to fix the problem.

•   Once the expert fixes the problem, they mark the ticket as “complete”. The
    sysops squad expert can then add information about the problem and repair
    information to the knowledge base.

•   After the system receives notification that the ticket is complete, the system send
    an email to the customer with a link to a survey which the customer then fills out.

•   The system receives the completed survey from the customer and records the
    survey information.
Sysops Squad - A Bad Situation…
Things have not been good with the Sysops Squad lately. The current trouble ticket system is a large monolithic application that was developed many years
ago. Customers are complaining that consultants are never showing up due to lost tickets, and often times the wrong consultant shows up to fix something
they know nothing about. Customers and call-center staff have been complaining that the system is not always available for web-based or call-based problem
ticket entry. Change is difficult and risky in this large monolith - whenever a change is made, it takes too long and something else usually breaks. Due to
reliability issues, the monolithic system frequently “freezes up” or crashes - they think it’s mostly due a spike in usage and the number of customers using the
system. If something isn’t done soon, Penultimate Electronics will be forced to abandon this very lucrative business line and fire all of the experts (including
you, the architect).

Current process in the monolithic system:

1. Sysops squad experts are added and maintained in the system through an administrator, who enters in their locale, availability, and skills.
2. Customers who have purchased the support plan can enter a problem ticket using the sysops squad website. Customer registration for the support
   service is part of the system. The system bills the customer on an annual basis when their support period ends by charging their registered credit card.
3. Once a trouble ticket is entered in the system, the system then determines which sysops squad expert would be the best fit for the job based on skills,
   current location, service area, and availability (free or currently on a job).
4. The sysops squad expert is then notified via a text message that they have a new ticket. Once this happens an email or SMS text message is sent to the
   customer (based on their profile preference) that the expert is on their way.
5. The sysops squad expert then uses a custom mobile application on their phone to access the ticketing system to retrieve the ticket information and
   location. The sysops squad expert can also access a knowledge base through the mobile app to find out what things have been done in the past to fix the
   problem.
6. Once the sysops squad expert fixes the problem, they mark the ticket as “complete”. The sysops squad expert can then add information about the
   problem and fix to the knowledge base.
7. After the system receives notification that the ticket is complete, the system send an email to the customer with a link to a survey which the customer then
   fills out.
Architecture Components
Existing Components
Existing Components
Existing Tables
Existing Tables
Existing Tables
       Some Things to Think About

•   Customer registration—customers register on the site and provide their
    profile information, billing information (credit card), and what products
    they purchased that they would like to have covered (support plan).

•   Administration activities–admin staff maintain internal user accounts,
    query ticket status via a “help desk” when customers call for status, and
    maintain various reference data

•   Managers can run reports, including various ticketing reports, expert
    performance reports, and financial reports
Meet the
Criteria!
Judges Criteria
Clarity of
narrative,
organization,
and supporting
documentation
Understanding of
the requirements
and completeness
of solution
Identification of
supporting
architecture
characteristics
Diagrams –
types, level of
detail, and
completeness
Architecture
decision
records –
documentation
and justification
Overall systems
architecture
Logistics and details
Q&A
Go forth & do some
   architecture!
