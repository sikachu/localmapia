class AccountsController < ApplicationController
  before_filter :check_login, :except => [:new, :create]
  
  def show
  end

  def edit
  end

  def update
  end

  def new
    @u = User.new
  end

  def create
    @u = User.new(params[:user])
    unless @u.save
      @u.password = @u.password_confirmation = ""
      render :new
    end
  end

end
