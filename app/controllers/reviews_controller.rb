class ReviewsController < ApplicationController 

  def create
    @review = Review.new(review_params)

    if @review.save
      flash[:success] = "Your review was added to this video."
      redirect_to video_path(Video.find params[:video_id])
    else
      flash[:danger] = "Something went wrong, please try again."
      render '/videos/show'
    end
  end

  private 
  def review_params
    params.require(:review).permit(:rating, :content, :video_id, :user_id)
  end

end