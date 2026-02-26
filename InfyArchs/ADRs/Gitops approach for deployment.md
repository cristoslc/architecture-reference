# Gitops approach for deployment

## Status
ACCEPTED

## Context
Application level changes should be rolled out across all environments including IOT devices faster.

## Decision
In a standard Continous Deployment model, the application artifacts which are available centrally then pushed to the target environment for deployment. As long as the environment count is small this standard model works fine. However when the number of environments in which the code needs to be deployed increases then this standard deployment model is not an optimal approach as here we are relying on one central tool to push to changes to different environments.

Instead of this push based model, we have to switch to a pull based model where we will enable the environments to keep its state in sync with the central source if truth (git in this case). So we choose to use Gitops as an approach for continous deployment across all environments. The environments will be able to assess its state by comparing it with a source of truth and whenever the source changes the environments reacts to it by syncronizing the deployments.

There are many tools available to for continuous deployments using Gitops approach like ***ArgoCD***, ***Flux*** and ***Jenkins X*** etc.

We have decided to use [ArgoCD](https://argo-cd.readthedocs.io/en/stable/) for continuous deployment following gitops approach. The ***ArgoCD*** agent running on the environment will keep polling a git repository and sync whenever the desired state changes in the git repository. 

We decided to use ***ArgoCD*** over other tools due to following reasons,
- CNCF Graduated project.
- Better user experience and UI.
- Focus more on developer experience.

## Consequences
New changes are published faster to all environments allowing the ***MonitorMe*** team to adapt to changes much quickly.
