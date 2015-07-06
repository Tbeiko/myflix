require 'spec_helper'

describe Video do
  it { should belong_to(:category) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }

  it do 
    "should return an empty array when no results"
    videos = Video.search_by_title("2453ffaweaf")
    videos.should == []
  end

  it do 
    "should return one video if the title is unique"
    video = Video.search_by_title("Families")
    video.count.should == 1
  end

end