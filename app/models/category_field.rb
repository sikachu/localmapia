# == Schema Information
# Schema version: 20090325065024
#
# Table name: category_fields
#
#  id          :integer(4)      not null, primary key
#  category_id :integer(4)
#  name        :string(255)
#  field_type  :string(255)
#  collection  :text
#

class CategoryField < ActiveRecord::Base
  belongs_to :category
  
  FIELD_TYPE = %w(text textarea select checkbox date time datetime)
  serialize :collection
  
  validates_presence_of :name
  validates_inclusion_of :field_type, :in => FIELD_TYPE
end
