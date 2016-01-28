require 'spec_helper'

describe ReviewsController do 

  describe "POST create" do 
    let(:video) { Fabricate(:video) }
    context "with authenticated users" do 
      let(:current_user) { Fabricate(:user) }
      before { set_current_user(current_user) }
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
          expect(flash[:success]).to be_present
        end
      end

      context "with invalid input" do 
        let(:user) { Fabricate(:user) }
        before { post :create, review: {rating: 1}, :video_id => video.id }

        it "does not create the review" do 
          expect(Review.count).to eq(0)
        end

        it "should render the video show page" do 
          expect(response).to render_template 'videos/show'
        end

        it "sets @video" do 
          expect(assigns(:video)).to eq(video)
        end

        it "sets @reviews" do 
          review = Fabricate(:review, video: video)
          post :create, review: {rating: 1}, :video_id => video.id
          expect(assigns(:reviews)).to match_array([review])
        end

        it "sets the error" do 
          expect(flash[:danger]).to be_present
        end
      end
    end 

    it_behaves_like "require signed in user" do 
      let(:action) do 
        post :create, review: Fabricate.attributes_for(:review), :video_id => video.id
      end
    end
  end
end