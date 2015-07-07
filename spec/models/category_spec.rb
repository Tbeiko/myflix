require 'spec_helper'

describe Category do 
  it { should have_many(:videos) }

  describe "#recent_videos" do

    it "returns videos in reverse chronological order by created_at" do
      category = Category.create(name: "Comedy")
      futur = Video.create(title: "Futurama", description: "Space travel", category: category, created_at: 1.day.ago)
      south = Video.create(title: "South Park", description: "Fun and games", category: category)
      expect(category.recent_videos).to eq([south, futur])
    end

    it "returns all videos in reverse chronological order if less six videos" do 
      category = Category.create(name: "Comedy")
      futur = Video.create(title: "Futurama", description: "Space travel", category: category, created_at: 1.day.ago)
      south = Video.create(title: "South Park", description: "Fun and games", category: category)
      expect(category.recent_videos.count).to eq(2)
    end
    it "returns six videos if there are more than six total videos" do
      category = Category.create(name: "Comedy")
      7.times {Video.create(title: "love", description: "hurts", category: category)}
      expect(category.recent_videos.count).to eq(6)
    end

    it "returns six videos in reverse chronological order by created_at if a catagory has more than 6 videos" do
      category = Category.create(name: "Comedy")
      6.times {Video.create(title: "love", description: "hurts", category: category)}
      tonight_show = Video.create(title: "tonight!!", description: "shoow", category: category, created_at: 1.day.ago)
      expect(category.recent_videos).not_to include(tonight_show)
    end

    it "returns an empty array if the category does not have any videos" do 
      category = Category.create(name: "Horror")
      expect(category.recent_videos).to eq([])
    end
  end
  

end