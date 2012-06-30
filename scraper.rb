require "open-uri"
require "time"
require "nokogiri"

class Scraper
  def initialize(path)
    @path = path
  end

  def scrape
    @doc = Nokogiri::HTML(open(url))
    {
      title: get_title,
      url:   url,
      items: get_items
    }
  end

  private

  def get_title
    @doc.css("title").text
  end

  def get_items
    @doc.css(".listings-listview .listing-card").map do |card|
      {
        id:    card[:id].gsub(/\D/, '').to_i,
        url:   card.at(".listing-thumb")[:href],
        title: card.at(".listing-thumb")[:title],
        img:   card.at(".listing-thumb img")[:src].sub(/il_\d+x\d+/, 'il_570xN'),
        time:  parse_time(card.at(".listing-date").text.strip),
        price: card.at(".listing-price").text.strip
      }
    end
  end

  def parse_time(string)
    case string
    when /(\d+) minutes? ago/
      Time.now - ($1.to_i * 60)
    when /(\d+) hours? ago/
      Time.now - ($1.to_i * 60 * 60)
    when /(\d+) days? ago/
      Time.now - ($1.to_i * 60 * 60 * 24)
    else  # E.g. "May 30, 2012"
      Time.parse(string)
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

    # Ensure a consistent format, with more details.
    path.sub!(/[&?]view_type=\w*/, '')
    path += "&view_type=list"

    path
  end
end
