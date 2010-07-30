# == Schema Information
#
# Table name: invitations
#
#  id         :integer         not null, primary key
#  email      :string(255)
#  token      :string(255)
#  inviter_id :integer
#

class Invitation < ActiveRecord::Base
  after_create :reset_token!
  belongs_to :inviter, :class_name => "User"
  
  validates_presence_of :email
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
   
  def reset_token!
    self.token = ActiveSupport::SecureRandom.hex(16)
    save!
  end 
end

