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
    if user && user.update(password: params[:password])
      flash[:success] = "Your password was successfully updated."
      redirect_to sign_in_path
    elsif user
      @token = user.token
      flash[:danger] = "Invalid password."
      render :show
    else
      redirect_to expired_token_path
    end

    if user
      user.remove_token
    end
  end
end