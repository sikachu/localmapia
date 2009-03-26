require 'digest'

class Search < ActiveRecord::Base
  serialize :sorted_by_relevance
  serialize :sorted_by_added
  serialize :sorted_by_updated
  
  def process!
    # Find each collection, then stores it to global array using merge_result_data
    merge_result_data :location, Location.all(:conditions => ["title LIKE ? OR description LIKE ?", "%#{keyword}%", "%#{keyword}%"])
    merge_result_data :event, Event.all(:conditions => ["name LIKE ? OR description LIKE ?", "%#{keyword}%", "%#{keyword}%"])
    
    if tag = Tag.find_by_name(keyword, :include => [:locations, :events])
      merge_result_data :location, tag.locations
      merge_result_data :event, tag.events
    end
    
    # Sort the object ids based on criteria
    self.sorted_by_relevance = result_object_ids.sort do |y,x| # Max -> Min
      fetch_object(x).title.count(keyword) + fetch_object(x).description.count(keyword) <=> fetch_object(y).title.count(keyword) + fetch_object(y).description.count(keyword)
    end
    self.sorted_by_added = result_object_ids.sort do |y,x|
      fetch_object(x).created_at <=> fetch_object(y).created_at
    end
    self.sorted_by_updated = result_object_ids.sort do |y,x|
      fetch_object(x).updated_at <=> fetch_object(y).updated_at
    end
    
    # Done! Now save the data
    self.permalink = Digest::SHA1.hexdigest("#{rand(2**100)}#{Time.now.to_s}") # Avoid collision
    self.save!
  end
  
  def fetch_object(id)
    result_objects.assoc(id)[1] rescue nil
  end
  
  def load_objects!(type, offset=0, limit=10)
    # construct array for using with search
    location_ids, event_ids = [], []
    self.send(type).each do |object_type_and_id|
      object_type, object_id = object_type_and_id.split(/-/)
      if object_type == "location"
        location_ids << object_id
      else
        event_ids << object_id
      end
    end
      
    merge_result_data :location, Location.find_all_by_id(location_ids)
    merge_result_data :event, Event.find_all_by_id(event_ids)
  end
  
  private
  
  def merge_result_data(type, objects)
    self.result_objects = result_objects | objects.collect{ |obj| ["#{type}-#{obj.id}", obj] }
  end
  
  def result_objects
    @result_objects ||= []
  end
  
  def result_objects=(args)
    @result_objects = args
  end
  
  def result_object_ids
    result_objects.collect{ |r| r.first }
  end
end
