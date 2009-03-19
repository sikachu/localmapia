class SessionsController < ApplicationController
  include Authentication::Controller
  before_filter :load_new_user, :only => :new
  
  private
  
  def load_new_user
    @u = User.new
  end
end
