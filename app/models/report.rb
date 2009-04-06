class Report < ActiveRecord::Base
  belongs_to :user
  belongs_to :object, :polymorphic => true
  
  validates_presence_of :user
  validates_presence_of :object
end
