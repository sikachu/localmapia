class ReportsController < ApplicationController
  def new
    if %w(event location).include? params[:type]
      @object = params[:type] == "event" ? Event.find(params[:id]) : Location.find(params[:id])
      @report = Report.new(:object => @object)
    else
      raise ActiveRecord::RecordNotFound, "Unable to find an object you want to report"
    end
  end
  
  def create
    @report = @user.reports.build(params[:report])
    unless @report.save
      render :new
    end
  end
end