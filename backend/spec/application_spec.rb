require File.dirname(__FILE__) + '/spec_helper'

describe Application do
  
  it "should connect to CouchDB before invoking any actions" do
    $couchdb.should_not be_nil
    $lexicon.should_not be_nil
  end
  
end