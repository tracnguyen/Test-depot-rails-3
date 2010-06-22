class Invitation < ActiveRecord::Base
  after_create :reset_token!
   
  def reset_token!
    self.token = ActiveSupport::SecureRandom.hex(16)
    save!
  end 
end
