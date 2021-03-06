class Invitation < ActiveRecord::Base
  belongs_to :inviter, class_name: "User"
  validates_presence_of :recipient_name, :recipient_email
  
  before_save :generate_token

  def generate_token
    self.token = SecureRandom.urlsafe_base64
  end

  def remove_token
    self.update_column(:token, nil)
  end
end