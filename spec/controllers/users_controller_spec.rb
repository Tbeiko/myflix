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

    context "with valid input and invitation token" do 
      it "makes the user follow the inviter" do 
        user = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: user)
        post :create, user: { name: invitation.recipient_name, email: invitation.recipient_email, password: "password"}, invitation_token: invitation.token
        new_user = User.find_by(email: invitation.recipient_email)
        expect(new_user.follows?(user)).to be_truthy
      end

      it "makes the inviter follow the user" do 
        user = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: user)
        post :create, user: { name: invitation.recipient_name, email: invitation.recipient_email, password: "password"}, invitation_token: invitation.token
        new_user = User.find_by(email: invitation.recipient_email)
        expect(user.follows?(new_user)).to be_truthy
      end

      it "expires the invitation" do 
        user = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: user)
        post :create, user: { name: invitation.recipient_name, email: invitation.recipient_email, password: "password"}, invitation_token: invitation.token
        expect(Invitation.first.token).to be_nil
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

    context "sending emails" do 
      after { ActionMailer::Base.deliveries.clear }

      it "sends out email to the user with valid inputs" do 
        post :create, user: { name: "John Doe", email: "john@doe.com", password: "123456" }
        expect(ActionMailer::Base.deliveries.last.to).to eq(["john@doe.com"])
      end

      it "send out email containing the users's name with valid input" do 
        post :create, user: { name: "John Doe", email: "john@doe.com", password: "123456" }
        expect(ActionMailer::Base.deliveries.last.body).to include("John Doe")
      end
      
      it "does not send out email with invalid inputs" do 
        post :create, user: { name: "John Doe", email: "john@doe.com", password: nil }
        expect(ActionMailer::Base.deliveries).to be_empty
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

  describe "GET new_with_invitation_token" do 
    it "renders the :new template" do 
      invitation = Fabricate(:invitation)
      get :new_with_invitation_token, token: invitation.token
      expect(response).to render_template :new
    end

    it "sets @user with recipient's name" do 
      invitation = Fabricate(:invitation)
      get :new_with_invitation_token, token: invitation.token
      expect(assigns(:user).name).to eq(invitation.recipient_name)
    end

    it "sets @user with recipient's email" do 
      invitation = Fabricate(:invitation)
      get :new_with_invitation_token, token: invitation.token
      expect(assigns(:user).email).to eq(invitation.recipient_email)
    end

    it "sets @invitation_token" do 
      invitation = Fabricate(:invitation)
      get :new_with_invitation_token, token: invitation.token
      expect(assigns(:invitation_token)).to eq(invitation.token)
    end
  end
end