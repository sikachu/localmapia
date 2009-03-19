require File.dirname(__FILE__) + '/../spec_helper'

describe CategoryField do
  before(:each) do
    @category_field = CategoryField.new(:name => "Some title", :field_type => "text")
    @category_field.should be_valid
  end
  
  it "should have name" do
    @category_field.should be_valid
    @category_field.name = ""
    @category_field.should_not be_valid
    @category_field.should have_exactly(1).error_on(:name)
  end
  
  it "should accepts only allowed field_type" do
    [nil, "bogus"].each do |ft|
      @category_field.field_type = ft
      @category_field.should have_exactly(1).error_on(:field_type)
    end
    CategoryField::FIELD_TYPE.each do |ft|
      @category_field.field_type = ft
      @category_field.should be_valid
    end
  end

  it "should be able to store serialize value" do
    @category_field.collection = [["Google", "google"], ["Yahoo", "yahoo"]]
    @category_field.save
    CategoryField.first.collection.should eql([["Google", "google"], ["Yahoo", "yahoo"]])
  end
end
