class Account < ActiveRecord::Base
  has_many :users
  has_many :jobs
  has_many :applicants
  
  has_one :owner, :class_name => "User"
  accepts_nested_attributes_for :owner
end
