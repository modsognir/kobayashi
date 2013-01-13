$LOAD_PATH.unshift '.'

require 'rack/deflater'

require 'rack/cache'
require 'dalli'
use Rack::Cache,
  metastore: Dalli::Client.new,
  entitystore: 'file:tmp/cache/rack/body',
  allow_reload: false,
  default_ttl: 300

require 'kobayashi'
run Kobayashi.server

