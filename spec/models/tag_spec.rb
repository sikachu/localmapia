require File.dirname(__FILE__) + '/../spec_helper'

describe Tag do
  before(:each) do
    @tag = Tag.new(:name => "New tag")
    @tag.should be_valid
  end
  
  it "should have name" do
    @tag.name = ""
    @tag.should have(1).error_on(:name)
  end
end
