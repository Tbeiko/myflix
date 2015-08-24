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
    let(:user1) { Fabricate(:user) } 
    let(:user2) { Fabricate(:user) } 

    before do 
      set_current_user(user1)
    end

    it_behaves_like "require signed in user" do 
      let(:action) { delete :destroy, id: 4 }
    end

    it "deletes the relationship if the current user is the follower" do 
      relationship = Fabricate(:relationship, follower: user1, leader: user2)
      delete :destroy, id: relationship
      expect(Relationship.count).to eq(0)
    end

    it "redirects to the people page" do 
      relationship = Fabricate(:relationship, follower: user1, leader: user2)
      delete :destroy, id: relationship
      expect(response).to redirect_to people_path
    end

    it "does not delete the relationship if the current user is not the follower" do 
      user3 = Fabricate(:user)
      relationship = Fabricate(:relationship, follower: user3, leader: user2)
      delete :destroy, id: relationship
      expect(Relationship.count).to eq(1)
    end
  end

  describe "POST create" do 
    it_behaves_like "require signed in user" do 
      let(:action) { post :create, leader_id: 4 }
    end

    it "redirects to the people page" do 
      user1 = Fabricate(:user)
      user2 = Fabricate(:user)
      set_current_user(user1)
      post :create, leader_id: user2.id
      expect(response).to redirect_to people_path
    end

    it "creates a relationship that the current user follows the leader" do 
      user1 = Fabricate(:user)
      user2 = Fabricate(:user)
      set_current_user(user1)
      post :create, leader_id: user2.id
      expect(user1.following_relationships.first.leader).to eq(user2)
    end

    it "does not create a relationship if the current user already follows the leader" do 
      user1 = Fabricate(:user)
      user2 = Fabricate(:user)
      set_current_user(user1)
      Fabricate(:relationship, leader: user2, follower: user1)
      post :create, leader_id: user2.id
      expect(Relationship.count).to eq(1)
    end

    it "does not allow one to follow oneself" do 
      user1 = Fabricate(:user)
      set_current_user(user1)
      post :create, leader_id: user1.id
      expect(Relationship.count).to eq(0)
    end
  end
end 