class Mailer < ActionMailer::Base
  def activation_email(user)
    from "LocalMapia <noreply@localmapia.com>"
    recipients user.email
    title "[LocalMapia] Your activation instructions"
    body :user => user
  end
end
