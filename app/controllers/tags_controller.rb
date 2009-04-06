class TagsController < ApplicationController
  before_filter :load_taggable, :only => :create
  before_filter :check_login, :only => :create
  
  def create
    Tag.batch_create(params[:tag], @taggable)
    flash[:notice] = "Your tags has been added"
    redirect_to params[:event_id] ? event_permalink(@taggable) : location_permalink(@taggable)
  end
  
  def show
    prepare_offset_vars
    @tag = Tag.find_by_name!(params[:id])
    @collection_count = @tag.locations.size + @tag.events.size
    @collection = (@tag.locations + @tag.events).sort{ |x,y| order(x,y) }[@offset, 10]
  end
  
  private
  
  def load_taggable
    @taggable = if params[:event_id]
        Event.find(params[:event_id])
      else
        Location.find(params[:location_id])
      end
  end
  
  def prepare_offset_vars
    params[:type] = "title" unless %w(title added updated).include?(params[:type])
    params[:page] ||= 1
    
    @offset = (params[:page].to_i - 1) * 10 rescue 0
  end
  
  def order(x,y)
    case params[:type]
    when "title"
      (x.respond_to?(:title) ? x.title : x.name) <=> (y.respond_to?(:title) ? y.title : y.name)
    when "added"
      (y.id <=> x.id)
    when "updated"
      (y.updated_at <=> x.updated_at)
    end
  end
end