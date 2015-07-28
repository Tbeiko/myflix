require 'spec_helper'

describe ReviewsController do 

  describe "POST create" do 
    let(:video) { Fabricate(:video) }
    context "with authenticated users" do 
      let(:current_user) { Fabricate(:user) }
      before { session[:user_id] = current_user.id}
      context "with valid input" do 
        before do 
          post :create, review: Fabricate.attributes_for(:review), :video_id => video.id
        end

        it "creates the review" do 
          expect(Review.count).to eq(1)
        end

        it "creates a review associated with the video" do 
          expect(Review.first.video).to eq(video)
        end

        it "creates a review associated with current user" do
          expect(Review.last.user).to eq(current_user)
        end

        it "redirects to the video show page" do 
          expect(response).to redirect_to video_path(video)
        end
        it "sets the notice" do 
          expect(flash[:success]).not_to be_blank
        end
      end

      context "with invalid input" do 
        let(:user) { Fabricate(:user) }

        it "does not create the review" do 
          post :create, review: {rating: 1}, :video_id => video.id
          expect(Review.count).to eq(0)
        end

        it "should render the video show page" do 
          post :create, review: {rating: 1}, :video_id => video.id
          expect(response).to render_template 'videos/show'
        end

        it "sets @video" do 
          post :create, review: {rating: 1}, :video_id => video.id
          expect(assigns(:video)).to eq(video)
        end

        it "sets @reviews" do 
          review = Fabricate(:review, video: video)
          post :create, review: {rating: 1}, :video_id => video.id
          expect(assigns(:reviews)).to match_array([review])
        end

        it "sets the error" do 
          post :create, review: {rating: 1}, :video_id => video.id
          expect(flash[:danger]).not_to be_blank
        end
      end
    end 

    context "with unauthenticated users" do 
      it "redirects to the sign in path" do 
        post :create, review: Fabricate.attributes_for(:review), :video_id => video.id
        expect(response).to redirect_to sign_in_path
      end
    end   
  end
end