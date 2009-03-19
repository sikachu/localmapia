class CategoryField < ActiveRecord::Base
  belongs_to :category
  
  FIELD_TYPE = %w(text textarea select checkbox date time datetime)
  serialize :collection
  
  validates_presence_of :name
  validates_inclusion_of :field_type, :in => FIELD_TYPE
end
