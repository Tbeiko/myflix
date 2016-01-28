class ForgotPasswordsController < ApplicationController
  def create
    user = User.find_by(email: params[:email])
    if user
      user.generate_token
      AppMailer.delay.send_forgot_password(user.id)
      redirect_to forgot_password_confirmation_path
    else
      flash[:danger] = params[:email].blank? ? "Oops! It seems you forgot to enter your email." : "It seems like that email is not valid."
      redirect_to forgot_password_path
    end
  end

  def confirm
  end

end