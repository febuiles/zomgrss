require 'dm-core'
require 'dm-timestamps'
require File.join(File.dirname(__FILE__), '..', '/lib/zomgrss.rb')

DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/sample.db")

class BlogPost
  include DataMapper::Resource
  rss_me

  property :id, Serial
  property :title, String, :required => true
  property :body, Text, :required => true
  property :created_at, DateTime
end

DataMapper.auto_upgrade!

# Create some sample posts...
BlogPost.create(:title => "My first post", :body => "Isnt this super interesting?")
BlogPost.create(:title => "My second post", :body => "I wish my lawn was emo so I could stop doing bad jokes")

# This is the resulting RSS.
print BlogPost.to_rss



