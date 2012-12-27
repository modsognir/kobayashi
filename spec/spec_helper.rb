require_relative '../kobayashi.rb'

require 'sinatra'
require 'rack/test'
require 'rspec'
require 'delorean'
require 'capybara'
require 'capybara/dsl'

# setup test environment
set :environment, :test
set :run, false
set :raise_errors, true
set :logging, false

Capybara.app = Kobayashi

def app
  Kobayashi
end

RSpec.configure do |config|
  config.include Rack::Test::Methods
  config.include Delorean
  config.include Capybara::DSL
end

