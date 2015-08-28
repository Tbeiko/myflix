require 'spec_helper'

describe ForgotPasswordsController do 
  describe "post CREATE" do 
    context "with blank input" do 
      it "redirects to the forgot password page" do
        post :create, email: ''
        expect(response).to redirect_to forgot_password_path
      end
      it "shows an error message" do 
        post :create, email: ''
        expect(flash[:danger]).to be_present
      end
    end

    context "with existing email" do 
      it "redirects to the forgot password confirmation page" do 
        Fabricate(:user, email: "tim@bagel.com")
        post :create, email: "tim@bagel.com"
        expect(response).to redirect_to forgot_password_confirmation_path
      end
      it "sends out an email to the email address" do 
        Fabricate(:user, email: "tim@bagel.com")
        post :create, email: "tim@bagel.com"
        expect(ActionMailer::Base.deliveries.last.to).to eq(["tim@bagel.com"])
      end
    end

    context "with non-existing email" do 
      it "redirects to the forgot password page" do 
        post :create, email: "tim@bagel.com"
        expect(response).to redirect_to forgot_password_path
      end

      it "shows an error message" do 
        post :create, email: "tim@bagel.com"
        expect(flash[:danger]).to be_present
      end
    end
  end
end