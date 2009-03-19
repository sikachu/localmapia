require File.dirname(__FILE__) + '/../spec_helper'

describe Category do
  before(:each) do
    @category = Category.new(:title => "Store", :category_type => "location")
    @category.should be_valid
  end
  
  it "should have unique title if it has the same category_type" do
    @category.save
    another_category = Category.new(:title => "Store", :category_type => "location")
    another_category.should_not be_valid
    another_category.should have_exactly(1).error_on(:title)
    another_category.category_type = "event"
    another_category.should be_valid
  end
  
  it "should have title" do
    @category.should be_valid
    @category.title = ""
    @category.should have_exactly(1).error_on(:title)
  end
  
  it "should have only valid category type (location, event)" do
    [nil, "bogus"].each do |ct|
      @category.category_type = ct
      @category.should have_exactly(1).error_on(:category_type)
    end
    Category::CATEGORY_TYPE.each do |ct|
      @category.category_type = ct
      @category.should be_valid
    end
  end
  
  it "should automatically generate navigation (1 level)" do
    @category.save
    @category.navigation.should eql(["Store"])
  end
  
  it "should automatically generate navigation (2+ level)" do
    @category.save
    another_category = Category.create(:title => "Book store", :category_type => "location", :parent_id => @category.id)
    another_category.navigation.should eql(["Store", "Book store"])
  end
  
  it "should automatically resize photo, and put them in appropriate folders"
end
