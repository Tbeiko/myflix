require 'spec_helper'

describe QueueItemsController do 
  describe "GET index" do 
    it "sets @queue_items to the queue items of the logged in user" do 
      user = Fabricate(:user)
      set_current_user(user)
      queue_item1 = Fabricate(:queue_item, user: user)
      queue_item2 = Fabricate(:queue_item, user: user)
      get :index
      expect(assigns(:queue_items)).to match_array([queue_item1, queue_item2])
    end

    it_behaves_like "require signed in user" do 
      let(:action) { get :index }
    end
  end

  describe "POST create" do 
    context "with authenticated users" do 
      let(:user) { Fabricate(:user) }
      let(:video) { Fabricate(:video) }
      before { set_current_user(user) }

      it "redirects to the my_queue page" do 
        post :create, video_id: video.id
        expect(response).to redirect_to my_queue_path
      end

      it "creates a queue_item" do 
        post :create, video_id: video.id
        expect(QueueItem.count).to eq(1)
      end

      it "creates a queue_item that is associated with the video" do 
        post :create, video_id: video.id
        expect(QueueItem.first.video).to eq(video)
      end

      it "creates a queue_item that is associated with current_user" do 
        post :create, video_id: video.id
        expect(QueueItem.first.user).to eq(user)
      end

      it "puts the video as the last one in the queue" do 
        Fabricate(:queue_item, video: video, user: user)
        video2 = Fabricate(:video)
        post :create, video_id: video2.id
        video2_queue_item = QueueItem.where(video_id: video2.id, user_id: user.id).first
        expect(video2_queue_item.position).to eq(2)
      end

      it "does not add a video to the queue if the video is already in the queue" do 
        Fabricate(:queue_item, video: video, user: user)
        post :create, video_id: video.id
        expect(user.queue_items.count).to eq(1)
      end
    end

      it_behaves_like "require signed in user" do 
        let(:action) { post :create }
      end
  end

  describe "DELETE destroy" do 
    context "with authenticated users" do 
      let(:user) { Fabricate(:user) }
      before { set_current_user(user) }

      it "redirects to the my queue page" do 
        queue_item = Fabricate(:queue_item)
        delete :destroy, id: queue_item.id
        expect(response).to redirect_to(my_queue_path)
      end

      it "deletes the queue item" do 
        queue_item = Fabricate(:queue_item, user: user)
        delete :destroy, id: queue_item.id
        expect(user.queue_items.count).to eq(0)
      end

      it "normalizes the remaining queue items" do 
        queue_item1 = Fabricate(:queue_item, user: user, position: 1)
        queue_item2 = Fabricate(:queue_item, user: user, position: 2)
        delete :destroy, id: queue_item1.id
        expect(queue_item2.reload.position).to eq(1)
      end

      it "can only delete queue items for the current_user's queue" do 
        bob  = Fabricate(:user)
        queue_item = Fabricate(:queue_item, user: bob)
        delete :destroy, id: queue_item.id
        expect(bob.queue_items.count).to eq(1)
      end
    end

    it_behaves_like "require signed in user" do 
      let(:action) { delete :destroy, id: 3 }
    end
  end

  describe "POST update_queue" do 

    context "with valid input" do 
      let(:user) { Fabricate(:user) }
      let(:video) { Fabricate(:video) }
      let(:queue_item1) { Fabricate(:queue_item, user: user, video: video, position: 1) }
      let(:queue_item2) { Fabricate(:queue_item, user: user, video: video, position: 2) }
      before { set_current_user(user) }

      it "redirects to the my queue page" do 
        post :update_queue, queue_items: [{id: queue_item1.id, position: 2}, {id: queue_item2.id, position: 1} ]
        expect(response).to redirect_to my_queue_path
      end

      it "re-orders the queue item" do 
        post :update_queue, queue_items: [{id: queue_item1.id, position: 2}, {id: queue_item2.id, position: 1} ]
        expect(user.queue_items).to eq([queue_item2, queue_item1])
      end
      it "normalizes the position numbers" do 
        post :update_queue, queue_items: [{id: queue_item1.id, position: 3}, {id: queue_item2.id, position: 1} ]
        expect(user.queue_items.map(&:position)).to eq([1,2])
      end
    end

    context "with invalid input" do 
      let(:user) { Fabricate(:user) }
      let(:video) { Fabricate(:video) }
      let(:queue_item1) { Fabricate(:queue_item, user: user, video: video, position: 1) }
      let(:queue_item2) { Fabricate(:queue_item, user: user, video: video, position: 2) }
      before { set_current_user(user) }

      it "redirects to the my_queue page" do 
        post :update_queue, queue_items: [{id: queue_item1.id, position: 2.4}, {id: queue_item2.id, position: 1} ]
        expect(response).to redirect_to my_queue_path
      end

      it "sets the flash error message" do 
        post :update_queue, queue_items: [{id: queue_item1.id, position: 2.4}, {id: queue_item2.id, position: 1} ]
        expect(flash[:danger]).to be_present
      end

      it "does not change the queue items" do 
        post :update_queue, queue_items: [{id: queue_item1.id, position: 2}, {id: queue_item2.id, position: 1.2} ]
        expect(queue_item1.reload.position).to eq(1)
      end
    end

    context "with queue items that do not belong to the current user" do 
      it "does not change the queue items" do 
        user = Fabricate(:user)
        bob = Fabricate(:user)
        video = Fabricate(:video)
        set_current_user(user)
        queue_item1 = Fabricate(:queue_item, user: bob, video: video, position: 1)
        queue_item2 = Fabricate(:queue_item, user: user, video: video, position: 2)
        post :update_queue, queue_items: [{id: queue_item1.id, position: 3}, {id: queue_item2.id, position: 1} ]
        expect(queue_item1.reload.position).to eq(1)
      end
    end

    it_behaves_like "require signed in user" do 
      let(:action) do 
        post :update_queue, queue_items: [{id: 1, position: 2}, {id: 2, position: 1}] 
      end
    end
  end
end