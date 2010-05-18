require 'builder'
require 'time'

def rss_me
  self.extend ZOMGRSS
end

module ZOMGRSS
  def to_rss
    items = self.all
    xml = Builder::XmlMarkup.new

    xml.instruct! :xml, :version => '1.0'
    xml.rss :version => "2.0" do
      xml.channel do
        xml.title rss_options[:title]
        xml.description rss_options[:description]
        xml.link rss_options[:base_url]

        items.each do |item|
          xml.item do
            xml.title item.send(rss_options[:title_method])
            xml.link rss_options[:link_format].gsub(":id", item.id.to_s)
            xml.description item.send(rss_options[:body_method])
            xml.pubDate Time.parse(item.send(rss_options[:date_field]).to_s).rfc822()
            xml.guid rss_options[:guid_format].gsub(":id", item.id.to_s)
          end
        end
      end
    end
  end

  def rss_options(rss_options={ })
    @rss_opts = (@rss_opts || self.default_rss_options).merge(rss_options)
  end

  protected
  def default_rss_options
    {
      :title => "m-heroin",
      :description => "m-heroin diary",
      :base_url => "http://mheroin.com/diary",
      :body_method => :body,
      :title_method => :title,
      :link_format => "http://mhheroin.com/diary/:id",
      :date_field => :created_at,
      :guid_format => ":id@http://mheroin.com/diary/",
      :finder => :all,
      :finder_rss_options => nil,
    }
  end
end
