The Problem (Kata)

Wildlife Watcher
Wildlife.ai, a charity using AI to accelerate wildlife conservation, wants to build an open-source
wildlife camera that gets triggered based on the movement of target animals, identifies the species
on the device and reports the observation in near real-time to biologists, enabling more efficient
species conservation efforts worldwide.

Users: biologists and nature enthusiasts (hundreds/global).
Requirements:
   ● Users should be able to communicate with the camera using a mobile app (to set the
       cameras on/off and adjust settings without opening the cameras)
   ● Users should be able to analyse the videos using common camera trap labelling platforms
       (Wildlife Insights, TrapTagger or Trapper)
   ● Users should be able to publish frames from the videos to iNaturalist for experts to help with
       the identification of the species
   ● Users should be able to easily train edge models. using their own labelled videos, and
       upload the models to the cameras (using third party services like Roboflow, Edge Impulse or
       TensorFlow Lite)
   ● Users should be able to publish the species occurrences to GBIF the Camtrap DP, data
       exchange format
   ● Cameras should be able to process the footage on the device and send a small alert
       message to the users via LoraWan, 3G or satellite.

Additional Context
   ● The camera hardware will be a combination of ultra-low-power microcontrollers (up to 512KB
       Flash) and interchangeable modules (e.g. optical sensor, IR lights, transceiver module,
       batteries) enclosed in a watertight and 3D printed enclosure.
   ● An explanatory video of the prototype devices (Wētā Watchers)



About us
We are a charitable trust that uses artificial intelligence to accelerate wildlife conservation.

We work with grassroots wildlife conservation projects and develop open-source solutions using
machine learning.

We also organise community events, seminars and educational activities to build and maintain
machine learning solutions to reduce the current rate of species extinction.

Our purpose
To ensure artificial intelligence is widely applied to protect biodiversity.
