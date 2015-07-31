require 'spec_helper'

describe VideosController do 
  describe "GET show" do 

    context "authenticated users" do 
      let(:user) { Fabricate(:user) }
      let(:video) { Fabricate(:video) }

      before { set_current_user(user) }

      it "sets @video for authenticated users" do 
        get :show, id: video.id
        expect(assigns(:video)).to eq(video)
      end

      it "sets @reviews for authenticated users" do 
        review1 = Fabricate(:review, video: video)
        review2 = Fabricate(:review, video: video)
        get :show, id: video.id 
        expect(assigns(:reviews)).to match_array([review1, review2])
      end

      it "sets @review for authenticated users" do 
        get :show, id: video.id 
        expect(assigns(:review)).to be_instance_of(Review)
      end
    end

      it_behaves_like "require signed in user" do 
        let(:action) do 
          get :show, id: Fabricate(:video).id
        end
      end

    describe "POST search" do 
      it "sets @results for authenticated user" do 
        set_current_user
        futurama = Fabricate(:video, title: 'Futurama')
        post :search, search_term: 'rama'
        expect(assigns(:results)).to eq([futurama])
      end

      it_behaves_like "require signed in user" do 
        let(:action) do 
          post :search, search_term: 'rama'
        end
      end
    end
  end
end