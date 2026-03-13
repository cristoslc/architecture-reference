---
id: architecture-reference-repo-6me.2
status: closed
deps: []
links: []
created: 2026-03-06T22:17:48Z
type: task
priority: 2
---
# Design and test star-weighted production ranking

Design a weighting function based on GitHub stars for production-grade entries. Test candidates: linear stars, log(stars), star tiers, normalized percentiles. Compare unweighted vs star-weighted frequency tables. Reference entries carry zero weight. Key metrics: rank position changes >2, percentage changes >5 points, consistency with KataLog/AOSA.


