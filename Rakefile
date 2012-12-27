require 'active_support/core_ext'
require 'date'
require 'rspec/core/rake_task'

def ask(q)
  print "#{q} "
  STDIN.gets.strip.chomp
end

desc "Run specs"
task :spec do
  RSpec::Core::RakeTask.new(:spec) do |t|
    t.pattern = './spec/**/*_spec.rb'
  end
end

# This is a simple rake test for creating a post and then opening it in
# the user's default text editor. Handy! Default rake task.
namespace :post do
  desc "Creates new post for blog"
  task :create do
    title = ask('Post Title?')
    if date = ask("Date (defaults to #{Date.today})? ") and date.length > 0
      begin
        post_date = Date.new(*date.split('-').map(&:to_i))
      rescue => err
        puts "Whoops, failed to process the date! The format must be #{Date.today}, you gave #{date}"
        raise err
        exit 1
      end
    else
      post_date = Date.today
    end

    filename = "#{post_date}-#{title.parameterize}.md"
    File.open(File.join("./posts/", filename), "w") do |post|
      post.puts "---"
      post.puts "layout: post"
      post.puts "title: \"#{title}\""
      if post_date == Date.today
        post.puts "date: #{Time.now}"
      else
        post.puts "date: #{post_date.to_time} (but change the time as desired or errors)"
      end
      post.puts "location:"
      post.puts "comments: true"
      post.puts "summary: "
      post.puts "categories: []"
      post.puts "---"
      post.puts "Start writing!"
    end

    puts "Created post #{filename}!"
    exec "open ./posts/#{filename}"
  end
end

task :deploy do
  system("git push origin master && git push heroku master")
end

task :default => :"post:create"

