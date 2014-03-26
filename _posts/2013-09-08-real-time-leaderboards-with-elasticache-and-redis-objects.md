---
layout: post
title: Real-time Leaderboards with ElastiCache and Redis Objects
disqus_identifier: 0f7795f4-19bd-4ceb-86c1-8b03f281de19
tags:
- ruby
- redis
- aws
- programming
- gaming
---

With the launch of [AWS ElastiCache for Redis this week](http://aws.typepad.com/aws/2013/09/amazon-elasticache-now-with-a-dash-of-redis.html), I realized my [redis-objects gem](http://github.com/nateware/redis-objects) could
use a few more examples.  Paste this code into your game's Ruby backend for real-time leaderboards
with Redis.
<!--more-->
[Redis Sorted Sets](http://redis.io/topics/data-types) are the ideal data type for leaderboards.
This is a data structure that guarantees uniqueness of members, plus keeps members sorted in real time.
Yep that's pretty much exactly what we want.  The Redis sorted set commands to populate a leaderboard would be:

    ZADD leaderboard 556  "Andy"
    ZADD leaderboard 819  "Barry"
    ZADD leaderboard 105  "Carl"
    ZADD leaderboard 1312 "Derek"

This would create a `leaderboard` set with members auto-sorted based on their score.
To get a leaderboard sorted with highest score as highest ranked, do:

    ZREVRANGE leaderboard 0 -1
    1) "Derek"
    2) "Barry"
    3) "Andy"
    4) "Carl"

This returns the set's members sorted in reverse (descending) order.  Refer to the
[Redis docs for ZREVRANGE](http://redis.io/commands/zrevrange) for more details.

Wasn't this a Ruby post?
------------------------
Back to [redis-objects](http://github.com/nateware/redis-objects). Let's start with
a direct Ruby translation of the above:

{% highlight ruby %}
require 'redis-objects'
Redis.current = Redis.new(host: 'localhost')

lb = Redis::SortedSet.new('leaderboard')
lb["Andy"]  = 556
lb["Barry"] = 819
lb["Carl"]  = 105
lb["Derek"] = 1312

puts lb.revrange(0, -1)  # ["Derek", "Barry", "Andy", "Carl"]
{% endhighlight %}

And... we're done.  Ship it.

Throw that on Rails
-------------------
Ok, so our game probably has a bit more too it.  Let's assume there's a `User` database
table, with a `score` column, created like so:

{% highlight ruby %}
class CreateUsers < ActiveRecord::Migration
  def up
    create_table :users do |t|
      t.string  :name
      t.integer :score
    end
  end
end
{% endhighlight %}

We can integrate a sorted set leaderboard with our `User` model in two lines:

{% highlight ruby %}
class User < ActiveRecord::Base
  include Redis::Objects
  sorted_set :leaderboard, global: true
end
{% endhighlight %}

Since we're going to have just a single leaderboard (rather than one per user),
we use the `global` flag. This will create a `User.leaderboard` sorted set that
we can then access anywhere:

{% highlight ruby %}
puts User.leaderboard.members
{% endhighlight %}

(**Important:** This _doesn't_ have to be ActiveRecord &mdash;
you could use Mongoid or DataMapper or Sequel or Dynamoid or any other DB model.)

We'll add a hook to update our leaderboard when we get a new high score.
Since we now have a database table, we'll index our sorted set by our ID, since
it's guaranteed to be unique:

{% highlight ruby %}
class User < ActiveRecord::Base
  include Redis::Objects
  sorted_set :leaderboard, global: true

  after_update :update_leaderboard
  def update_leaderboard
    self.class.leaderboard[id] = score
  end
end
{% endhighlight %}

Save a few records:

{% highlight ruby %}
User.create!(name: "Andy",  score: 556)
User.create!(name: "Barry", score: 819)
User.create!(name: "Carl",  score: 105)
User.create!(name: "Derek", score: 1312)
{% endhighlight %}

Fetch the leaderboard:

{% highlight ruby %}
@user_ids = User.leaderboard.revrange(0, -1)
puts @user_ids  # [4, 2, 1, 3]
{% endhighlight %}

And now we have a Redis leaderboard sorted in real time, auto-updated any time we
get a new high score.

But MySQL has ORDER BY
----------------------
The skeptical reader may wonder why not just sort in MySQL, or whatever the kewl new
database flavor of the week is. Outside of offloading our main database, things get
more interesting when we want to know our own rank:

{% highlight ruby %}
class User < ActiveRecord::Base
  # ... other stuff remains ...

  def my_rank
    self.class.leaderboard.revrank(id) + 1
  end
end
{% endhighlight %}

Then:

{% highlight ruby %}
@user = User.find(1) # Andy
puts @user.my_rank   # 3
{% endhighlight %}

Getting a numeric rank for a row in MySQL would require adding a new "rank" column, and then
running a job that re-ranks the entire table.  Doing this in real time means clobbering MySQL
with a global re-rank every time _anyone's_ score changes.  This makes MySQL unhappy, especially
with lots of users.

Kids are calling so that's all for now.  Enjoy!

