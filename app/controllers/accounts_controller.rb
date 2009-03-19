class AccountsController < ApplicationController
  before_filter :check_login, :except => [:new, :create, :status, :activate]
  
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
    if @u.save
      Mailer.deliver_activation_email(@u)
    else
      @u.password = @u.password_confirmation = ""
      render :new
    end
  end
  
  def status
    render :status, :layout => false
  end
  
  def activate
    if @u = User.find_by_activation_key(params[:id])
      @u.activate!
      @session.login! :email => @u.email, :password => @u.password
    end
  end

end
