require "open-uri"
require "time"
require "nokogiri"

class Scraper
  class PageNotFound < StandardError; end

  def initialize(path)
    @path = path
  end

  def scrape
    @doc = Nokogiri::HTML(open(url, :allow_redirections => :all))
    {
      title: get_title,
      url:   url,
      items: get_items
    }
  rescue OpenURI::HTTPError => e
    if e.message == "404 Not Found"
      raise PageNotFound
    else
      raise
    end
  end

  private

  def get_title
    @doc.css("title").text
  end

  def get_items
    @doc.css(".listings .listing-card").map do |card|
      url = card.at(".listing-thumb")[:href]

      # Etsy doesn't properly escape the ga_facet parameter.
      url.gsub!(" ", "+")
      url.gsub!('"', "%22")

      {
        id:    card[:id].gsub(/\D/, '').to_i,
        url:   url,
        title: card.at(".listing-thumb")[:title],
        img:   card.at(".listing-thumb img")[:src].sub(/il_\d+x\d+/, 'il_570xN'),
        time:  Time.now,  # Can't determine without loading each item page :/
        price: card.at(".listing-price").text.strip
      }
    end
  end

  def url
    "http://www.etsy.com#{path}"
  end

  def path
    path = @path.dup

    # Always order by date.
    path.sub!(/[&?]order=\w*/, '')
    separator = path.include?("?") ? "&" : "?"
    path += "#{separator}order=date_desc"

    # Always page 1.
    path.sub!(/[&?]page=\d*/, '')
    path += "&page=1"

    path
  end
end
