require "builder"

class Generator
  def initialize(data, opts)
    @data = data
    @name = opts[:name]
    @root = opts[:root]
    @url  = opts[:url]
  end

  def to_atom
    xml = Builder::XmlMarkup.new(indent: 2)
    xml.instruct! :xml, version: "1.0"
    xml.feed(xmlns: "http://www.w3.org/2005/Atom") do |feed|
      feed.title     @data[:title]
      feed.id        @data[:url]
      feed.link      href: @data[:url]
      feed.link      href: @url, rel: "self"
      feed.updated   updated_at.iso8601
      feed.author    { |a| a.name @name }
      feed.generator @name, uri: @root
      feed.icon      "http://www.etsy.com/images/favicon.ico"

      @data[:items].each_with_index do |item, index|
        unique_time = item[:time] + index

        feed.entry do |entry|
          entry.id      item[:url]
          entry.title   item[:title]
          entry.link    href: item[:url]
          entry.updated unique_time.iso8601
          entry.content content(item), type: "html"
        end
      end
    end
  end

  private

  def updated_at
    @data[:items].map { |i| i[:time] }.max || Time.now
  end

  def content(item)
    <<-HTML
      <p>
        <a href="#{item[:url]}">
          <img src="#{item[:img]}" alt="">
        </a>
      </p>
      <p>
        <strong>Price:</strong>
        #{item[:price]}
      </p>
    HTML
  end
end
