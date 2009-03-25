# == Schema Information
# Schema version: 20090325065024
#
# Table name: reports
#
#  id          :integer(4)      not null, primary key
#  user_id     :integer(4)
#  object_type :string(255)
#  object_id   :integer(4)
#  content     :text
#  created_at  :datetime
#  updated_at  :datetime
#

class Report < ActiveRecord::Base
  belongs_to :user
  belongs_to :object, :polymorphic => true
  
  validates_presence_of :user
  validates_presence_of :object
  validates_presence_of :content
end
