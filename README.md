# Kobayashi

### A sleek, svelte, and speedy blog engine

## Getting Started

### Background

If you need a backgrounder on why I wrote Kobayashi, please [read the blog
post I wrote
here](http://blog.tundramonkey.com/2012/07/20/the-tundramonkey-cometh)
on how Kobayashi came about and why. You can also [read the About
page](https://github.com/tundramonkey/Kobayashi/blob/master/pages/about.md)
in the repo if you need more details.

### Prerequisites and Assumptions

Kobayashi assumes basic knowledge of git, ruby and markdown and are at
least comfortable on the command line. Posts are written in simple
markdown formatted text. It assumes you are using
[github](http://github.com) to version and "backup" your code and
[heroku](http://heroku.com) to host the blog.

You need to have git installed as well as the heroku CLI tools, the
easiest way to do this is to just donwload and install the [heroku
toolbelt](https://toolbelt.heroku.com) if you're not already set up.

### Set Up

Pull the code down from github `git clone git@github.com:tundramonkey/Kobayashi.git`

In order to be able to pull in and merge code changes easily, it's best
to create a new branch (call it blog or whatever) to work on your stuff
and then be able to pull and merge changes from the master.

`rake spec` the code base just to make sure all tests pass (or are
pending.).

Once you've done that, create a new repository on github (personally, I'd
make it private.) and from your new branch, add the remote as 'origin'
for and changes you've made after getting rid of the initial origin.

Create your new heroku app `heroku apps:create blog.domain.com` (or
whatever you want to call it though it needs to be uniquely named
on heroku.).

Heroku automatically adds a git remote called heroku for you when you
create the app.

Set up Add-Ons like Custom Domain in heroku and then point your DNS and
such towards the app as per Heroku's setup.

To start up a local version of the server simply `foreman start` in the
root directory of the project and then navigate to
`http://localhost:5000` to see your site.

### Configuring and Customization

Navigation is set up in `config/navigation.rb` using the very nice
simple-navigation gem.

Any css, images or additional js should go in the approporiate `/app`
directory which uses sinatra-assetpack to consolidate and compress the
assets as well as providing cache busting suffixes to make everything
speedy.

All other configuration is done starting at line 50 in the
`kobayashi.rb` file. Entre in things such as the blog name, the
canonical blog URL (needs to match DNS), how many posts you want on the
front page, recent post title to display and how many posts should
appear in the atom feed. As well, twitter, github, flickr, disqus and
google analytics options can all be subbed in to power various nav items
and javascripts.

Once you've done that, you're good to go.

Delete any test posts you're not interested in (tho note they act as
fixtures for tests so may cause test failure.)

Then you're ready to use Kobayashi.

## Using Kobayashi

1. rake
2. Write Markdown
3. rake deploy

Is pretty simple `rake` on the command line, will ask you for a title
for your post and then whether the default date and time is correct (if
you choose a future date or past one you will need to manually edit the
time for the post in the YAML front matter of the file.).

The rake task then creates a standard formatted .md text file in the
posts directory and launches (at least on macs) your default text editor
to edit it.

Write the post in
[markdown](http://daringfireball.net/projects/markdown/) (the posts are
converted automatically on the fly by the software) to your heart's
content.

Use normal git operations `git add` and `git commit` to commit the new
post to your local repository branch.

While on your blog branch, simply `rake deploy` which will push the code
to both your github repo and heroku.

That's it.

## Thanks To...

Everyone who wrote a bit of great blog software before me, from the
initial wordpress guys to simplelog2, to the bits and ideas I stole
directly from jekyll, toto and Serious, to the personal sites of
@toolmantim and @hughevans and put them on github for me to dissect,
cherry-pick and learn from.

I'd also like to thank the rubberducking superpowers of @scottharveyco
and @tjmcewan for listening to me talk through things like tagging and
Sinatra set as well as pointing out spelling-mistake-syntax-error
inducing code issues, when I look at the production server while making
development changes and general basic stupidity with javascript. I
assure you, as workmates with me at ISF, they have suffered *long*.

Also, initially when starting this project at Railscamp New Zealand on
Mount Cheeseman (where, seriously, 80% of it got written), @vertis and
@modogsnir for pointing out basic issues shoulder surfing my
code and generally amusing heckling.

Last and certainly not least, the very lovely and amazingly patient
@aemeredith for walking me through things like typography, font stacks,
and all sorts of basic designer-y stuff I should really, really know by
this point in my career as well as giving me *that* look whenever I'd
mention the lack of tests. Guilt is a powerful motivator. Any tests
there are in the code base are because of that look.

Finally, while I'm on the long Oscar speech, I'd also really like to
thank the absolutely *amazing* Ruby and Rails community here in
Australia which have been absolutely amazing in terms of support,
mentoring and just being plain amazing. Seriously, you all rock.
