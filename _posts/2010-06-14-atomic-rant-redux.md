---
layout: post
title: Atomic Rant Redux
disqus_identifier: d509fb43-01b1-4851-8671-bc7be95b3ea5
tags:
- ruby
- redis
- failure
published: true
---
My [atomic rant](an-atomic-rant.html) has gotten a ton of traffic
- more than I forsaw.  Seems atomicity is a hot topic in the web world these days.
Increasing user concurrency, coupled with more interactive apps, exposes all sorts of edge cases.
I wanted to write a follow-up post to step back and look at a few more high-level concerns with
atomicity, as well as some Redis-specific issues we've seen.
<!--more-->

Know Your Actors
----------------
<img align="left" title="The most amazing actors EVER" src="/images/new-moon-official-cast.jpg"
alt="The most amazing actors EVER" width="300" height="190" />
In my [original rant](an-atomic-rant.html), I used the example of students enrolling in online
classes to illustrate why atomicity was crucial to operations with multiple actors. And speaking
of actors, they're an even better <span style="text-decoration:line-through;">target</span>
analogy.  You need to assume your actors are all going to try to jam through the audition door at
the same time.  What happens if they are all talking to the director at once?  How many conversations
can continue in parallel?  If you're careful, you can get away with one final gate at the end, which
makes your life infinitely easier.  That is, funnel everyone to a decision point, congratulate one
person, then tell the others sorry.

Of course, if that funnel is too long, you're going to piss off your users in a major way.
<img src="/images/beerbongs.jpg?w=91" alt="Long long funnel" title="No I don't know these people - really"
width="91" height="150" align="right" />
If you've ever bought tickets from Ticketmaster, you're familiar with this problem.  Granted
they've gotten much better over the years (which is saying something...), and this is partially
due to embracing the Amazon
[guesses and apologies approach](http://blogs.msdn.com/b/pathelland/archive/2007/05/15/memories-guesses-and-apologies.aspx).
If you have 200 tickets left, a person can probably get one.  But if you have 10 tickets left, they're
probably going to get screwed.  If you can help with the user's expectations ("less than 10 tickets left!")
then people are more likely to be forgiving.

In the world of online games, this translates to showing players the number of slots left in a game, but then handing the situation where there were 2 slots left but you were the third person to hit <img class="alignnone size-full wp-image-93" title="X marks the spot" src="http://nateware.files.wordpress.com/2010/07/playstation-button-x.png" alt="X button" width="12" height="12" />.  You <strong>always</strong> need to handle these errors, because there's no way to completely eliminate race conditions in a networked application.

Recovering from Hiccups
-----------------------
<img title="Oopsie" align="left" src="/images/isharescapsize.jpg" alt="A boat upside-down"
width="300" height="232" />
Sooner or later, your slick, smooth-running atomic system is going to have problems.  Even if
it's well-engineered,  you could have a large outage such as a system crash, datacenter failure,
etc.  Plan on it.

Using Redis to offload atomic ops from the DB yielded big performance benefits, but added fragility.
You now have two systems that must stay in sync.  If either one crashes, there's the possibility
that you're going to have dangling locks for records that are ok, or vice-versa.  So you need a
way to clear them.  In a perfect world with infinite time, you'd be able to engineer a self-detecting,
self-repairing system that can auto-recover.  Good luck with that.  A cron job that deletes locks
older than a certain time works pretty well for the rest of us.

It's also a good idea to have a script you can run manually, in the event you know you need to reset
certain things.  For example, to handle the case where you know your Redis node went down, you could
have a script that deletes all locks where the ID is > the current max ID in the DB.  Oracle and
other systems have similar concepts built into their
[native locking procedures](http://download.oracle.com/docs/cd/B19306_01/appdev.102/b14258/d_lock.htm "How to release an Oracle lock")

Troubleshooting Redis is a Pain
-------------------------------
Unfortunately, Redis is lacking in the way of tools because it is still young.  There is the
PHP <a title="Redis Admin" href="http://code.google.com/p/redis-admin/">Redis Admin</a> app, but
its development appears to have stalled.  Beyond that it's pretty much roll-your-own-scripts at this point.
We've thought about developing a general-purpose Redis app/tool ourselves, but with the Redis 2.0
changes and [VMWare hiring Salvatore](http://antirez.com/post/vmware-the-new-redis-home.html "Antirez gets a job")
the tools side is a bit "wait and see".

So before you start throwing all of your critical data into Redis, realize it's a bit black-box
at this point (or at least, a really dark gray).  I'm not a GUI guy personally - I prefer
command-line tools due to my sysadmin days - but for many programmers, GUI tools help debugging
<em>a lot</em>.  You need to make sure your programmers working with Redis can debug it when you
have problems, which means a bigger investment in scripts vs. just downloading
[MySQL Workbench](http://wb.mysql.com/) or
[Oracle SQL Developer](http://www.oracle.com/technology/products/database/sql_developer/index.html)

Check and Double-Check
------------------------
<img align="right" title="Double check" src="/image/double-check.gif" alt="Double check" width="150"
height="86" />
The last thing worth mentioning is this: Don't trust your own app.  Even if you have an atomic gate
at the start of a transaction, do sanity checking at the end too.  There are a few reasons for this:

* The lock may have expired for some reason, and you didn't test for this
* Your locking server may have crashed when you're in the middle of a transaction
* There could be a background job overlapping with a front-end transaction
* Your software may have bugs (improbable, I know)

For example, we had a background job that was using the same lock as a front-end service.  This ended
up being a design mistake, but it was difficult to track down because it happened very infrequently.
The only way we found it was we had assertions that would get hit periodically on supposedly
impossible conditions.  Once we correlated the times with the background job running, we were able
to fix the issue rather quickly.

So my opinion is this: Try to do the right thing, but if it screws up, apologize to the user,
recover, and move on.
