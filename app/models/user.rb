class User < ActiveRecord::Base
  devise \
    :database_authenticatable,
    :registerable,
    :recoverable,
    :rememberable,
    :trackable,
    :validatable
  
  devise :lockable, :lock_strategy => :none, :unlock_strategy => :none
  after_create :lock_access!
  scope :unconfirmed, where('locked_at NOT NULL')
  
  attr_accessible :email, :password, :password_confirmation
  
  belongs_to :account
  
  def owns?(account)
    account.owner == self
  end
end
