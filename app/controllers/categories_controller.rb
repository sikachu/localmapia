class CategoriesController < ApplicationController
  def index
    @location_categories = Category.first_level.for_location(:include => :children, :order => "title")
    @event_categories = Category.for_event(:order => "title")
    @tags = Tag.find_by_sql("SELECT tags.*, (COALESCE(c1.count_all,0) + COALESCE(c2.count_all,0)) AS sum_count_all FROM tags LEFT JOIN (SELECT tag_id, COUNT(*) AS count_all FROM events_tags GROUP BY tag_id) AS c1 ON c1.tag_id = tags.id LEFT JOIN (SELECT tag_id, COUNT(*) AS count_all FROM locations_tags GROUP BY tag_id) as c2 ON c2.tag_id = tags.id ORDER BY sum_count_all DESC LIMIT 30")
    @tag_min_count = @tags.last.sum_count_all.to_i
    @tags.sort!{ |x,y| x.name <=> y.name }
  end
  
  def show
    prepare_offset_vars
    @category = Category.find_by_permalink!(params[:parent])
    @category = @category.children.find_by_permalink!(params[:id], :include => :parent) if params[:id]
    @collection = @category.send(params[:object_type]).all(:order => order, :offset => @offset, :limit => 10)
  end
  
  protected
  
  def prepare_offset_vars
    params[:type] = "title" unless %w(title added updated).include?(params[:type])
    params[:page] ||= 1
    
    @offset = (params[:page].to_i - 1) * 10 rescue 0
  end
  
  def order
    case params[:type]
    when "title"
      params[:object_type] == "events" ? "name" : "title"
    when "added"
      "id DESC"
    when "updated"
      "updated_at DESC"
    end
  end
end