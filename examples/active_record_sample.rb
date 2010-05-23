require 'active_record'
require File.join(File.dirname(__FILE__), '..', '/lib/zomgrss.rb')

# Run the do.rb example first to create the samples database.
ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => "sample.db")

class BlogPost < ActiveRecord::Base
  rss_me
  named_scope :limit, lambda { |lim| { :limit => lim } }
end

BlogPost.rss_options[:finder] = :limit
BlogPost.rss_options[:finder_options] = 1

print BlogPost.to_rss
