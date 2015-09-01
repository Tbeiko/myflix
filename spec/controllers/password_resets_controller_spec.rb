require 'spec_helper'

describe PasswordResetsController do 
  describe "GET show" do 
    let(:user) { Fabricate(:user) }

    # This would happen when the user clicks the forgot password link
    before do 
      user.generate_token
    end

    it "renders show template if the token is valid" do 
      get :show, id: user.token
      expect(response).to render_template :show
    end

    it "sets @token" do 
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
      let(:user) { Fabricate(:user, password: "oldpassword") }
    
      # This would happen when the user clicks the forgot password link
      before do
        user.generate_token
      end

      it "redirects to the sign in page" do 
        post :create, token: user.token, password: "newpassword", confirm_password: "newpassword"
        expect(response).to redirect_to sign_in_path
      end

      it "updates the user's password" do 
        post :create, token: user.token, password: "newpassword", confirm_password: "newpassword"
        expect(user.reload.authenticate('newpassword')).to be_truthy 
      end

      it "sets the flash success message" do 
        post :create, token: user.token, password: "newpassword", confirm_password: "newpassword"
        expect(flash[:success]).to be_present
      end

      it "removes the users's token" do 
        old_token = user.token
        post :create, token: user.token, password: "newpassword", confirm_password: "newpassword"
        expect(user.reload.token).to be_nil
      end
    end

    context "with invalid token" do 
      it "redirects to the expired token path" do 
        post :create, token: "12345" , password: "newpassword", confirm_password: "newpassword"
        expect(response).to redirect_to expired_token_path
      end
    end

    context "with non-matching passwords" do 
      let(:user) { Fabricate(:user, password: "oldpassword") }

      # This would happen when the user clicks the forgot password link
      before do
        user.generate_token
      end

      it "renders an error message" do 
        post :create, token: user.token, password: "newpassword", confirm_password: "anotherpassword"
        expect(flash[:danger]).to be_present
      end

      it "renders the show template" do 
        post :create, token: user.token, password: "newpassword", confirm_password: "anotherpassword"
        expect(response).to render_template :show
      end
    end

    context "with too many attempts" do 
      let(:user) { Fabricate(:user, password: "oldpassword") }
      it "redirects to the expired token path" do 
        post :create, token: user.token, password: "newpassword", confirm_password: "anotherpassword"
        post :create, token: user.token, password: "newpassword", confirm_password: "anotherpassword"
        post :create, token: user.token, password: "newpassword", confirm_password: "anotherpassword"
        post :create, token: user.token, password: "newpassword", confirm_password: "anotherpassword"
        require 'pry'; binding.pry
        expect(response).to redirect_to expired_token_path
      end
    end 
  end
end