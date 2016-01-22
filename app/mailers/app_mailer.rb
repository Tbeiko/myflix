class AppMailer < ActionMailer::Base
  default from: "hi@timflix.herokuapp.com"

  def send_welcome_email(user_id)
    @user = User.find_by(id: user_id)
    mail to: @user.email, subject: "Welcome to Myflix!"
  end

  def send_forgot_password(user_id)
    @user = User.find_by(id: user_id)
    mail to: @user.email, subject: "Password Reset Link"
  end

  def send_invitation_email(invitation_id)
    @invitation = Invitation.find_by(id: invitation_id)
    mail to: @invitation.recipient_email, subject: "Your friend thinks you should join MyFlix!"
  end
end