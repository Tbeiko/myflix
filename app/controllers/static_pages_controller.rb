class StaticPagesController < ApplicationController

  def front
    redirect_to home_path if current_user
  end
end