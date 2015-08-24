require 'spec_helper'

describe UsersController do 
  describe "GET new" do 
    it "sets @user" do 
      get :new
      expect(assigns(:user)).to be_instance_of(User)
    end
  end

  describe "POST create" do 
    context "with valid input" do 
      before { post :create, user: Fabricate.attributes_for(:user) }
      it "creates the user" do 
        expect(User.count).to eq(1)
      end
      it "redirects to sign in page" do 
        expect(response).to redirect_to sign_in_path
      end
    end
    context "with invalid input" do 
      before do 
        post :create, user: { password: "password", name: "Tim Bagel"} 
      end
      
      it "does not create a user" do 
        expect(User.count).to eq(0)
      end
      it "renders the :new template" do 
        expect(response).to render_template :new
      end
      it "sets @user" do 
        expect(assigns(:user)).to be_instance_of(User)
      end
    end
  end

  describe "GET show" do 
    it_behaves_like "require signed in user" do 
      let(:action) { get :show, id: 3 }
    end

    it "sets @user" do 
      set_current_user
      user = Fabricate(:user)
      get :show, id: user.id 
      expect(assigns(:user)).to eq(user)
    end
  end
end