class Account < ActiveRecord::Base
  has_one :owner, :class_name => :User
  has_many :users
end
