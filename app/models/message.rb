class Message < ActiveRecord::Base
  belongs_to :account
  has_many :attachments, :as => :attachable
end
