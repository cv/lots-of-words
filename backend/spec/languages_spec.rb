require File.dirname(__FILE__) + '/spec_helper'

describe Languages do

  it "should render info about a language" do
    get(url(:counts, :language => 'en')).status.should == 200
  end
  
  it "should render info about a source and a target language" do
    get(url(:link_counts, :source => 'en', :target => 'pt')).status.should == 200
  end
  
  it "should render info about a term being translated from source to target language" do
    get(url(:link, :source => 'en', :target => 'pt', :term => 'house')).status.should == 200
  end
  
end