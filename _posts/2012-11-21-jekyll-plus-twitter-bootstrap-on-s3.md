---
layout: post
title: Jekyll Plus Twitter Bootstrap on S3
tags:
- ruby
- jekyll
- s3
- twitter
- webdesign
---

I've decided that modern web development is largely a test of your
personal pain threshold.  My blog redesign goals seemed reasonable: A
responsive, mobile-friendly page layout, easily searchable by Google,
that could be edited locally and then pushed to a hosting service.
At times it felt like I was building the Curiosity Rover II.
<!--more-->
My main goal was to create a responsive page design that would work
equally well on laptops, iPhones, iPads, Kindles, and so on.  When I'm reading
on an iWhatever, it drives me nuts when I hit a blog with 10pt font that
I have to pinch in and swipe back and forth to read.  But creating a fluid
layout isn't as easy as just shrinking things; you need to reshuffle the layout,
[as this excellent slide deck highlights](http://johnpolacek.github.com/scrolldeck.js/decks/responsive/).

So after a good amount of brain stuffing on responsive design, I settled on
the following packages to make this all happen:

* [Jekyll](https://github.com/mojombo/jekyll), the gold standard for static blogs
* [Twitter Bootstrap](http://twitter.github.com/bootstrap/) to enable a responsive design
* [Google Custom Search](http://www.google.com/cse/docs/) to power the "Search" bar
* [The "Readability" Standard](http://www.readability.com/developers/guidelines) for the article HTML structure
* [Fairhead Webicons](http://www.zurb.com/playground/social-webicons) for social and sharing bits
* [Disqus](http://disqus.com/for-websites/) to handle comments
* [Jammit](https://github.com/documentcloud/jammit) to compress JavaScript and CSS assets
* [S3](http://aws.amazon.com/s3/) and [CloudFront](http://aws.amazon.com/cloudfront/) to host everything

Some of these worked great. Others made me want to club a baby seal.

Punchline
---------

Here's a comparison of my finished blog layout on a laptop:

{% image_tag layout-laptop-full.png, 'Laptop layout - full page', :width => '90%' %}

And on a mobile device:

{% image_tag layout-mobile-top.png, 'Mobile layout - top', :width => '45%', :class => 'pull-left' %}
{% image_tag layout-mobile-bottom.png, 'Mobile layout - bottom', :width => '45%', :class => 'pull-left clearfix' %}

On smaller screens, notice how the search bar remains up-top, under the title.
My bio, on the other hand, shifts all the way to the bottom, after the article.
I wanted people to hit my content first, and then my smiling face _after_ they
had read the article, so they could look at it with either adoration or disgust.

If we breakdown

Here's my core page structure:

    <div class="row-fluid" id="topbar">
      <div class="span6" id="blogname">
        <a class="brand" href="/">{{ site.title }}</a>
        <em>{{ site.subtitle }}</em>
      </div>
      <div class="span6" id="searchbox">
        <!-- Google custom search box -->
        <gcse:searchbox></gcse:searchbox>
      </div>
    </div>
    <div id="searchresults">
      <!-- Google custom search result -->
      <gcse:searchresults></gcse:searchresults> 
    </div>
    <div class="row-fluid">
      <div class="span9">
        <div class="index-content">
          <!-- Article or post list -->
          {{content}}
        </div>
        <div id="powered-by">
          Powered by Jekyll + Twitter Bootstrap deployed to S3.
        </div>
      </div>
      <div class="span3">
        {% include sidebar.html %}
      </div>
    </div>

http://blog.teamtreehouse.com/beginners-guide-to-responsive-web-design



Twitter Bootstrap was the real enabling tech here






Other Cool Resources
--------------------

* [Colour Lovers](http://www.colourlovers.com/) - great color resource for the pallette impaired
* [Responsiveness tester](http://mattkersley.com/responsive/) - see how your website behaves (or doesn't)
* [Comparison of asset packers](http://www.askapache.com/software/online-compression-tool-compares-packer-jsmin-dojo-and-yui-compressor.html) - jsmin, packer, yui, gzip
* [Common responsive design mistakes](http://css-tricks.com/notes-agency-starting-their-first-responsive-web-project/) - emphasizing the "mobile-first" approach






