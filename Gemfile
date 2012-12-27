ruby "1.9.3"
source :rubygems

gem 'sinatra'
gem 'haml'

# assetpack + yui js and css compressors
gem 'sinatra-assetpack', :require => 'sinatra/assetpack'
gem 'yui-compressor', :require => 'yui/compressor'

gem 'sinatra-simple-navigation'
gem 'redcarpet'
gem 'activesupport'
gem 'i18n'
gem 'facets'
gem 'rake'
gem 'puma'

gem 'rack-cache'
gem 'dalli'

# If you want new relic stats, uncomment gem and add in
# shortname and key in config/newrelic.yml from your newrelic account
# gem 'newrelic_rpm'

group :development, :test do
  # tests using minitest so no gem needed - standard in ruby 1.9
  # Note heroku toolbelt with foreman and heroku-cli need to be installed
  gem 'rack-test'
  gem 'rspec'
  gem "capybara"
  gem "capybara-webkit"
  gem "delorean"
end

