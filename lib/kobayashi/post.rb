module Kobayashi
  class Post

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
end