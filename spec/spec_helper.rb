require File.join(File.dirname(__FILE__), '..', '/lib/zomgrss.rb')
require 'spec'

class SuperObject
  attr_reader :id, :title, :body, :created_at
  def self.all
    Array.new(3, SuperObject.new)
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
