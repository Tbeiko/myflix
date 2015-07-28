require 'spec_helper'

describe ReviewsController do 

  describe "POST create" do 
    context "with valid input" do 
      let(:video) { Fabricate(:video) }
      let(:user) { Fabricate(:user) }
      before { post :create, review: Fabricate.attributes_for(:review), :video_id => video.id, :user_id => user.id, :id => video.id }

      it "creates the review" do 
        expect(Review.count).to eq(1)
      end
      it "redirects to the video show page" do 
        expect(response).to redirect_to video_path(video)
      end
      it "sets the notice" do 
        expect(flash[:success]).not_to be_blank
      end
    end

    context "with invalid input" do 
      let(:video) { Fabricate(:video) }
      let(:user) { Fabricate(:user) }
      before { post :create, review: {rating: 1, content: nil}, :video_id => video.id, :user_id => user.id, :id => video.id }

      it "does not create the review" do 
        expect(Review.count).to eq(0)
      end

      it "should render the video show page" do 
        expect(response).to render_template 'videos/show'
      end

      it "sets the @review" do 
        expect(assigns(:review)).to be_instance_of(Review)
      end

      it "sets the error" do 
        expect(flash[:danger]).not_to be_blank
      end
    end
  end
end