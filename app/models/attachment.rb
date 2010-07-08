class Attachment < ActiveRecord::Base
  belongs_to :attachable, :polymorphic => true
  has_one :activity, :as => :subject
  
	has_attached_file :attachment,
  	:path => ":rails_root/public/assets/attachments/:id/:basename.:extension",
  	:url => "/assets/attachments/:id/:basename.:extension"
  
  before_create :randomize_file_name
  

  private
  
  def randomize_file_name
    if (attachment_file_name =~ /,\d+,\d(\.\w{1,3})$/)
      extension = File.extname(attachment_file_name).downcase
      filename = attachment_file_name.gsub(/,\d+,\d(\.\w{1,3})$/, "") + "#{extension}"
      self.attachment.instance_write(:file_name, filename)
    end
  end
  
end
