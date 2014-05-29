require "rubygems"
require "bundler/setup"

require "rack-canonical-host"
require "rack-cache"
require "dalli"
require "memcachier"  # Rewrites Heroku ENV names so Dalli just works.
require "raygun4ruby"

env = (ENV["RACK_ENV"] || :development).to_sym
if env == :production
  require "unicorn"
  require "newrelic_rpm"
end

require_relative "app"
require_relative "raygun_rack"

canonical_host = ENV["CANONICAL_HOST"]

# To try locally, start memcached and run app with MEMCACHE_SERVERS=localhost
if memcache_servers = ENV["MEMCACHE_SERVERS"]
  rack_cache_opts = {
    verbose:     true,
    metastore:   "memcached://#{memcache_servers}",
    entitystore: "memcached://#{memcache_servers}",
  }
end

Raygun.setup do |config|
  raygun_api_key = ENV["RAYGUN_API_KEY"]

  config.api_key = raygun_api_key
  config.silence_reporting = !raygun_api_key
end

use Rack::CanonicalHost, canonical_host if canonical_host
use Rack::Cache, rack_cache_opts if rack_cache_opts
use RaygunRack
run EtsyRSS
