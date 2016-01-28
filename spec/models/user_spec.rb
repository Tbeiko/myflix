require 'spec_helper'

describe User do 
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:password) }
  it { should validate_uniqueness_of(:email) }
  it { should have_many(:queue_items).order(:position) }
  it { should have_many(:reviews).order("created_at DESC") }

  describe "#queued_video?" do 
    it "returns true when the user has queued the video" do 
      user  = Fabricate(:user)
      video = Fabricate(:video)
      Fabricate(:queue_item, user: user, video: video)
      expect(user.queued_video?(video)).to be_truthy
    end
    
    it "returns false when the user hasn't queue the video" do 
      user  = Fabricate(:user)
      video = Fabricate(:video)
      expect(user.queued_video?(video)).to be_falsey
    end 
  end

  describe "#follow" do 
    let(:user1) { Fabricate(:user) }
    let(:user2) { Fabricate(:user) }

    it "follow another user" do 
      user1.follow(user2)
      expect(user1.follows?(user2)).to be_truthy
    end

    it "does not follow one self" do 
      user1.follow(user1)
      expect(user1.follows?(user1)).to be_falsey
    end
  end

  describe "#follows?" do 
    it "returns true if the user has a following relationship with another_user" do 
      user1 = Fabricate(:user)
      user2 = Fabricate(:user)
      Fabricate(:relationship, leader: user2, follower: user1)
      expect(user1.follows?(user2)).to be_truthy
    end
    
    it "returns false if the user does not have a following relationship with another_user" do 
      user1 = Fabricate(:user)
      user2 = Fabricate(:user)
      Fabricate(:relationship, leader: user1, follower: user2)
      expect(user1.follows?(user2)).to be_falsey
    end
  end
end