---
layout: page
title: About
date: 2012-12-27 09:14:11 +1100
comments: false
---

> A sleek, svelte and hackable blog engine
> Built with simplicity and speed in mind
> Designed to let you focus on writing

## Features

* Write posts in straight-up markdown (with yaml frontmatter for config)
* Uses git and heroku to make versioning and deployment dead simple
* Fast... Damn fast - and cached to make it almost as resilient as static site
* Supports future posting
* Supports a very large number of posts without performance degradation or pre-generation
* Robust archives in year, year/month, and year/month/day format
* Tagging
* Code highlighting with slick solarized theme
* Atom feed
* Google sitemap generator for search optimization
* Full timezone support for globetrotters
* Easy to migrate: Importer for wordpress and Jekyll posts work as-is
* Asset optimization
* Comments a la disqus
* Integrated and non-blocking twitter and flickr feeds
* Small, very tight code base &lt; 250 LOC

## Getting Started

Take a look in the git repo's
[README.md](https://github.com/tundramonkey/Kobayashi/blob/master/README.md)
for details.

## Rationale

There's a [more detailed blog post on why I wrote Kobayashi here](http://blog.tundramonkey.com/2012/07/20/the-tundramonkey-cometh)

Kobayashi arose through my frustration with wordpress and its security
and feature set and the simple desire for a ruby-based blog software
that was easily hackable where I felt there was no *de-facto* solution
in the community.

Additionally, while a lot of devs lean on static site generators
like Jekyll, eight years of blog posts meant that it would take an
unacceptably long time to generate my site. I needed something that
was really just a thin, fast layer of server around my written posts
with a bit of smarts thrown in and cached to the max to be super robust.

So, I borrowed the best ideas I could from other peoples' attempts, from
Jekyll to Serious to Toto, to buid my own and provide something fairly
feature rich but with a short, small and understandable (and commented!)
code base.

Kobayashi is the result. It's been running in production since mid-2012.

## Contributing

Pull requests gratefully accepted. Fork, put it in a separate branch,
write some tests and make the pull request. Boom!

Obviously, my forté is not designing, so any altruistic designer who
would like to contribute a default theme for Kobayashi, I'd love to hear
from you. Please ping me <span id="mail">simiam @ tundramonkey punto
com</span>.

## Contact

Email <span id="mail">simiam @ tundramonkey punto com</span> if
you need to get in touch.

<div id = "contact">
  <div class = "row">
    <div class = "span6">
      <div class = "btn"><i class="icon-github"></i> <a href="https://github.com/tundramonkey/kobayashi">Watch</a></div>
      <p>Github for code</p>
    </div>

    <div class = "span6">
      <div class = "btn"><i class="icon-twitter"></i> <a href="http://twitter.com/intent/user?screen_name=awws">Follow</a></div>
      <p>Twitter for status</p>
    </div>
  </div>
</div>

## ToDos

Push early, push often... And perfect is the enemy of better, so there's
still a few things I would've liked to have done before releasing.

1. Moar tests. MOAR!
2. Nicer default *responsive* html5 theme (if you're a designer and
would like to contribute one, please ping me.)
3. Write a nice rake script to do all initial setup on blog
4. Bit more refactoring into /lib classes
5. Heroku memcache add-on support
6. Cache warming full site on heroku push (to make it as robust as static site)

## Why the Name?

Kobayashi is actually a *double-entendre*.

On the one hand, Kobayashi was the lawyer of Keyser Soze, the criminal
mastermind in the awesome film [The Usual
Suspects](http://www.imdb.com/title/tt0114814/). Kobayashi acts as the
mouthpiece of Soze and the only expression of Keyser's will through most
of the film till the reveal. Also, originally I was going to write the
app in the [padrino](http://padrinorb.com) framework, which usually
takes "underworld" type names for its apps (though in the end,
simplified further and just used the excellent
[Sinatra](http://sinatrarb.com) DSL.).

Secondly, the [Kobayashi
Maru](http://en.wikipedia.org/wiki/Kobayashi_Maru) is also the famous
no-win scenario in Star Trek. Basically, writing your own blog software
is a great way to *not* have people take your project seriously no
matter how good it might (or might not, in this case) be. At least
amongst developers, *everyone* will have a different opinion on what is
or is not only sufficient, but necessary for the making of decent blog
software.


