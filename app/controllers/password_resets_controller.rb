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
    @attempts = 0 
    user = User.find_by(token: params[:token])

    if user && too_many_attempts?
      flash[:danger] = "Too many attemps. Your reset link has expired."
      redirect_to expired_token_path

    elsif user
      if update_succesful?(user)
        flash[:success] = "Your password was successfully updated."
        user.remove_token
        redirect_to sign_in_path
      elsif passwords_match?
        @token = user.token
        @attempts += 1
        flash[:danger] = "Invalid password."
        render :show
      else 
        @attempts += 1
        flash[:danger] = "The passwords didn't match"
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

  def too_many_attempts?
    @attempts >= 3
  end

  def passwords_match?
    params[:password] == params[:confirm_password]
  end
end