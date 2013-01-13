module Kobayashi
  class Server < Sinatra::Base
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
  end
end