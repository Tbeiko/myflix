require 'spec_helper'

describe Video do
  it "saves itself" do
    video = Video.new
    video.title = "Family Guy"
    video.description = "Adventures of Peter's Family"
    video.small_cover_url = "/tmp/family_guy.jpg"
    video.large_cover_url = "/tmp/monk_large.jpg"
    video.category_id = 1
    video.save
    Video.first.title.should == "Family Guy"
  end
end