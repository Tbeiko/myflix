require 'spec_helper'

describe VideosController do 
  describe "GET show" do 

    context "authenticated users" do 
      let(:user) { Fabricate(:user) }
      let(:video) { Fabricate(:video) }

      before { session[:user_id] = user.id }

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

    it "redirects to sign in page if unauthenticated" do 
      video = Fabricate(:video)
      get :show, id: video.id
      expect(response).to redirect_to sign_in_path        
    end

    describe "POST search" do 
      it "sets @results for authenticated user" do 
        session[:user_id] = Fabricate(:user).id 
        futurama = Fabricate(:video, title: 'Futurama')
        post :search, search_term: 'rama'
        expect(assigns(:results)).to eq([futurama])
      end

      it "redirects to sign in page if unauthenticated" do 
        futurama = Fabricate(:video, title: 'Futurama')
        post :search, search_term: 'rama'
        expect(response).to redirect_to sign_in_path  
      end
    end
  end
end