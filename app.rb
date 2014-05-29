require "./scraper"
require "./generator"

set :views, -> { root }

TITLE = "Etsy search RSS feeds"


get "/" do
  show_index
end

get %r{/(.+)} do
  show_search
end


def show_index
  @title = TITLE
  slim :index
end

def show_search
  data = Scraper.new(request.fullpath).scrape
  root = "http://#{request.host_with_port}"
  url  = request.url
  atom = Generator.new(data, name: TITLE, root: root, url: url).to_atom

  content_type "application/atom+xml"
  cache_control :public, max_age: 1800  # 30 mins.
  atom
rescue Scraper::PageNotFound
  halt 404, "No such page on Etsy."
end
