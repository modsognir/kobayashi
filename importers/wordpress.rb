# Totally ripped off from the fine fine people who did the Jekyll
# converter for wordpress. Seriously, they're  quite awesome and
# there are very few changes here. It's practically verbatim.
#
# And just because it's a little tricky... from the root of your
# project, run
# ruby -rubygems -e 'require "/path/to/kobayashi/importers/wordpress"; Kobayashi::Wordpress.process("name_of_wp_database", "db_user_name", "db_password")'
# And that should sort you out.
require 'rubygems'
require 'sequel'
require 'fileutils'
require 'yaml'
require 'active_support/core_ext'

# NOTE: This converter requires Sequel and the MySQL gems.
# The MySQL gem can be difficult to install on OS X. Once you have MySQL
# installed, running the following commands should work:
# $ sudo gem install sequel
# $ sudo gem install mysql -- --with-mysql-config=/usr/local/mysql/bin/mysql_config

module Kobayashi
  module Wordpress

    # Reads a MySQL database via Sequel and creates a post file for each
    # post in wp_posts that has post_status = 'publish'.
    # This restriction is made because 'draft' posts are not guaranteed to
    # have valid dates.
    QUERY = "select post_title, post_name, post_date, post_content, post_excerpt, ID, guid from wp_posts where post_status = 'publish' and post_type = 'post'"

    TAGS = "SELECT t.taxonomy, term.name, term.slug from wp_term_relationships AS tr
            INNER JOIN wp_term_taxonomy AS t ON t.term_taxonomy_id = tr.term_taxonomy_id
            INNER JOIN wp_terms AS term ON term.term_id = t.term_id
            WHERE tr.object_id = %d AND t.taxonomy = 'post_tag'
            ORDER BY tr.term_order"

    def self.process(dbname, user, pass, host = 'localhost')
      db = Sequel.mysql(dbname, :user => user, :password => pass, :host => host, :encoding => 'utf8')

      FileUtils.mkdir_p "imported_posts"

      db[QUERY].each do |post|
        # Get required fields and construct Jekyll compatible name
        title = post[:post_title]
        slug = post[:post_title].parameterize
        date = post[:post_date]
        content = post[:post_content]
        name = "%02d-%02d-%02d-%s.md" % [date.year, date.month, date.day, slug]
        categories = []
        post_tags = []

        puts title

        db[TAGS % post[:ID]].each do |tag|
          post_tags << tag[:name]
        end

        # Get the relevant fields as a hash, delete empty fields and convert
        # to YAML for the header
        data = {
           'layout' => 'post',
           'title' => title.to_s,
           'summary' => post[:post_excerpt].to_s,
           'wordpress_id' => post[:ID],
           'wordpress_url' => post[:guid],
           'date' => date,
           'comments' => "true",
           'categories' => post_tags
         }.delete_if { |k,v| v.nil? || v == ''}.to_yaml

        # Write out the data and content to file
        File.open("imported_posts/#{name}", "w") do |f|
          f.puts data
          f.puts "---"
          f.puts content
        end
      end

    end
  end
end
