ZOMGRSS
=======
ZOMGRSS is a Ruby gem to create RSS feeds from your Ruby collections.

Installation
-----------

     $ gem install zomgrss

Example
-------

     class BlogPost < ActiveRecord::Base
       rss_me
     end

     print BlogPost.to_rss

     # => (no line-breaks in original)
     <?xml version="1.0" encoding="UTF-8"?>
     <rss version="2.0">
       <channel>
         <title>Your blog!</title>
         <description>A nice description of your emo posts</description>
         <link>http://example.com/blog</link>
         <item>
           <title>My first post</title>
           <link isPermaLink="false">http://example.com/blog/1</link>
           <description>Isnt this super interesting?</description>
           <pubDate>Sat, 22 May 2010 21:38:17 -0500</pubDate>
           <guid>1@http://exmaple.com/blog/</guid>
         </item>
         <item>
           <title>My second post</title>
           <link isPermaLink="false">http://example.com/blog/2</link>
           <description>I wish my lawn was emo so I could stop doing silly jokes</description>
           <pubDate>Sat, 22 May 2010 21:38:17 -0500</pubDate>
           <guid>2@http://exmaple.com/blog/</guid>
         </item>
       </channel>
     </rss>

You can see more examples in the `examples/` folder.

Usage
-----
For a basic dose of ZOMGRSS just call `rss_me` in your class and then call `Class.to_rss`. Example:

     class BlogPost
       include DataMapper::Resource
       rss_me

       property :id, Serial
       property :title, String, :required => true
       property :body, Text, :required => true
       property :created_at, DateTime
     end

     BlogPost.to_rss  # => returns the RSS feed for all the objects in BlogPost.

ZOMGRSS expects your class to have four basic attributes: `id`, `title`, `body` and `created_at`. These
are used to populate the RSS title, description, GUID and pubDate fields of each item in your feed. Users
of DataMapper and ActiveRecord should have instant access to the `id` and `created_at` fields. Read
Custom Options to find out how to modify these.

Your RSS feed also include three important fields:

* `title`: Your feed's title (i.e. _Brian's Emo Blog_)
* `description`: A description of your feed (i.e. _I'm Brian and I like to cut myself._)
* `base_url`: A base URL for your feed (i.e. _http://blog.emobrian.com/_)

To set these fields just call the `rss_options` class method:

     BlogPost.rss_options[:title] = "My new not emo blog"
     BlogPost.rss_options[:description] = "Emo no more, I'm HipsterBrian now"
     BlogPost.rss_options[:base_url] = "http://blog.hipsterbrian.com/"

You'll also want to modify the `link_format` option, which specifies the format of the links used
in your site. A typical site will use the same URL for every item, changing only the ID of the
post. An example of the link format for Brian's Hipster blog would be:

      BlogPost.rss_options[:link_format] = "http://blog.hipsterbrian.com/:id"

ZOMGRSS would replace `:id` with the object's ID field.


Custom Options
---------------
### Custom Method Names

If your class uses different names for the necessary methods (`title`, `body` and `created_at`) you
can set them in the rss_options. If you had the following class:

     class BlogPost
       include DataMapper::Resource
       rss_me

       property :id, Serial
       property :title_text, String, :required => true
       property :description, Text, :required => true
       property :created, DateTime
     end

You'd have to set the following options:

     BlogPost.rss_options[:title_method] = :title_text
     BlogPost.rss_options[:body_method] = :description
     BlogPost.rss_options[:date_method] = :created

And then call the `to_rss` class method as you normally would:

     BlogPost.to_rss


### Custom Finders

Sometimes you'll want to create an RSS feed of only certain objects. By default ZOMGRSS uses `:all`
as the finder, meaning it will call YourClass.all to find the records to be included in the feed. If
you want to use a different finder you can modify it through the `:finder` option:

     class BlogPost < ActiveRecord::Base
       rss_me

       # return only 5 records
       named_scope :only_five, { :limit => 5 }
     end

     BlogPost.rss_options[:finder] = :only_five
     BlogPost.to_rss  # => Will create a feed with only 5 items.

You can also pass options to your custom finders to use more complex queries:

     class BlogPost < ActiveRecord::Base
       rss_me

       # returns 'max-min' records
       named_scope :limit, lambda { |max, min| { :limit => (max - min) } }
     end

     BlogPost.rss_options[:finder] = :limit
     BlogPost.rss_options[:finder_options] = [10,5]
     BlogPost.to_rss  # => Creates a feed with only 5 items.

### GUIDs

Every RSS item needs to have an unique identifier. The current format used by ZOMGRSS follows the
Movable Type convention: "id@http://example.com" (as in _342@http://blog.hipsterbrian.com_). If you
need to change this you can set a custom GUID format:

     BlogPost.rss_options[:guid_format] = "http://blog.hipsterbrian.com/unique/:id"

ZOMGRSS will replace the `:id` in the format for the object's ID.


TODO
----
* Allow the user to set global default options. Right now you'll have to set the default options for
each new RSS feed you want to create.
* Support for Atom?
* Allow lambdas instead of methods in rss_options (useful to return a text snippet of a field).
* Create Rubygem (iknorite?)

Most of these can be easily implemented but I haven't needed them so far. If you'd like to see them
included please let me know.

Contact
--------
* **Email**: federico@mheroin.com
