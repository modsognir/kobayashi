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

require 'kobayashi/post'
require 'kobayashi/page'
require 'kobayashi/server'

module Kobayashi
  def self.server
    Kobayashi::Server
  end
end