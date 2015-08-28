require 'spec_helper'

describe PasswordResetsController do 
  describe "GET show" do 
    it "renders show template if the token is valid" do 
      user = Fabricate(:user)
      get :show, id: user.token
      expect(response).to render_template :show
    end

    it "sets @token" do 
      user = Fabricate(:user)
      get :show, id: user.token
      expect(assigns(:token)).to eq(user.token)
    end

    it "redirects to the expired token page if the token is invalid" do 
      get :show, id: '123456'
      expect(response).to redirect_to expired_token_path
    end
  end

  describe "POST create" do 
    context "with valid token" do 
      it "redirects to the sign in page" do 
        user = Fabricate(:user, password: "oldpassword")
        post :create, token: user.token, password: "newpassword"
        expect(response).to redirect_to sign_in_path
      end

      it "updates the user's password" do 
        user = Fabricate(:user, password: "oldpassword")
        post :create, token: user.token, password: "newpassword"
        expect(user.reload.authenticate('newpassword')).to be_truthy 
      end

      it "sets the flash success message" do 
        user = Fabricate(:user, password: "oldpassword")
        post :create, token: user.token, password: "newpassword"
        expect(flash[:success]).to be_present
      end

      it "regenerates the users's token" do 
        user = Fabricate(:user, password: "oldpassword")
        old_token = user.token
        post :create, token: user.token, password: "newpassword"
        expect(user.reload.token).not_to eq(old_token)
      end
    end

    context "with invalid token" do 
      it "redirects to the expired token path" do 
        post :create, token: "12345" , password: "newpassword"
        expect(response).to redirect_to expired_token_path
      end
    end
  end
end