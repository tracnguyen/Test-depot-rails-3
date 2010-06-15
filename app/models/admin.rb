class Admin < ActiveRecord::Base

  devise \
    :database_authenticatable,
    :recoverable,
    :rememberable,
    :trackable,
    :lockable,
    :validatable

  attr_accessible :email, :password, :password_confirmation
end
