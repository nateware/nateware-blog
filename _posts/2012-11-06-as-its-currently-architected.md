---
layout: post
title: I'm Coining a New Catchphrase
draft: true
tags:
- ruby
- redis
- programming
summary: "You saw it here first: &quot;as it's currently architected&quot;. It's like the oldie but goodie &quot;in bed&quot; - you can add it to any application requirements and it makes everything so much better."
---

How many times have you been on the giving or receiving end of requirements like these:

* Our web tier needs 2.5 GB of memory for cache
* Our app tier needs quad-core 2 GHz CPU's
* Our database needs to write 5000 records per second
* Our load balancer needs to handle 20,000 concurrent connections

These discussions usually suck.  IT starts by asking for "requirements", so developers try
to guess via benchmarks (often on an evolving product), then of course they pad a little
to make sure there's enough room for growth.  IT looks at the list and their eyes bug out,
so they suggest alternatives, but now the developers are invested in their benchmarks and
are _convinced_ they really do need those ridiculous specs, and generally everyone gets 
pissed off and heads to the bar.

Ok, the bar part is fun.  But I have beer at home.

I'm Nodding, Now What?
----------------------
Here's where my new phrase comes in.  It's oh-so-versatile that you can put it on
the beginning _or end_ of a sentence:

* Our web tier needs 2.5 GB of memory for cache, _as it's currently architected_
* _As it's currently architected_, our app tier needs quad-core 2 GHz CPU's
* Our database needs to write 5000 records per second, _as it's currently architected_
* _As it's currently architected_, our load balancer needs to handle 20,000 concurrent connections

Can't you just feel the tension decrease?  Now they're no longer absolute must-haves, but
a starting point for discussion.  Now you can look at options such as:

* What if you offloaded your web cache to memcache or [ElasticCache](http://aws.amazon.com/elasticache/)?
* What if you split apart your app tier workload based on functionality?
* Why do you hate your database?  Maybe you could use two (or more) handling different types of work?
* Ok, haproxy is pretty badass.  But a tier of 2-4 would give you redundancy and better load handling...

(BTW, you should read up on [haproxy's design decisions](http://haproxy.1wt.eu/#desi), it's really
a worthwhile read.)

Awesome Post, Nate, Thanks
--------------------------
I know, not earth-shattering, but try it out next time.  And if somebody comes to you with
"hard" requirements try it out on them:

> Thanks for the requirements.  _As it's currently architected_, your app tier
> needs quad-core GPU's, 20 GB of RAM, and 2 TB of disk.  Is it possible to
> decrease the memory by using an external cache or search app?

If you have a phrase you use, post it up - these types of situations are both frustrating
and fun to share (and learn from).





