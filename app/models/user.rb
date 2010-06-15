class User < ActiveRecord::Base

  devise \
    :database_authenticatable,
    :registerable,
    :recoverable,
    :rememberable,
    :trackable,
    :lockable,
    :validatable

  attr_accessible :email, :password, :password_confirmation
  
  belongs_to :account
end
