require 'digest'

module Authentication
  # This should be included in ApplicationController
  module Helpers
    def self.included(klass)
      klass.before_filter :initialize_session
      klass.helper_method :logged_in?
    end
  
    protected
  
    def logged_in?
      @session.logged_in?
    end
  
    def initialize_session
      @session = Authentication::Session.new(session,cookies)
      @user = @session.user
    end
  
    def redirect_back(redirect_opts = nil)
      redirect_opts ||= {:controller => 'public'}
      request.env["HTTP_REFERER"] ? redirect_to(request.env["HTTP_REFERER"]) : redirect_to(redirect_opts)
    end
  
    def check_login
      redirect_to login_path(:to => request.path) unless @user
    end
  end
  
  # This should be included in a controller that used for login/logout, maybe SessionsController?
  module Controller
    def new
      @session.set(params[:session].slice(:email, :password)) rescue nil
      redirect_to :controller => "public" if logged_in?
    end

    def create
      unless logged_in? or @session.login!(params[:session])
        flash[:error] = "Unable to find any user with that email/password combinations."
        redirect_to "/login#{"?to=#{params[:to]}" if params[:to].present?}"
      else
        redirect_to params[:to] || "/"
      end
    end

    def destroy
      @session.logout!
      redirect_to root_path
    end
  end
  
  # This should be included in User model
  module Model
    def auto_login_hash
      unless self[:auto_login_hash]
        self[:auto_login_hash] = Digest::SHA1.hexdigest("#{email}#{id}#{created_at}")
        self.save
      end
      self[:auto_login_hash]
    end
  end
  
  # This is just a wrapper class to wrap those login/logout process
  class Session
    attr_accessor :user, :email, :password, :remember_me

    def initialize(session, cookies)
      @session = session
      @cookies = cookies
      load_user
    end

    def login!(params)
      @user = 
        if User.respond_to?(:online)
          User.online.find_by_email(params[:email])
        else
          User.find_by_email(params[:email])
        end
      if @user and @user.password == params[:password]
        @session[:user_id] = @user.id
        @user.update_login!
        if params[:remember_me]
          @cookies["_userid"] = { :value => @user.id.to_s, :expires => 1.year.from_now }
          @cookies["_hash"] = { :value => @user.auto_login_hash, :expires => 1.year.from_now }
        end
      else
        @user = nil
      end
      @user
    end

    def logout!
      @session[:user_id] = nil
      @cookies["_userid"] = nil
      @cookies["_hash"] = nil
    end

    def logged_in?
      !@session[:user_id].nil?
    end

    def user
      @user ||= load_user
    end

    def set(opts)
      opts.each_pair{ |key, val| send("#{key.to_s}=", val) } if opts.class == Hash
    end

    protected

    def load_user
      if @cookies["_userid"].present?
        @user = User.find_by_id(@cookies["_userid"])
        if @user.nil? or @user.auto_login_hash != @cookies["_hash"]
          @user = nil
        else
          @session[:user_id] = @user.id 
        end
      elsif @session[:user_id]
        @user = User.find_by_id(@session[:user_id])
      end

      logout! if @user.nil? and @session[:user_id].present?
    end
  end
end