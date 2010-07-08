class EmailSetting < ActiveRecord::Base
  belongs_to :account
  validates_presence_of :server, :port, :protocol, :username, :password
end
