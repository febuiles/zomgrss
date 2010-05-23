require 'active_record'
require File.join(File.dirname(__FILE__), '..', '/lib/zomgrss.rb')

# Run the do.rb example first to create the samples database.
ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => "sample.db")

class BlogPost < ActiveRecord::Base
  rss_me
end

print BlogPost.to_rss
