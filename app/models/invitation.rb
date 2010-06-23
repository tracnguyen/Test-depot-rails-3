class Invitation < ActiveRecord::Base
  after_create :reset_token!
  belongs_to :inviter, :class_name => "User"
   
  def reset_token!
    self.token = ActiveSupport::SecureRandom.hex(16)
    save!
  end 
end
