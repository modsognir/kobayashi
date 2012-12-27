require_relative 'spec_helper'

describe 'Kobayashi' do

  context "Unit Tests" do
    # it "should parse a post"

    it "should build a posts index" do
      @posts_index = Kobayashi::Post.build_posts_index
      @posts_index.size.should == 4 # not 3, as the future post not included
      @posts_index.first[:title].should == "Ye Olde Future Proofing post test"
      @posts_index.first[:url].should == "/2121/02/24/ye-olde-future-proofing-post-test"
      @posts_index.first[:date].to_date.should == ("2121-02-24").to_date
      @posts_index.first[:tags].should == ['dev', 'code', 'hacking']
    end

    it "should create a tag count" do
      @tag_counts = Kobayashi::Post.count_tags
      @tag_counts.each_pair.count.should == 4
      @tag_counts["dev"].should == 1
    end

    it "should find and parse a specific post" do
      # get "/2012/02/24/ye-old-code-example-for-testing"
      post = Kobayashi::Post.first(["2012", "02", "29", "ye-olde-code-example-for-testing"])
      @post = Kobayashi::Post.parse_post(post[:file])
      @post.title.should == "Ye Olde Code Example for Testing"
    end

    it "should find posts by a specific tag" do
      @posts_by_tag = Kobayashi::Post.find_posts_by_tag("dev")
      @posts_by_tag.count.should == 1
      @posts_by_tag.first[:title].should == "Ye Olde Code Example for Testing"
    end

    it "should not find future posts" do
      @post = Kobayashi::Post.first
      @post[:title].should == "Welcome to Kobayashi"
    end

    it "should find future posts when date rolls over to date of post" do
      @post = Kobayashi::Post.first
      @post[:title].should == "Welcome to Kobayashi"
      Delorean.time_travel_to 125.years.from_now
      @post = Kobayashi::Post.first
      @post[:title].should == "Ye Olde Future Proofing post test"
      Delorean.back_to_the_present
    end

    it "should not find tags in future posts" do
      @tag_counts = Kobayashi::Post.count_tags
      @tag_counts.each_pair.count.should == 4
      @tag_counts["dev"].should == 1
    end

    it "should find tags in future posts when date rolls over to date of post" do
      @tag_counts = Kobayashi::Post.count_tags
      @tag_counts.each_pair.count.should == 4
      @tag_counts["dev"].should == 1
      Delorean.time_travel_to 125.years.from_now
      @tag_counts = Kobayashi::Post.count_tags
      @tag_counts.each_pair.count.should == 4
      @tag_counts["dev"].should == 2
      Delorean.back_to_the_present
    end

  end

  context "Home Page" do

    it "should return a valid status" do
      get '/'
      last_response.should be_ok
    end

    it "should have the title Kobayashi" do
      get '/'
      last_response.should be_ok
      page.has_selector?("h1", :content => "Kobayashi")
    end

    it "should contain the number of posts on home page as configured"
    it "should display the content of at least the most recent post"
    it "should not contain posts in the future"
    it "should contain recent posts as offset by visible posts on home page"

  end

  context 'Archives' do

    it "should return a valid status" do
      get "/archives"
      last_response.should be_ok
    end

    it "should return all valid posts in reverse date order"
    it "should not return future posts"

    it "should find a list of posts according to a provided year" do
      posts = Kobayashi::Post.find(["2012"])
      posts.size.should == 3
      posts.first[:title].should == "Welcome to Kobayashi"
      posts.last[:title].should == "Enter Stage Left"
    end

    it "should find a list of posts according to a provided year and month" do
      posts = Kobayashi::Post.find(["2012", "02"])
      posts.size.should == 3
      posts.first[:title].should == "Welcome to Kobayashi"
      posts.last[:title].should == "Enter Stage Left"
    end

    it "should find a list of posts according to a year, month and day" do
      posts = Kobayashi::Post.find(["2012", "02", "29"])
      posts.size.should == 2
      posts.first[:title].should == "Welcome to Kobayashi"
      posts.last[:title].should == "Ye Olde Code Example for Testing"
    end

    it "should not return future posts given a future year" do
      posts = Kobayashi::Post.find(["2121"])
      posts.size.should == 0
    end

    it "should not return future posts given a future year and month" do
      posts = Kobayashi::Post.find(["2121", "12"])
      posts.size.should == 0
    end

    it "should not return future posts given a full future date" do
      posts = Kobayashi::Post.find(["2121", "06", "25"])
      posts.size.should == 0
    end

  end

  context 'Pages' do
    it "should not return all pages" do
      get "/pages"
      last_response.should_not be_ok
    end

    it "should return About page" do
      get '/about'
      last_response.should be_ok
    end

    it "should return a 404 for unfound pages" do
      get '/not-a-real-page'
      last_response.should_not be_ok
    end

  end

  context 'Tags' do
    it "should return a page of all tags" do
      get "/tags"
      last_response.should be_ok
    end

    it "should return no posts for a non-existent tag" do
      get "/tags/ooglyboogly"
      page.has_selector?("h3", :content => "<strong>no</strong> posts")
    end

    it "should return posts for an existing tag" do
      get "/tags/dev"
      page.has_selector?("p", :content => "1 posts marked \"dev\"")
      page.has_selector?("archives")
      page.has_selector?("h2", :content => "Ye Olde Code Example for Testing")
    end


  end

  context 'Site feed' do
    it "should return a site feed" do
      get '/atom.xml'
      last_response.should be_ok
    end

    it "should return a valid feed document"

  end

  context 'Site map'do
    it "should generate a sitemap" do
      get "/sitemap"
      last_response.should be_ok
    end

    it "should generate a valid sitemap document"

  end

end
