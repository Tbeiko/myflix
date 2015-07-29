require 'spec_helper'

describe QueueItemsController do 
  describe "GET index" do 
    it "sets @queue_items to the queue items of the logged in user" do 
      user = Fabricate(:user)
      session[:user_id] = user.id
      queue_item1 = Fabricate(:queue_item, user: user)
      queue_item2 = Fabricate(:queue_item, user: user)
      get :index
      expect(assigns(:queue_items)).to match_array([queue_item1, queue_item2])
    end

    it "redirects to the sign in page for unauthenticated users" do 
      get :index
      expect(response).to redirect_to sign_in_path
    end
  end

  describe "POST create" do 
    it "redirects to the my_queue page" do 
      session[:user_id] = Fabricate(:user).id
      video = Fabricate(:video)
      post :create, video_id: video.id
      expect(response).to redirect_to my_queue_path
    end

    it "creates a queue_item" do 
      session[:user_id] = Fabricate(:user).id
      video = Fabricate(:video)
      post :create, video_id: video.id
      expect(QueueItem.count).to eq(1)
    end

    it "creates a queue_item that is associated with the video" do 
      session[:user_id] = Fabricate(:user).id
      video = Fabricate(:video)
      post :create, video_id: video.id
      expect(QueueItem.first.video).to eq(video)
    end

    it "creates a queue_item that is associated with current_user" do 
      user = Fabricate(:user)
      session[:user_id] = user.id
      video = Fabricate(:video)
      post :create, video_id: video.id
      expect(QueueItem.first.user).to eq(user)
    end

    it "puts the video as the last one in the queue" do 
      user = Fabricate(:user)
      session[:user_id] = user.id
      video = Fabricate(:video)
      Fabricate(:queue_item, video: video, user: user)
      video2 = Fabricate(:video)
      post :create, video_id: video2.id
      video2_queue_item = QueueItem.where(video_id: video2.id, user_id: user.id).first
      expect(video2_queue_item.position).to eq(2)
    end

    it "does not add a video to the queue if the video is already in the queue" do 
      user = Fabricate(:user)
      session[:user_id] = user.id
      video = Fabricate(:video)
      Fabricate(:queue_item, video: video, user: user)
      post :create, video_id: video.id
      expect(user.queue_items.count).to eq(1)
    end
    it "redirects to the sign in page for unauthenticated users" do 
      post :create, video_id: 3
      expect(response).to redirect_to sign_in_path
    end
  end

  describe "DELETE destroy" do 
    it "redirects to the my queue page" do 
      user = Fabricate(:user)
      session[:user_id] = user.id
      queue_item = Fabricate(:queue_item)
      delete :destroy, id: queue_item.id
      expect(response).to redirect_to(my_queue_path)
    end
    it "deletes the queue item" do 
      user = Fabricate(:user)
      session[:user_id] = user.id
      queue_item = Fabricate(:queue_item, user: user)
      delete :destroy, id: queue_item.id
      expect(user.queue_items.count).to eq(0)
    end
    it "can only delete queue items for the current_user's queue" do 
      user = Fabricate(:user)
      bob  = Fabricate(:user)
      session[:user_id] = user.id
      queue_item = Fabricate(:queue_item, user: bob)
      delete :destroy, id: queue_item.id
      expect(bob.queue_items.count).to eq(1)
    end
    it "redirect_to the sign in page if for unauthenticated users" do 
      queue_item = Fabricate(:queue_item)
      delete :destroy, id: queue_item.id
      expect(response).to redirect_to sign_in_path
    end
  end
end