class SearchesController < ApplicationController
  before_filter :process_search_vars, :only => :show
  
  def index
    @search = Search.new
  end
  
  def create
    @search = Search.new(:keyword => params[:search][:keyword])
    params[:search][:keyword].strip!
    if params[:search][:keyword].present? and params[:search][:keyword].chars().size >= 2
      redirect_to search_path(@search.permalink) if @search.process!
    end
  end
  
  def show
    @search = Search.find_by_permalink(params[:id])
    @search.load_objects!("sorted_by_#{params[:type]}", @offset)
  end
  
  protected
  
  def process_search_vars
    params[:type] = "relevance" unless %w(relevance added updated).include?(params[:type])
    params[:page] ||= 1
    
    @offset = (params[:page].to_i - 1) * 10 rescue 0
  end
end