require File.join(File.dirname(__FILE__), '..', '/lib/zomgrss.rb')
require 'spec'

class SuperSomething
  attr_reader :id, :title, :body, :created_at

  rss_me

  def self.all
    Array.new(3, SuperSomething.new)
  end

  def initialize
    @id = rand(10)
    @title = "SuperTitle!"
    @body = '<p><img src="http://mheroin.com/img.jpg" />SuperBody!!</p>'
    @created_at = Time.now
  end
end

def base_url
  "http://mheroin.com"
end

def default_rss_options
  SuperSomething.send(:default_rss_options)
end
