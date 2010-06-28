class Attachment < ActiveRecord::Base
  belongs_to :attachable, :polymorphic => true
  has_one :activity, :as => :subject
  
  has_attached_file :attachment,
  	:path => ":rails_root/public/assets/attachments/:basename.:extension",
  	:url => "/assets/attachments/:basename.:extension"
end
