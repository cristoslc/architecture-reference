Architecture Katas
Private Event February 2024

         Neal Ford
         Thoughtworks
         Director / Software Architect / Meme Wrangler
         https://www.nealford.com


        Mark Richards
    NFJS Software Symposium Series 2016
        Independent Consultant
        Hands-on Software Architect, Published Author
        Founder, DeveloperToArchitect.com

                                                         Contest Kickoff
        @markrichardssa
Introduction
                  h i s
              d t       ?
          d i       o m
      r e        fr
   he      m  e
W c       o
   e a
i d
  Wh
ide   ere
   a c did
      om       thi
          e fr s
              om
                  ?
                     http://fundamentalsofsoftwarearchitecture.com/katas/

               n …
             he
       d   t
 a   n
…
               n …
             he
       d   t
 a   n
…
Late 2020…
Meet the Judges
Jacqui Read


Jacqui Read is an internationally recognized solution
and enterprise architect and author of
Communication Patterns: A Guide for Developers
and Architects. She specializes in helping businesses
create and enhance architecture practices, construct
evolutionary architectures, and untangle and extract
value from data and knowledge. Jacqui also teaches
public and private workshops and speaks at
international conferences on topics such as
architecture practices, technical communication, and
architecture decisions. Her professional interests
include collaborative modeling, knowledge
management, domain-driven design, sociotechnical
architecture, and modernizing enterprise architecture
practices. In her free time, Jacqui enjoys gardening
and attempting to strum her ukulele and sing at the
same time. Her website is https://jacquiread.com.
Andrew
Harmel-Law

Andrew Harmel-Law is a tech principal at
Thoughtworks, an author, and an instructor
on the O’Reilly learning platform. He
specializes in domain-driven design,
Java/JVM technologies, agile delivery, and
organization design and has extensive
experience delivering large-scale software
solutions across government, banking, and
ecommerce sectors. Passionate about open
source software, Andrew actively contributes
to OSS communities and shares his expertise
through consulting, mentoring, blogging, and
speaking at conferences.
Diana
Montalion

Diana Montalion has more than 17 years of
experience delivering transformative
initiatives, independently or as part of a
professional services group, to clients
including Stanford University, the Gates
Foundation, and Teach For All. She’s the
founder of Mentrix Group, a consultancy that
provides technology architecture, systems
leadership, and workshops on nonlinear
approaches. Previously, she served as
principal architect for The Economist and the
Wikimedia Foundation. Writing, teaching, and
thinking about thinking are her favorite
hobbies.
Sergey Zinchenko


Sergey Zinchenko is technical director at
SD Interra in Toronto. An experienced
technical leader and software architect
with a history of leading teams to deliver
working solutions, he’s seasoned in
application, solution, and enterprise
architecture with a range of experience
from building systems from scratch for
startups to modernizing mainframe-
based banking giants. His native
language is “C.”
The Process
structural design in architecture
requirements | use cases | story cards | DDD event-storm output | ?
                               reliability

performance                                  security




                                               scalability


  deployability




                  elasticity
                               reliability

performance                                  security




                                               scalability


  deployability




                  elasticity
Your Architectural Kata is...

Going Going Gone!
An auction company wants to take their auctions online to a nationwide scale--customers choose the
auction to participate in, wait until the auction begins, then bid during the live auction as if they were
there in the room, with the auctioneer.
 • Users: scale up to hundreds of participants (per auction), potentially up to thousands of
   participants, and as many simultaneous auctions as possible
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
An auction company wants to take their auctions online to a nationwide scale--customers choose the
auction to participate in, wait until the auction begins, then bid during the live auction as if they were
there in the room, with the auctioneer.
 • Users: scale up to hundreds of participants (per auction), potentially up to thousands of
   participants, and as many simultaneous auctions as possible
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
An auction company wants to take their auctions online to a nationwide scale--customers choose the
auction to participate in, wait until the auction begins, then bid during the live auction as if they were
there in the room, with the auctioneer.
 • Users: scale up to hundreds of participants (per auction), potentially up to thousands of
   participants, and as many simultaneous auctions as possible
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

  availability reliability performance
Your Architectural Kata is...

Going Going Gone!
                                                                       ?
An auction company wants to take their auctions online to a nationwide scale--customers choose the

                                                                                                             ?
auction to participate in, wait until the auction begins, then bid during the live auction as if they were
there in the room, with the auctioneer.
 • Users: scale up to hundreds of participants (per auction), potentially up to thousands of
   participants, and as many simultaneous auctions as possible
 • Requirements:
    ◦ bidders can see a live video stream of the auction and see all bids as they occur
    ◦ auctions must be as real-time as possible
    ◦ both online and live bids must be received in the order in which they are placed
    ◦ bidders register with credit card; system automatically charges card if bidder wins
    ◦ participants must be tracked via a reputation index
 • Additional Context:                                                                    ?
    ◦ auction company is expanding aggressively by merging with smaller competitors
    ◦ if nationwide auction is a success, replicate the model overseas
    ◦ budget is not constrained--this is a strategic direction
    ◦ company just exited a lawsuit where they settled a suit alleging fraud

  availability reliability performance
Your Architectural Kata is...

Going Going Gone!
An auction company wants to take their auctions online to a nationwide scale--customers choose the
auction to participate in, wait until the auction begins, then bid during the live auction as if they were
there in the room, with the auctioneer.
 • Users: scale up to hundreds of participants (per auction), potentially up to thousands of
   participants, and as many simultaneous auctions as possible
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

  availability reliability performance                  scalability
Your Architectural Kata is...

Going Going Gone!
An auction company wants to take their auctions online to a nationwide scale--customers choose the
auction to participate in, wait until the auction begins, then bid during the live auction as if they were
there in the room, with the auctioneer.
 • Users: scale up to hundreds of participants (per auction), potentially up to thousands of
                                                                                                             ?
   participants, and as many simultaneous auctions as possible
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

  availability reliability performance                  scalability
Your Architectural Kata is...

Going Going Gone!
An auction company wants to take their auctions online to a nationwide scale--customers choose the
auction to participate in, wait until the auction begins, then bid during the live auction as if they were
there in the room, with the auctioneer.
 • Users: scale up to hundreds of participants (per auction), potentially up to thousands of
   participants, and as many simultaneous auctions as possible
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

  availability reliability performance                  scalability elasticity
scalability:




users




        time
elasticity:




users




        time
Your Architectural Kata is...

Going Going Gone!
An auction company wants to take their auctions online to a nationwide scale--customers choose the
auction to participate in, wait until the auction begins, then bid during the live auction as if they were
there in the room, with the auctioneer.
 • Users: scale up to hundreds of participants (per auction), potentially up to thousands of
   participants, and as many simultaneous auctions as possible
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

  availability reliability performance                  scalability elasticity
Your Architectural Kata is...

Going Going Gone!
An auction company wants to take their auctions online to a nationwide scale--customers choose the
auction to participate in, wait until the auction begins, then bid during the live auction as if they were
there in the room, with the auctioneer.
 • Users: scale up to hundreds of participants (per auction), potentially up to thousands of
   participants, and as many simultaneous auctions as possible
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

  availability reliability performance                  scalability elasticity
Your Architectural Kata is...

Going Going Gone!
An auction company wants to take their auctions online to a nationwide scale--customers choose the
auction to participate in, wait until the auction begins, then bid during the live auction as if they were
there in the room, with the auctioneer.
 • Users: scale up to hundreds of participants (per auction), potentially up to thousands of
   participants, and as many simultaneous auctions as possible
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

  availability reliability performance                  scalability elasticity (security)
Your Architectural Kata is...

Going Going Gone!
An auction company wants to take their auctions online to a nationwide scale--customers choose the
auction to participate in, wait until the auction begins, then bid during the live auction as if they were
there in the room, with the auctioneer.
 • Users: scale up to hundreds of participants (per auction), potentially up to thousands of
   participants, and as many simultaneous auctions as possible
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

  availability reliability performance                  scalability elasticity (security)
Your Architectural Kata is...

Going Going Gone!
An auction company wants to take their auctions online to a nationwide scale--customers choose the
auction to participate in, wait until the auction begins, then bid during the live auction as if they were
there in the room, with the auctioneer.
 • Users: scale up to hundreds of participants (per auction), potentially up to thousands of
   participants, and as many simultaneous auctions as possible
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

  availability reliability performance                  scalability elasticity (security)
Your Architectural Kata is...

Going Going Gone!
An auction company wants to take their auctions online to a nationwide scale--customers choose the
auction to participate in, wait until the auction begins, then bid during the live auction as if they were
there in the room, with the auctioneer.
 • Users: scale up to hundreds of participants (per auction), potentially up to thousands of
   participants, and as many simultaneous auctions as possible
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
                                                                                         concurrency

  availability reliability performance                  scalability elasticity (security)
Your Architectural Kata is...

Going Going Gone!
An auction company wants to take their auctions online to a nationwide scale--customers choose the
auction to participate in, wait until the auction begins, then bid during the live auction as if they were
there in the room, with the auctioneer.
 • Users: scale up to hundreds of participants (per auction), potentially up to thousands of
   participants, and as many simultaneous auctions as possible
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
                                                                                         concurrency

  availability reliability performance                  scalability elasticity (security)
component identification
Your Architectural Kata is...

Going Going Gone!
An auction company wants to take their auctions online to a nationwide scale--customers choose the
auction to participate in, wait until the auction begins, then bid during the live auction as if they were
there in the room, with the auctioneer.
 • Users: scale up to hundreds of participants (per auction), potentially up to thousands of
   participants, and as many simultaneous auctions as possible
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




           auction              auction     auction           video         bid
           creator              browser   registration      streamer      capture
Your Architectural Kata is...

Going Going Gone!
                          actor/action approach


             bidder              auctioneer       system
Your Architectural Kata is...

Going Going Gone!
                          actor/action approach


             bidder              auctioneer       system




      view live video stream
       view live bid stream
           place a bid
Your Architectural Kata is...

Going Going Gone!
                          actor/action approach


             bidder                   auctioneer              system




      view live video stream    enter live bids into system
       view live bid stream        receive online bid
           place a bid             mark item as sold
Your Architectural Kata is...

Going Going Gone!
                          actor/action approach


             bidder                   auctioneer                    system




      view live video stream    enter live bids into system      start auction
       view live bid stream        receive online bid           make payment
           place a bid             mark item as sold          track bidder activity
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


               receive online bid                                                online bid
                                                                                  capture
               enter live bids into system
  auctioneer   mark item as sold                              auctioneer
                                                               capture
                                             auction
               start auction                 session
               make payment
    system     track bidder activity                                         bidder
                                                                             tracker
                                                         auto
                                                       payment
Your Architectural Kata is...

Going Going Gone!

                   auctioneer                   bidder




        auction            auctioneer                       bid      video
        session              capture      online bid     streamer   streamer
                                           capture


                                bidder
                                tracker


         auto
        payment
Your Architectural Kata is...

Going Going Gone!

                   auctioneer                   bidder




        auction            auctioneer                       bid      video
        session              capture      online bid     streamer   streamer
                                           capture


                                bidder
                                tracker


         auto
        payment
Your Architectural Kata is...

Going Going Gone!

                   auctioneer                   bidder




        auction            auctioneer                       bid      video
        session              capture      online bid     streamer   streamer
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
Judges Criteria
Clarity of
narrative,
organization,
and supporting
documentation
Narrative and Organization
A narrative tells the story of the architectural solution
Narrative and Organization
  A narrative arc a literary term for the path a story
 follows. It provides a backbone by providing a clear
       beginning, middle, and end of the story
https://github.com/TheJedis2020/arch_katas_2020
https://github.com/miyagis-forests/
         farmacy-food-kata
https://github.com/lookfwd/archkata
Completeness of
solution
Completeness of Solution
Identification of
supporting
architecture
characteristics
    Architecture Characteristics
Architecture characteristics form the foundational aspects of the
 architecture and are required for proper trade-off analysis and
                        decision making


                                           Scope

                                           Justification
https://www.developertoarchitect.com/downloads/worksheets.html
  https://www.developertoarchitect.com/lessons/lesson112.html
Diagrams –
types, level of
detail, and
completeness
                        Diagrams
An effective architecture picture is worth more than a 1,000 words.
   Architecture represents topology, which benefits from visual
                          representations.


                         “The goal of a diagram is to
                         convey a clear and shared
                         understanding of the
                         architecture”
                                             - Neal Ford
                            Diagrams
An effective architecture picture is worth more than a 1,000 words.
   Architecture represents topology, which benefits from visual
                          representations.




       component diagrams                context diagrams
                          Diagrams
An effective architecture picture is worth more than a 1,000 words.
   Architecture represents topology, which benefits from visual
                          representations.




       user journey diagrams             sequence diagrams
                             Diagrams
An effective architecture picture is worth more than a 1,000 words.
   Architecture represents topology, which benefits from visual
                          representations.




     system-level diagrams            deployment diagrams
                        Diagrams
An effective architecture picture is worth more than a 1,000 words.
   Architecture represents topology, which benefits from visual
                          representations.




                        user interface mockups
Behavior
Architecture
decision
records –
documentation
and justification
    Second Law of
Software Architecture

    “Why is more
 important then how”
          architecture decision records
                  short text file; 1-2 pages long, one file per decision
                  markdown, textile, asciidoc, plaintext, etc.
# Title
                           short noun phrase
## Status
…                          proposed, accepted, superseded

## Context                 description of the problem and alternative
…
                           solutions available (documentation)
## Decision
…
                           decision and justification (the “why”)
## Consequences
…                          trade-offs and impact of decision
architecture decision records
                  architecture decision records
ADR 001: Use the microservice architecture style with containerization
Farmacy Food is a start up company and does not have a sizeable team of experienced developers
available. The overarching architecture style for the Farmacy Food system should be simple, easy to
create, maintain and evolve. Finding developers that can create and evolve the system, as well as tools
and frameworks that support the system should not require heaps of money. In other words, Farmacy
Food is not in a position to be an early adopter, and should hence adopt an established architecture style
that supports evolution.
                    architecture decision records
ADR_004 Use a centralized notification for external communication

Context
There was some confusion around the purpose of the notification component. Specifically, is this component
an event bus for all communication or is it a shared component for communicating externally.

Decision
We decided to have a dedicated notification system responsible of sending external notification. The reasons
include:
Overall
solution
            Overall Solution
The architecture solution describes the overall structure
     of the system and how it will be constructed

                         Are the architecture characteristics demonstrated
                         in the solution?

                         Is the solution appropriate and feasible given
                         the project constraints?

                         Are the architecture styles selected represented
                         in the solution?
Integration

Feasibility
Agility

Availability

Security

Scalability
Final
architecture
presentation
(semi-finalist)
The Business
Problem
                                     MonitorMe
StayHealthy, Inc. is a large and highly successful medical software company located in San Francisco,
California, US. They currently have 2 popular cloud-based SAAS products: MonitorThem and
MyMedicalData.
                                     MonitorMe
StayHealthy, Inc. is a large and highly successful medical software company located in San Francisco,
California, US. They currently have 2 popular cloud-based SAAS products: MonitorThem and
MyMedicalData.

MonitorThem a comprehensive data analytics platform that is used for hospital trend and performance
analytics—alert response times, patient health problem analytics, patient recovery analysis, and so on.
                                     MonitorMe
StayHealthy, Inc. is a large and highly successful medical software company located in San Francisco,
California, US. They currently have 2 popular cloud-based SAAS products: MonitorThem and
MyMedicalData.

MonitorThem a comprehensive data analytics platform that is used for hospital trend and performance
analytics—alert response times, patient health problem analytics, patient recovery analysis, and so on.

MyMedicalData is a comprehensive cloud-based patient medical records system used by doctors,
nurses, and other heath professionals to record and track a patients heath records with guaranteed
partitioning between patient records.
                                     MonitorMe
StayHealthy, Inc. is a large and highly successful medical software company located in San Francisco,
California, US. They currently have 2 popular cloud-based SAAS products: MonitorThem and
MyMedicalData.

MonitorThem a comprehensive data analytics platform that is used for hospital trend and performance
analytics—alert response times, patient health problem analytics, patient recovery analysis, and so on.

MyMedicalData is a comprehensive cloud-based patient medical records system used by doctors,
nurses, and other heath professionals to record and track a patients heath records with guaranteed
partitioning between patient records.

StayHealthy, Inc. is now expanding into the medical monitoring market, and is in need of a new medical
patient monitoring system for hospitals that monitors a patients vital signs using proprietary medical
monitoring devices built by StayHealthy, Inc.
                                          MonitorMe
Requirements
  • MonitorMe reads data from eight different patient-monitoring equipment vital sign input sources: heart rate,
   blood pressure, oxygen level, blood sugar, respiration rate, electrocardiogram (ECG), body temperature, and
   sleep status (sleep or awake). It then sends the data to a consolidated monitoring screen (per nurses station)
   with an average response time of 1 second or less. The consolidated monitoring screen displays each patients
   vital signs, rotating between patients every 5 seconds. There is a maximum of 20 patients per nurses station.
                                            MonitorMe
Requirements
  • MonitorMe reads data from eight different patient-monitoring equipment vital sign input sources: heart rate,
   blood pressure, oxygen level, blood sugar, respiration rate, electrocardiogram (ECG), body temperature, and
   sleep status (sleep or awake). It then sends the data to a consolidated monitoring screen (per nurses station)
   with an average response time of 1 second or less. The consolidated monitoring screen displays each patients
   vital signs, rotating between patients every 5 seconds. There is a maximum of 20 patients per nurses station.

  • For each vital sign, MonitorMe must record and store the past 24 hours of all vital sign readings. A medical
   professional can review this history, filtering on time range as well as vital sign.
                                            MonitorMe
Requirements
  • MonitorMe reads data from eight different patient-monitoring equipment vital sign input sources: heart rate,
   blood pressure, oxygen level, blood sugar, respiration rate, electrocardiogram (ECG), body temperature, and
   sleep status (sleep or awake). It then sends the data to a consolidated monitoring screen (per nurses station)
   with an average response time of 1 second or less. The consolidated monitoring screen displays each patients
   vital signs, rotating between patients every 5 seconds. There is a maximum of 20 patients per nurses station.

  • For each vital sign, MonitorMe must record and store the past 24 hours of all vital sign readings. A medical
   professional can review this history, filtering on time range as well as vital sign.

  • In addition to recording raw monitoring data, the MonitorMe software must also analyze each patient’s vital
   signs and alert a medical professional if it detects an issue (e.g., decrease in oxygen level) or reaches a preset
   threshold (e.g., temperature has reached 104 degrees F).
                                            MonitorMe
Requirements
  • MonitorMe reads data from eight different patient-monitoring equipment vital sign input sources: heart rate,
   blood pressure, oxygen level, blood sugar, respiration rate, electrocardiogram (ECG), body temperature, and
   sleep status (sleep or awake). It then sends the data to a consolidated monitoring screen (per nurses station)
   with an average response time of 1 second or less. The consolidated monitoring screen displays each patients
   vital signs, rotating between patients every 5 seconds. There is a maximum of 20 patients per nurses station.

  • For each vital sign, MonitorMe must record and store the past 24 hours of all vital sign readings. A medical
   professional can review this history, filtering on time range as well as vital sign.

  • In addition to recording raw monitoring data, the MonitorMe software must also analyze each patient’s vital
   signs and alert a medical professional if it detects an issue (e.g., decrease in oxygen level) or reaches a preset
   threshold (e.g., temperature has reached 104 degrees F).

  • Some trend and threshold analysis is dependent on whether the patient is awake or asleep. For example, if
   the blood pressure drops, the system should notice that the patient is asleep and adjust its alerts accordingly.
   The same is true with the respiration rate and heart rate. For example, all of these vital signs are reduced
   when the patient is asleep, but if awake something might be wrong.
                                          MonitorMe
Requirements (cont.)

  • Medical professionals receive alert push notifications of a potential problem based on raw data analysis to a
    StayHeathy mobile app on their smart phone as well as the consolidated monitoring screen in each nurses
    station.
                                             MonitorMe
Requirements (cont.)

  • Medical professionals receive alert push notifications of a potential problem based on raw data analysis to a
    StayHeathy mobile app on their smart phone as well as the consolidated monitoring screen in each nurses
    station.

  • If any of vital sign device (or software) fails, MonitorMe must still function for other vital sign monitoring
    (monitor, record, analyze, and alert).
                                             MonitorMe
Requirements (cont.)

  • Medical professionals receive alert push notifications of a potential problem based on raw data analysis to a
    StayHeathy mobile app on their smart phone as well as the consolidated monitoring screen in each nurses
    station.

  • If any of vital sign device (or software) fails, MonitorMe must still function for other vital sign monitoring
    (monitor, record, analyze, and alert).

  • Medical staff can generate holistic snapshots from a patients consolidated vital signs at any time. Medical staff
    can then upload the patient snapshot to MyMedicalData. The upload functionality is within the scope of the
    MonitorMe functionality and is done through a secure HTTP API call within MyMedicalData.
                                           MonitorMe
Requirements (cont.)
  • Each patient monitoring device transmits vital sign readings at a different rate:
    Heart rate: every 500ms
    Blood pressure: every hour
    Oxygen level: every 5 seconds
    Blood sugar: every 2 minutes
    Respiration: every second
    ECG: every second
    Body temperature: every 5 minutes
    Sleep status: every 2 minutes
                                           MonitorMe
Requirements (cont.)
  • Each patient monitoring device transmits vital sign readings at a different rate:
    Heart rate: every 500ms
    Blood pressure: every hour
    Oxygen level: every 5 seconds
    Blood sugar: every 2 minutes
    Respiration: every second
    ECG: every second
    Body temperature: every 5 minutes
    Sleep status: every 2 minutes

  • MonitorMe will be deployed as an on-premises system. Each physical hospital location will have its own
    installation of the complete MonitorMe system (including the recorded raw monitoring data).
                                           MonitorMe
Requirements (cont.)
  • Each patient monitoring device transmits vital sign readings at a different rate:
    Heart rate: every 500ms
    Blood pressure: every hour
    Oxygen level: every 5 seconds
    Blood sugar: every 2 minutes
    Respiration: every second
    ECG: every second
    Body temperature: every 5 minutes
    Sleep status: every 2 minutes

  • MonitorMe will be deployed as an on-premises system. Each physical hospital location will have its own
    installation of the complete MonitorMe system (including the recorded raw monitoring data).

  • Maximum number of patients per physical MonitorMe instance: 500
                                           MonitorMe
Requirements (cont.)
  • Each patient monitoring device transmits vital sign readings at a different rate:
    Heart rate: every 500ms
    Blood pressure: every hour
    Oxygen level: every 5 seconds
    Blood sugar: every 2 minutes
    Respiration: every second
    ECG: every second
    Body temperature: every 5 minutes
    Sleep status: every 2 minutes

  • MonitorMe will be deployed as an on-premises system. Each physical hospital location will have its own
    installation of the complete MonitorMe system (including the recorded raw monitoring data).

  • Maximum number of patients per physical MonitorMe instance: 500
  • StayHealthy. Inc. will be providing a comprehensive hardware and software for this system. The platform, data
    stores, databases, and other technical tools and products are unspecified at this time and will be based on your
    on-prem architectural solution.
                                           MonitorMe
Other Considerations

  • StayHealthy, Inc. is looking towards adding more vital sign monitoring devices for MonitorMe in the future.
                                           MonitorMe
Other Considerations

  • StayHealthy, Inc. is looking towards adding more vital sign monitoring devices for MonitorMe in the future.
  • Vital sign data analyzed and recorded through MonitorMe must be as accurate as possible. After all, human
   lives are at stake.
                                           MonitorMe
Other Considerations

  • StayHealthy, Inc. is looking towards adding more vital sign monitoring devices for MonitorMe in the future.
  • Vital sign data analyzed and recorded through MonitorMe must be as accurate as possible. After all, human
   lives are at stake.

  • As this is a new line of business for StayHealthy, they expect a lot of change as they learn more about this
   new market.
                                           MonitorMe
Other Considerations

  • StayHealthy, Inc. is looking towards adding more vital sign monitoring devices for MonitorMe in the future.
  • Vital sign data analyzed and recorded through MonitorMe must be as accurate as possible. After all, human
   lives are at stake.

  • As this is a new line of business for StayHealthy, they expect a lot of change as they learn more about this
   new market.

  • StayHealthy, Inc. has always taken patient confidentially seriously. MonitorMe should be no exception to this
   rule. While patient monitoring data must be secure, MonitorMe does not have to meet any government
   regulatory requirements (e.g., HIPPA).
Contest Details
                     Dates
• All teams must submit this Google Form
  (https://forms.gle/6ESA49iD8VW6AskQ9) by
  Thursday, February 22 at 11:59pm Eastern to
  participate

• Solutions are due in your GitHub repo by Thursday,
  February 22, 11:59PM Eastern

• Semifinalists will be announced at the second event on
  Monday, March 4

• Questions? Email us at katas@oreilly.com
Architecture Katas
Private Event February 2024

         Neal Ford
         Thoughtworks
         Director / Software Architect / Meme Wrangler
         https://www.nealford.com


        Mark Richards
    NFJS Software Symposium Series 2016
        Independent Consultant
        Hands-on Software Architect, Published Author
        Founder, DeveloperToArchitect.com

                                                         Contest Kickoff
        @markrichardssa
