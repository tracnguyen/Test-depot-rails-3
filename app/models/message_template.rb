class MessageTemplate < ActiveRecord::Base
  belongs_to :account
  validates_presence_of :subject, :body
end
