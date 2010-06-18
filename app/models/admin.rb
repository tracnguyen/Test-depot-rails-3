class Admin < ActiveRecord::Base
  devise \
    :database_authenticatable,
    :recoverable,
    :rememberable,
    :trackable,
    :validatable
  
  devise :lockable, \
    :lock_strategy => :failed_attempts,
    :maximum_attempts => 5,
    :unlock_strategy => :email

  attr_accessible :email, :password, :password_confirmation
  
  apply_simple_captcha
  
end
