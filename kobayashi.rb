require 'bundler'
Bundler.require
require 'sinatra/base'
require 'sinatra/simple-navigation'
require 'ostruct'
require 'time'
require 'yaml'
require 'pathname'
require 'haml'
require 'redcarpet'
require 'active_support/core_ext' # Needed for paramaterize for slugs
require 'facets/enumerable'       # Handles tag counting - yields .frequency magic
#
# Time Zone for "home" required so server knows where you call home base.
# Can change but you need the +1000, +0000 correct on the TimeStamp for each post.
# Basically, a pain if you're moving round the globe a lot like me.
# But, if your timezone is set (at least on a Mac) when travelling, the rake task
# to create posts should pick it up fine and put in correctly.
ENV['TZ'] = 'Australia/Sydney'

class Kobayashi < Sinatra::Base
  set :root, File.join(File.dirname(__FILE__))

  # Uncomment this if you want newrelic monitoring of the blog
  # and fill in the key and app name in config/newrelic.yml
  # Finally, uncomment the newrelic gem and bundle update
  # configure :production do
  #   require 'newrelic_rpm'
  # end

  use Rack::Deflater        # goes here, not config.ru for modular app, gzips serves
  register Sinatra::SimpleNavigation
  register Sinatra::AssetPack

  assets {
    serve '/js',     from: 'app/js'        # Optional
    serve '/css',    from: 'app/css'       # Optional
    serve '/images', from: 'app/images'    # Optional

    js :app, '/js/app.js', ['/*.js']
    css :app, '/css/app.css', ['/*.css']

    js_compression  :yui, :munge => true   # Munge variable names
    css_compression :yui
  }

  # initialize RedCarpet Markdown renderer for displaying posts and pages
  set :markdown, Redcarpet::Markdown.new(Redcarpet::Render::HTML, :fenced_code_blocks => true, :autolink => true, :space_after_headers => true, :strikethrough => true, :superscript => true)

  # Configuration defaults and personalization parameters
  set :blog_name,         "Kobayashi"
  set :blog_url,          "http://localhost:5000"
  set :author,            "Daryl Manning"
  set :posts_on_index,    1   # Number of posts on index
  set :recent_posts,      11  # Number of recent posts to display, offset from index posts (title only)
  set :feed_posts,        20  # Number of posts displayed in the atom feed
  set :twitter,           "twitter_username"
  set :github,            "github_username"
  set :flickr,            "flickr_username"
  set :flickrid,          "flickr_alphanumeric_id"
  set :flickrapi,         "flickr_api_key"
  set :disqus,            "disqus_blog_shortname"
  set :google_analytics,  "UA-XXXXXX-X"
  set :cache_ttl,         300  # Seconds to cache refresh

  # set cache time of assets in the public directory
  # nb: this doesn't include assetpacked css/js/images
  set :static_cache_control, [:public, :must_revalidate, :max_age => Kobayashi.cache_ttl]

  class << self
    # Rendering should be a top level method accessible by any other class
    def render_markdown(text)
      markdown.render(text)
    end

  end

  # Set all the routes!
  # Index page
  get '/' do
    @title = "Home"
    @post ||= Kobayashi::Post.first || halt(404)
    #@post ||= Kobayashi.post_index.select {|p| p[:date] < Time.now}.first || halt(404)
    @post = Kobayashi::Post.parse_post(@post[:file])
    @archives_on_index ||= Kobayashi::Post.grab_current_posts[(0 + Kobayashi.posts_on_index)..(Kobayashi.recent_posts + Kobayashi.posts_on_index - 1)]
    etag Digest::MD5.hexdigest(@post.title + @post.time.to_s + @post.excerpt + @archives_on_index.to_s)
    cache_control :public
    haml :index
  end

  # Grab all posts (archives) by date ie. 2011, 2011/09, 2011/09/08
  get %r{^/(\d{4})[/]{0,1}(\d{0,2})[/]{0,1}(\d{0,2})[/]{0,1}$} do
    archives = params[:captures].reject {|s| s.strip.length == 0 }.map {|n| n.length == 1 ? "%02d" % n : n}
    @posts = Post.find(*archives)
    @title = "Archives for #{archives.join("-")}"
    cache_control :public
    haml :archives
  end

  # Grab a specific post
  # Note the pass if it can't find one assuming we are looking
  # for a page route and deferring the 404 till no page is found
  get %r{^/(\d{4})/(\d{1,2})/(\d{1,2})/([^\/]+)} do
    @post ||= Post.first(*params[:captures]) || pass
    @post = Kobayashi::Post.parse_post(@post[:file])
    @title = @post.title
    etag Digest::MD5.hexdigest(@post.title + @post.time.to_s + @post.body + @post.tags.to_s)
    cache_control :public
    haml :post
  end

  # Note pages route needs to be after specific post route above
  # in order to take advantage of the || pass "fall through"
  # so posts fall through to special pages and then to md pages
  # before getting a 404
  get '/:page' do
    # Grab all the posts as archives
    if params[:page] == 'archives'
      @posts = Kobayashi::Post.grab_current_posts
      @title = "Archives"
      etag Digest::MD5.hexdigest(@posts[0..15].to_s)
      cache_control :public
      haml :archives
    # Grab all the tags for all posts
    elsif params[:page] == 'tags'
      @tag_counts = Kobayashi::Post.count_tags
      @title = "Tags"
      etag Digest::MD5.hexdigest(@tag_counts.to_s)
      cache_control :public
      haml :tags
    # Create the sitemap xml for search bots
    elsif params[:page] == 'sitemap'
      @posts = Kobayashi::Post.grab_current_posts
      etag Digest::MD5.hexdigest(@posts.to_s)
      cache_control :public
      haml :sitemap, :layout => false
    # Create the atom feed for the site
    elsif params[:page] == 'atom.xml'
      @posts = @posts = Kobayashi::Post.grab_current_posts
      @posts = @posts[0..(Kobayashi.feed_posts - 1)]
      etag Digest::MD5.hexdigest(@posts.to_s)
      cache_control :public
      content_type 'application/atom+xml'
      haml :feed, :layout => false
    # Find the actual page that is not a reserved
    # route or throw a 404
    else
      @page = Page.find(params[:page]) || halt(404)
      @page = Kobayashi::Post.parse_post(@page)
      etag Digest::MD5.hexdigest(@page.title + @page.body)
      cache_control :public
      @title = @page.title
      haml :page
    end
  end

  # Grab all posts belonging to a particular tag
  get '/tags/:tag' do
    @tag = params[:tag].parameterize
    @tagged_posts = Kobayashi::Post.find_posts_by_tag(@tag)
    @title = "Posts tagged #{@tag}"
    etag Digest::MD5.hexdigest(@tagged_posts.to_s)
    cache_control :public
    haml :tags
  end

  not_found do
    @title = "404"
    etag Digest::MD5.hexdigest(@title)
    cache_control :public
    haml :"404"
  end

  error do
    @title = "500"
    etag Digest::MD5.hexdigest(@title)
    cache_control :public
    haml :"500"
  end


class Kobayashi::Post

  class << self

    def first(*args)
      ## Used for finding a specific post by providing full parameter or date
      find(*args).first
    end

    def find(*args)
      # Reformat arguments (one-digit months and days should be converted to two-digit format)
      args = args.map {|a| a.to_s =~ /^\d{1}$/ ? "%02d" % a : a }
      # Look for all files which contain the dashed format ie. 2011/09 looks for 2011-09 in index
      posts = Kobayashi.posts_index.select { |p| p[:file].to_s =~ /#{args.join('-')}/i }
      posts = posts.select { |p| p[:date] < Time.now }
    end

    def find_posts_by_tag(tag)
      @posts_by_tag = Kobayashi.posts_index.select do |ti|
        (ti[:date] < Time.now) && (ti[:tags].include? tag)
      end
      @posts_by_tag
    end

    def parse_post(post)
      # Parse all the datas!!! Splits based on Jekyll markdown format
      marker, meta, body = File.read(post.to_s).split("---\n", 3)

      post = OpenStruct.new YAML.load(meta)
      # yields metadata from Jekyll wp converted posts
      # post.layout, post.title, post.date, post.comments, post.published, post.tags (an array) etc
      post.title =    post.title
      post.slug =     post.title.parameterize
      post.time =     Time.parse(post.date.to_s)
      post.date =     post.time.to_date
      post.body =     Kobayashi::render_markdown(body)
      post.tags =     post.tags
      # If a summary exists in meta, uses it and renders it.
      # Otherwise, takes the body, looks for <!--more--> tag and then
      # uses that as the excerpt. If no <!--more--> tag, excerpt is body
      if post.summary
        post.excerpt = Kobayashi::render_markdown(post.summary)
      else
        excerpt, rest_of_post = body.split("<!--more-->", 2)
        post.excerpt =  Kobayashi::render_markdown(excerpt)
        post.rest_of_post = Kobayashi::render_markdown(rest_of_post) if rest_of_post
      end
      if post.layout == 'post'
        post.url  = "/#{post.date.year}/#{"%02d" % post.date.month}/#{"%02d" % post.date.day}/#{post.slug}"
        post.file = "/#{post.date.year}/#{"-" % post.date.month}/#{"-" % post.date.day}/#{post.slug}"
      else # ie. if layout is a page
        post.url = post.slug
        post.file = post.slug
      end
      post
    end

    # Build a one-time persistent index of posts so don't have to parse all
    # posts each request to get tags or parse file system.
    # Parameterize tags to support nice urls and finding the tagged posts
    def build_posts_index
      @posts_index = []
      @posts ||= Dir.glob (Pathname.pwd.join("posts", "*.md"))
        @posts.each do |p|
          post = Kobayashi::Post.parse_post(p.to_s)
          index_of_post = {:date => post.time, :title => post.title, :url => post.url,
                            :file => p,
                            :tags => post.tags.map { |t| t.parameterize }
                           }
          @posts_index << index_of_post
        end
      # reverse sort the array of Hashes by Date
      @posts_index = @posts_index.sort_by { |ti| ti[:date] }.reverse
      @posts_index
    end

    # Gets the posts index and flattens and hashes tags frequency
    def count_tags
      tags = []
      @posts = Kobayashi::Post.grab_current_posts
      @posts.each do |post|
          tags << post[:tags]
        end
      @tag_counts = tags.flatten.frequency
      @tag_counts = Hash[@tag_counts.sort]
      return @tag_counts
    end

    def grab_current_posts
      @posts = Kobayashi.posts_index.select { |p| p[:date] < Time.now }
    end

  end

  def initialize(post)
    @post = post
  end

  def to_s
    @post
  end

end

class Kobayashi::Page < Kobayashi::Post
  class << self

    # Returns all pages
    def all
      pages ||= page_files.map { |pf| new(pf) }
    end

    # Find pages in the pages directory
    def find(args)
      page = page_files.select {|pf| File.basename(pf) =~ /#{args}/i }.map {|pf| new(pf)}
      page = page.first
    end

    # Grab all the page files
    def page_files
      @page_files ||= (Dir.glob (Pathname.pwd.join("pages", "*.md"))).sort
    end

  end

end

  # Builds an index of all posts to speed up finding posts
  # rather than parsing all posts each time. I <3 Sinatra set.
  # Also, key to making tag counts being found quickly.
  # Needs to be set at end of class or Proc.new messes up speed (Why?).
  set :posts_index, Kobayashi::Post.build_posts_index

end


