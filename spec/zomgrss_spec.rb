require "spec_helper"

describe "Installation" do
  it "is done by calling 'rss_me'" do
    lambda { class Throwaway; rss_me; end }.should_not raise_error
  end

  it "provides .to_rss to the class" do
    c = class Throwaway; rss_me; end
    c.should respond_to(:to_rss)
  end
end

describe "Options" do
  it "provides default options if there are none set" do
    SuperSomething.rss_options.should == default_options
  end

  it "adds options to the current options if they exist" do
    SuperSomething.rss_options(:title => "My new title")
    SuperSomething.rss_options.should == default_options.merge(:title => "My new title")
  end

  it "includes a feed title" do
    SuperSomething.rss_options[:title].should_not be_nil
  end

  it "includes a feed description" do
    SuperSomething.rss_options[:description].should_not be_nil
  end

  it "includes a feed base URL" do
    SuperSomething.rss_options[:base_url].should_not be_nil
  end

  it "includes a custom title method, defaulted to :title" do
    SuperSomething.rss_options[:title_method].should == :title
  end

  it "includes a custom body method, defaulted to :body" do
    SuperSomething.rss_options[:body_method].should == :body
  end

  it "includes a link format for the feed items" do
    SuperSomething.rss_options[:link_format].should_not be_nil
  end

  it "includes a date field for the feed items, defaulted to :created_at" do
    SuperSomething.rss_options[:date_method].should == :created_at
  end

  it "includes a GUID format for the feed items" do
    SuperSomething.rss_options[:guid_format].should_not be_nil
  end

  it "includes a custom finder method, defaulted to :all" do
    SuperSomething.rss_options[:finder].should == :all
  end

  it "includes the options for the custom finder method, defaulted to nil" do
    SuperSomething.rss_options[:finder_options].should be_nil
  end
end

describe "ZOMGRSS.to_rss" do
  before :each do
    parse_feed
  end

  after :each do
    SuperSomething.rss_options(default_options)
  end

  it "returns a a well formed RSS feed" do
    @feed.errors.should be_empty
  end

  it "uses the correct feed base data" do
    @feed.at_css("channel title").text.should == default_options[:title]
    @feed.at_css("channel description").text.should == default_options[:description]
    @feed.at_css("channel link").text.should == default_options[:base_url]
  end

  it "replaces :link_format with the actual item link" do
    expected = default_options[:link_format].gsub(":id", "4")
    @feed.at_css("channel item link").text.should == expected
  end

  it "uses :created_at or a custom field for the item's date" do
    expected = "Sat, 04 Apr 1987 02:00:00 -0000"
    @feed.at_css("channel item pubDate").text.should == expected

    SuperSomething.rss_options(:date_method => :fecha)
    @feed.at_css("channel item pubDate").text.should == expected
  end

  it "generates a MovableType-like GUID from the items " do
    expected = default_options[:guid_format].gsub(":id", "4")
    @feed.at_css("channel item guid").text.should == expected
  end

  it "can use a custom GUID format" do
    expected = "http://something.com/4"

    SuperSomething.rss_options[:guid_format] = "http://something.com/:id"
    parse_feed
    @feed.at_css("channel item guid").text.should == expected
  end

  it "can use a custom finder to fetch the objects" do
    @feed.css("channel item").length.should == 3

    SuperSomething.rss_options[:finder] = :some
    parse_feed
    @feed.css("channel item").length.should == 1
  end

  it "can pass custom options to the finder" do
    @feed.css("channel item").length.should == 3

    SuperSomething.rss_options[:finder] = :some
    SuperSomething.rss_options[:finder_options] = 2
    parse_feed
    @feed.css("channel item").length.should == 2
  end

  it "explodes custom finder options" do
    @feed.css("channel item").length.should == 3

    SuperSomething.rss_options[:finder] = :some
    SuperSomething.rss_options[:finder_options] = [2, Time.utc(1987, "may", 4, 2, 0, 0)]
    parse_feed
    @feed.css("channel item").length.should == 2
    @feed.at_css("channel item pubDate").text.should == "Mon, 04 May 1987 02:00:00 -0000"
  end

  it "supports custom title methods" do
    @feed.at_css("channel item title").text.should == "SuperTitle!"

    SuperSomething.rss_options[:title_method] = :titulo
    parse_feed
    @feed.at_css("channel item title").text.should == "SuperTitle!"
  end

  it "supports custom body methods" do
    @feed.at_css("channel item description").text.should == '<p><img src="http://mheroin.com/img.jpg" />SuperBody!!</p>'

    SuperSomething.rss_options[:body_method] = :cuerpo
    parse_feed
    @feed.at_css("channel item description").text.should == '<p><img src="http://mheroin.com/img.jpg" />SuperBody!!</p>'
  end

  it "uses a GUID with isPermaLink=false" do
    @feed.at_css("channel item guid").attributes["isPermaLink"].text.should == "false"
  end
end
