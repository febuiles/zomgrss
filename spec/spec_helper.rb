require File.join(File.dirname(__FILE__), '..', '/lib/zomgrss.rb')
require 'spec'
require 'nokogiri'

class SuperSomething
  attr_reader :id, :title, :body, :created_at

  rss_me

  def self.all
    self.some(3)
  end

  def initialize(date)
    @id = 4                    # chosen by a fair dice roll, guaranteed to be random.
    @title = "SuperTitle!"
    @body = '<p><img src="http://mheroin.com/img.jpg" />SuperBody!!</p>'
    @created_at = date
  end

  def self.some(lim=1, date=Time.utc(1987, "apr", 4, 2, 0, 0))
    Array.new(lim, SuperSomething.new(date))
  end

  def fecha; @created_at; end
  def titulo; @title; end
  def cuerpo; @body; end
end

def base_url
  "http://mheroin.com"
end

def default_options
  SuperSomething.send(:default_rss_options)
end

def parse_feed
  @feed = Nokogiri::XML(SuperSomething.to_rss)
end
