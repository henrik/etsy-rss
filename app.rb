require "rubygems"
require "bundler"
Bundler.require :default, (ENV['RACK_ENV'] || "development").to_sym

# Defined in ENV on Heroku. To try locally, start memcached and uncomment:
# ENV['MEMCACHE_SERVERS'] = "localhost"
if memcache_servers = ENV['MEMCACHE_SERVERS']
  use Rack::Cache,
    verbose: true,
    metastore:   "memcached://#{memcache_servers}",
    entitystore: "memcached://#{memcache_servers}"
end

require "./scraper"
require "./generator"

set :views, -> { root }

TITLE = "Etsy search RSS feeds"

get '/' do
  @title = TITLE
  slim :index
end

get %r{/(.+)} do
  data = Scraper.new(request.fullpath).scrape
  root = "http://#{request.host_with_port}"
  url  = request.url
  atom = Generator.new(data, name: TITLE, root: root, url: url).to_atom

  content_type "application/atom+xml"
  cache_control :public, max_age: 1800  # 30 mins.
  atom
end
