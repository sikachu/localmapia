# == Schema Information
# Schema version: 20090325065024
#
# Table name: tags
#
#  id   :integer(4)      not null, primary key
#  name :string(255)
#

class Tag < ActiveRecord::Base
  has_and_belongs_to_many :locations
  has_and_belongs_to_many :events
  
  validates_presence_of :name
  
  def self.batch_create(params, taggable, separator=",")
    ActiveRecord::Base.transaction do
      taggable_tag_ids = taggable.tag_ids
      params[:name].split(separator).each do |tag|
        tag_object = Tag.find_or_create_by_name(:name => tag.strip)
        taggable.tags << tag_object unless taggable_tag_ids.include? tag_object.id
      end
    end
  end
end
