require 'builder'

module ZOMGRSS
  def to_rss
    items = self.all
    xml = Builder::XmlMarkup.new

    xml.instruct! :xml, :version => '1.0'
    xml.rss :version => "2.0" do
      xml.channel do
        xml.title options[:title]
        xml.description options[:description]
        xml.link options[:base]

        items.each do |item|
          xml.item do
            xml.title item.send(options[:title_method])
            xml.link options[:link_format].gsub(":id", item.id)
            xml.description item.send(options[:body_method])
            xml.pubDate Time.parse(item.created_at.to_s).rfc822()
            xml.guid options[:guid_format].gsub(":id", item.id)
          end
        end
      end
    end
  end

  protected
  def rss_options
    default =  {
      :title => "m-heroin",
      :description => "m-heroin diary",
      :base => "http://mheroin.com/diary",
      :link_format => "http://mhheroin.com/diary/:id",
      :date_field => :created_at,
      :guid_format => ":id@http://mheroin.com/diary/"
    }
    default
  end
end
