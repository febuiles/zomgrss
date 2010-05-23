require 'active_record'
require File.join(File.dirname(__FILE__), '..', '/lib/zomgrss.rb')

# Run the do.rb example first to create the samples database.
ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => "sample.db")

class BlogPost < ActiveRecord::Base
  rss_me
  named_scope :limit, lambda { |max, min| { :limit => (max - min) } }
end

# Set options for the RSS generator.
BlogPost.rss_options[:title] = "My new not emo blog"
BlogPost.rss_options[:description] = "Emo no more, I'm HipsterBrian now"
BlogPost.rss_options[:base_url] = "http://blog.hipsterbrian.com/"
BlogPost.rss_options[:link_format] = "http://blog.hipsterbrian.com/:id"

# Use a custom finder for items
BlogPost.rss_options[:finder] = :limit
BlogPost.rss_options[:finder_options] = [10, 9]


print BlogPost.to_rss
