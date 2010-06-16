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
  
  attr_accessible :email, :password, :password_confirmation
  
  belongs_to :account
  
  def account_owner?
    self.account == Account.where({:user_id => self.id})
  end
end
