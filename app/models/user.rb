class User < ActiveRecord::Base
  validates_presence_of :email, :password, :name
  validates_uniqueness_of :email
  has_many :reviews, -> { order("created_at DESC") }
  
  has_secure_password validations: false

  has_many :queue_items, -> { order(:position) }

  def normalize_queue_item_positions
    queue_items.each_with_index do |queue_item, index|
      queue_item.update(position: index+1)
    end
  end

  def queued_video?(video)
    self.queue_items.map(&:video).include?(video)
  end
end