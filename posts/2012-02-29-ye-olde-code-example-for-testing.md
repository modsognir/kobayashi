---
layout: post
title: "Ye Olde Code Example for Testing"
date: 2012-02-29 18:25:31 +1100
comments: true
tags: [dev, code, hacking]
---
Alright, so this is how we see if these things we're working on will
*actually* work the way they're supposed to and render unto Caesar what
they're, um... supposed to render.

How do you code again in freaking Markdown? 4 spaces? Seriously?

Yay it ~~doesn't~~ works

```ruby
require 'redcarpet'
markdown = Redcarpet.new("Hello World!")
puts markdown.to_html

def kobayashi
  pages ||= page_files.map { |pf| new(pf) }
end
```
<!--more-->
Yep, that ought to do it, though I really shouldn't be able to see this
bit *here* on the front page since it's after the **more** tag and
really we just want to see a nifty excerpt or such.

Let's see what we get using RedCarpet then.



