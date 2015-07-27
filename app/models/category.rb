class Category < ActiveRecord::Base
  has_many :videos, -> { order("created_at DESC") }
<<<<<<< HEAD
=======
  
  def recent_videos
    videos.first(6)
  end
>>>>>>> master
  
  def recent_videos
    videos.first(6)
  end

end