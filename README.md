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

In order to have caching work properly, you also need to add in the
memcache add-on which you can do form the command line `heroku
addons:add memcache:5mb` in order to have the combined metadata store
from Dalli work with memcache even though the entitystote works with the
filesystem (see `config.ru` for how that is configured.).

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

### Migrating

If you are using wordpress, there is a script in `./importers` to
migrate from wordpress using a mysql database to Kobayashi's format.
Instructions are in the actual file to run the importer.

If you're using Jekyll, this is even easier since the idea of Jekyll's
yaml front matter posts is one I loved (It is also very similar to
Serious'), so Kobayashi uses a virtually identical format.

Migrating from a vanilla Jekyll install should be as simple as copying
all the files from the `_posts` directory and sticking them in the
`/posts` directory in Kobayashi. Done.

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

## Updating Kobayashi

If you've set up your github and heroku remotes on your system as
detailed above (so with an origin branch for Kobayashi upstream and a
blog branch as the "master" for your own changes) then managing updates
is simple (and your rake tasks work as expected.).

To get updates to Kobayashi, `git checkout master` and then `git pull
origin master` to bring and apply the latest changes from Kobayashi to
your master branch.

Once you're satisfied all these work as expected and you're fine with
the changes, `git checkout blog` to switch back to your own branch and
then `git merge master` in order to have those changes applied to your
own customized version of the blog software (and resolving any merge
conflicts you might have caused with your own hacking.).

Once done, `git add .` and `git commit` and then `rake deploy` as normal
to push the code to both your own private blog repo and heroku.

## Thanks To...

Everyone who wrote a bit of great blog software before me, from the
initial wordpress guys to simplelog2, to the bits and ideas I stole
directly from jekyll, toto and Serious, to the personal sites of
@toolmantim and @hughevans and put them on github for me to dissect,
cherry-pick and learn from.

I'd also like to thank the rubberducking superpowers of @scottharveyco
and @tjmcewan for listening to me talk through things like tagging and
Sinatra set as well as pointing out spelling-mistake-as-syntax-error
inducing code issues, when I looked at the production servers while making
development changes and general basic stupidity with javascript. I
assure you, as workmates with me at ISF, they have suffered *long*.

Also, initially when starting this project at Railscamp New Zealand on
Mount Cheeseman (where, seriously, 80% of it got written), @vertis and
@modogsnir for pointing out basic issues shoulder surfing my code and
generally amusing, yet helpful, heckling.

Last and not least, the very lovely and amazingly patient
@aemeredith for walking me through things like typography, font stacks,
and all sorts of basic designer-y stuff I should really, really know by
this point in my career as well as giving me *that* look whenever I'd
mention the lack of tests. Guilt is a powerful motivator. Any tests
there are in the code base are because of that look.

Finally, while I'm on the long Oscar speech, I'd also really like to
thank the *amazing* Ruby and Rails community here in Australia which
have been absolutely amazing in terms of support, mentoring, answering
of dumb questions and just being plain amazing. Seriously, you all rock.

