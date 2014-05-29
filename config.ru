# FIXME: Figure out why we don't need to require these or bundler/setup.
# Perhaps only skippable in dev? Something to do with rackup?
#require "rubygems"
#require "bundler"

require "rack-canonical-host"
require "sinatra"
require "dalli"

# Rewrites Heroku ENV names so Dalli just works.
require "memcachier"

require "rack-cache"
require "raygun4ruby"

env = (ENV["RACK_ENV"] || :development).to_sym
if env == :production
  require "unicorn"
  require "newrelic_rpm"
end

require_relative "app"
require_relative "raygun_rack"

use Rack::CanonicalHost, ENV["CANONICAL_HOST"] if ENV["CANONICAL_HOST"]


# Defined in ENV on Heroku. To try locally, start memcached and uncomment:
# ENV['MEMCACHE_SERVERS'] = "localhost"
if memcache_servers = ENV["MEMCACHE_SERVERS"]
  use Rack::Cache,
    verbose: true,
    metastore:   "memcached://#{memcache_servers}",
    entitystore: "memcached://#{memcache_servers}"
end


raygun_api_key = ENV["RAYGUN_API_KEY"]

Raygun.setup do |config|
  config.api_key = raygun_api_key
  config.silence_reporting = !raygun_api_key
end

use RaygunRack


run Sinatra::Application
