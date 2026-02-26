<img src="https://images.ctfassets.net/xwxknivhjv1b/5XnpSumu4KPOMxFVcnjko3/ac831641adf132a9550e5993028022a5/Icons.svg" align="right" height="64px" />

# Deployment 
In terms of deploying the MonitorMe system we need to consider that applications run on a custom infrastructure in an OnPremise server.
Given these constraints we have the following options 
- Update package with a suporting installer wizzard. Whenever a new version update is available, the Hospital Admin is notified. He then can use the wizzard to install the latest version of the system. The wizzard will need to update the Gatweays, On Premise containers (WebAPI, WebApp, Event messaging system)
- Container with necessary dependencies deployed on a container platform like Docker. The hospital admin would still be involved to install the new docker images. 
- Deployemnt pipeline. In case the hospitals are open to the idea of securing a communication channel between the software provider and them, an automated deployment pipeline can be used to deliver updates. Exiting configuration management tools like Ansible, Puppet, Chef can be  used to automate the deployment process on on-premises servers. This approach would enable us to deliver changes more frequently, but it requires availability on the hospital's side. 

Since the MonitorMe system will most likely be installed in several hospitals, we can acomodate several options for deployement.


The deployement of MobileApp update should be straight forward through mobile app stores. 
