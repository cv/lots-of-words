require File.dirname(__FILE__) + '/spec_helper'

describe LotsOfWords do
  
  it "should just render template" do
    get(url(:home)).status.should == 200
  end
end