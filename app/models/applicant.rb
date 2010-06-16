class Applicant < ActiveRecord::Base
  belongs_to :job
  
  has_attached_file :attachment, 
                    :path => ":rails_root/public/assets/attachments/:basename.:extension", 
                    :url => "/assets/attachments/:basename.:extension"
end
