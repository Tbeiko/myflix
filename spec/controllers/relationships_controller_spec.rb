require 'spec_helper'

describe RelationshipsController do 
  describe "GET index" do 
    it "sets @relationship to the current user's following relationships" do 
      user1 = Fabricate(:user)
      set_current_user(user1)
      user2 = Fabricate(:user)
      relationship = Fabricate(:relationship, follower: user1, leader: user2)
      get :index
      expect(assigns(:relationships)).to eq([relationship])
    end

    it_behaves_like "require signed in user" do 
      let(:action) { get :index }
    end
  end

  it_behaves_like "require signed in user" do 
    let(:action) { get :index }
  end

  describe "DELETE destroy" do 
    it_behaves_like "require signed in user" do 
      let(:action) { delete :destroy, id: 4 }
    end

    it "deletes the relationship if the current user is the follower" do 
      user1 = Fabricate(:user)
      set_current_user(user1)
      user2 = Fabricate(:user)
      relationship = Fabricate(:relationship, follower: user1, leader: user2)
      delete :destroy, id: relationship
      expect(Relationship.count).to eq(0)
    end

    it "redirects to the people page" do 
      user1 = Fabricate(:user)
      set_current_user(user1)
      user2 = Fabricate(:user)
      relationship = Fabricate(:relationship, follower: user1, leader: user2)
      delete :destroy, id: relationship
      expect(response).to redirect_to people_path
    end
    it "does not delete the relationship if the current user is not the follower" do 
      user1 = Fabricate(:user)
      set_current_user(user1)
      user2 = Fabricate(:user)
      user3 = Fabricate(:user)
      relationship = Fabricate(:relationship, follower: user3, leader: user2)
      delete :destroy, id: relationship
      expect(Relationship.count).to eq(1)
    end

  end
end 