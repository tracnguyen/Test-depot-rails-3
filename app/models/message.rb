class Message < ActiveRecord::Base
  belongs_to :account
  has_many :attachments, :as => :attachable
  
  def has_attachments?
    !attachments.blank? && attachments.size > 0
  end
  
  def clone_attachments(target)
    tmp = attachments.clone    
    tmp.each do |a|
      a.id = nil
      a.attachable_id = target.id      
      a.attachable_type = target.class.to_s 
    end
    tmp
  end
end
