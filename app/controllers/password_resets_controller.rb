class PasswordResetsController < ApplicationController
  def show
    user = User.find_by(token: params[:id])
    if user 
      @token = user.token
    else
      redirect_to expired_token_path 
    end
  end

  def create
    user = User.find_by(token: params[:token])

    if user
      if update_succesful?(user)
        flash[:success] = "Your password was successfully updated."
        user.remove_token
        redirect_to sign_in_path
      elsif passwords_match?
        @token = user.token
        flash.now[:danger] = "Invalid password."
        render :show
      else 
        flash.now[:danger] = "The passwords didn't match"
        render :show
      end

    else 
      redirect_to expired_token_path
    end
  end

  private 

  def update_succesful?(user)
    user && user.update(password: params[:password]) && passwords_match?
  end

  def passwords_match?
    params[:password] == params[:confirm_password]
  end
end