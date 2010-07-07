class Message < ActiveRecord::Base
  belongs_to :account
  has_many :attachments, :as => :attachable
  
  def has_attachments?
    !attachments.blank? && attachments.size > 0
  end
end
