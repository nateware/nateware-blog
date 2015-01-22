---
layout: post
title: Game Analytics with AWS at GDC 2014
disqus_identifier: 950dd60a-d32b-4383-8f71-6e5e413766e9
tags:
- aws
- gaming
- analytics
- redshift
- kinesis
- bigdata
- mapreduce
---

I gave a talk at GDC 2014 all about game analytics and AWS. In the talk, I showed how to start
small by uploading analytics files from users devices to S3, and then processing them with
Redshift.  As your game grows, add more data sources and AWS services such as Kinesis
and Elastic MapReduce to perform more complex processing.
Here are <a href="http://www.slideshare.net/slideshow/embed_code/32592688">the slides on Slideshare</a>
and <a href="http://aws.amazon.com/game-hosting/GDC2014-videos/">the videos on YouTube</a>.
<!--more-->
<iframe src="http://www.slideshare.net/slideshow/embed_code/32592688" width="597" height="486" frameborder="0" marginwidth="0" marginheight="0" scrolling="no" style="border:1px solid #CCC; border-width:1px 1px 0; margin-bottom:5px; max-width: 100%;" allowfullscreen="allowfullscreen">Game Analytics with AWS</iframe>

Free-to-play has become a ubiquitous strategy for publishing
games, especially mobile and social games.  Succeeding in free-to-play requires having razor-sharp
analytics on your players, so you know what they love and what they hate.
Free-to-play aside, having an awesome game has always been about maximizing the love and
minimizing the hate. Charge a reasonable price for the things your players love and you
have a simple but effective monetization strategy.

At the end of the talk, I blabbed a bit about what I see as the future of gaming: Big data
and real-time analytics.   The more in-tune you can get with your players, and the faster
you can react, the more your game is going to differentiate itself.  Recently there was
a massive battle in [EVE Online](http://www.eveonline.com/) that
[destroyed nearly $500,000 worth of ships and equipment](http://bigstory.ap.org/article/unpaid-bill-leads-game-battle-worth-200000).
Imagine being able to react in real-time, in the heat of battle, offering players discounted
ammunition targeted at their fleet and status in battle.  Some
[estimate impulse buys to account for 40% of all ecommerce](http://blog.eyesurf.info/?p=2727)
meaning there is huge untapped potential for gaming in the analytics space.
