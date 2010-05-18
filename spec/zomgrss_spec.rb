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
    SuperSomething.rss_options.should == default_rss_options
  end

  it "adds options to the current options if they exist" do
    SuperSomething.rss_options(:title => "My new title")
    SuperSomething.rss_options.should == default_rss_options.merge(:title => "My new title")
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
    SuperSomething.rss_options[:date_field].should == :created_at
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
  it "returns an RSS feed from all the items"
  it "uses the correct feed base data"
  it "replaces :link_format with the actual item link"
  it "uses :created_at or a custom field for the item's date"
  it "generates a MovableType-like GUID from the items "
  it "can use a custom GUID format"
  it "can use a custom finder to fetch the objects"
  it "can pass custom options to the finder"
  it "supports custom title methods"
  it "supports custom body methods"
  it "supports HTML content in the body"
end
