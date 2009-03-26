class Mailer < ActionMailer::Base
  def activation_email(user)
    from "LocalMapia <noreply@localmapia.com>"
    recipients user.email
    subject "[LocalMapia] Your activation instructions"
    body :user => user
  end
  
  def invite_email(user, email)
    from "LocalMapia <noreply@localmapia.com>"
    recipients email.recipient
    subject "[LocalMapia] You've been invited!"
    body :content => email.content
  end
end
