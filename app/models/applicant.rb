class Applicant < ActiveRecord::Base
  belongs_to :job
  
  has_attached_file :attachment, 
                    :path => ":rails_root/public/assets/attachments/:basename.:extension", 
                    :url => "/assets/attachments/:basename.:extension"
                    
  state_machine :status, :initial => :new do
    event :change_status do
      transition :new => :screened
      transition :screened => :interviewed
      transition :interviewed => :offered
      transition :offered => :hired 
      transition :hired => :hired 
      transition :rejected => :rejected
    end
    
    event :rejecting do
      transition [:new, :screened, :interviewed, :offered] => :rejected
      transition :hired => :hired
      transition :rejected => :rejected
    end
  end                    
end
