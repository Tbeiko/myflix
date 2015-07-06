class Video < ActiveRecord::Base
  belongs_to :category

  validates_presence_of :title, :description

  def self.search_by_title(search_term)
  if search_term
    key = "%#{search_term}%"
    where('title LIKE :search', search: key)
  end
  end
end