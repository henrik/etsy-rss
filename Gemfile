source "https://rubygems.org"
ruby "2.1.1"

gem "rack-canonical-host"
gem "sinatra"
gem "slim"
gem "rdiscount"
gem "nokogiri"
gem "builder"
gem "dalli"
gem "rack-cache"
gem "raygun4ruby"
gem "open_uri_redirections"

# Rewrites Heroku ENV names so Dalli just works.
gem "memcachier"

group :production do
  gem "unicorn"
  gem "newrelic_rpm"
end
