class ReviewsController < ApplicationController 
  before_action :require_user

  def create
    @video = Video.find params[:video_id]
    @review = Review.new(review_params.merge!(user: current_user))
    @video.reviews << @review

    if @review.save
      flash[:success] = "Your review was added to this video."
      redirect_to @video
    else
      flash.now[:danger] = "Something went wrong, please try again."
      @reviews = @video.reviews.reload
      render 'videos/show'
    end
  end

  private 
  def review_params
    params.require(:review).permit(:rating, :content, :video_id, :user_id)
  end

end