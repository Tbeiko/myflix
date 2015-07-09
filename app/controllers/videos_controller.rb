class VideosController < ApplicationController
  before_filter :require_user
  before_action :find_video, only: [:show]
  
  def index
    @categories = Category.all
  end

  def show
  end

  def search
    @results = Video.search_by_title(params[:search_term])
  end

  private 
    def find_video
      @video = Video.find_by(id: params[:id])
    end
end