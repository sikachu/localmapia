class MailsController < ApplicationController
  before_filter :check_login, :load_mailable

  def new
    @mail = Mail.new
    @mail.content = "Hello,\n\nYour friend, #{@user.displayname} (#{@user.email}) thinks that you would like to know more about this #{@mailable.class.to_s.downcase}.\n\nYou can visit the page here:\n\nhttp://localmapia.com#{object_permalink(@mailable)}\n\n\nThank you,\n\nLocalMapia Team"
  end
  
  def create
    @mail = Mail.new
    @mail.content = params[:mail][:content]
    @mail.recipient = params[:mail][:recipient]
    Mailer.deliver_invite_email(@user, @mail)
    
    flash[:notice] = "Your emai has been sent!"
    redirect_to object_permalink(@mailable)
  end

  private
  
  def load_mailable
    @mailable = if params[:event_id]
        Event.find(params[:event_id])
      else
        Location.find(params[:location_id])
      end
    @location = @mailable.location rescue @mailable
  end
end