---
title: It's OK to hardcode feature flags
description: The safest and most reliable way to deal with feature flags is to hardcode them
tags:
  - json
  - feature
  - complexity
  - safety
  - toggles

---

Feature flags (or toggles) are often used to control the visibility of new features in a product. There are a few different ways to implement them, but the most talked and marketed about is to use feature flag management software. The simplest way of course is to hardcode them, though it's the least written about. 

While feature flag management software _can_ be powerful, they are also a source of complexity and risk. The blogspam marketing behind them is so strong, that admitting they're unnecessary feels like confessing to technological impotence. We've convinced ourselves that we don't just need a few feature flags, we need to scale to thousands of feature flags. And not just that, but we will absolutely need to change a feature at runtime, and we absolutely must do it without a deployment, and without a restart, and without a cache flush, and without a database migration, and without a review, and without a test because the business is on fire and the only way to put it out is to change the color of the button on the homepage. 

The only flags that the capabilities of such a system should bring up are of the #ff0000 variety. From an architectural perspective, they are little more than glorified `if` statements, managed in a separate process. Often requiring their own infrastructure, hosting, monitoring, and all the responsibilities that come with. 

From a development lifecycle perspective, they introduce non-deterministic behaviour, and make it harder to reason about the code. Long lived feature flags, though initially well intentioned, lead to technical debt that ossifies the codebase; this risk does exist with hardcoded flags, but it's much easier to see and manage.

From a security perspective, they are a liability, as the surface area for attack or vulnerability has now increased. 

In any case, adding more moving parts to any software system should always be given scrutiny to see if it's actually necessary and whether the risks it introduces are worth the problems being solved.

Hardoced feature flags do away with many of these issues; they are simple, reliable, and safe. They are the most boring way to do it, and that's why they're the best way to do it.

Simply start with a simple JSON file, read it in at application startup, and use it to control the visibility of features. Keep on top of the flags, remove them when they're no longer needed. If they live too long, make them the actual behaviour and remove the flag. Change a value through the normal development process, get it reviewed, tested, and deployed.  

For most teams and products, this will often be good enough and will have a lot of mileage. When a team actually gets to the point of needing to change a feature at runtime at scale, then much like state management in SPAs, they'll know they need it. 

Premature optimization is not the way to go. It's bad design, bad engineering, and only serves well for brief moments of self-congratulatory smugness at tech conferences when the sales-speaker asks if anyone is using them.
