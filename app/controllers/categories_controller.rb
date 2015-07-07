class CategoriesController < ApplicationController
  before_action :find_category, only: [:show, :recent_videos]

  def show
  end

  private
    def find_category
      @category = Category.find_by(id: params[:id])
    end
end