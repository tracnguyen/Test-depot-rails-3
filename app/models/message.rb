class Message < ActiveRecord::Base
  belongs_to :account
  has_many :attachments, :as => :attachable, :dependent => :destroy
  belongs_to :converter, :class_name => 'User', :foreign_key => :converter_id
  has_many :message_readings
  has_many :readers, :through => :message_readings, :source => :user
  
  attr_accessor :is_read
  
  USE_AS_COVER_LETTER = "1"
  USE_AS_RESUME = "2"
  
  def unread?
    is_read.nil? || !is_read
  end
  
  def to_applicant(options = {})
    converter_id = options[:converter_id]
    account_id = options[:account_id]
    options.delete(:converter_id)
    options.delete(:account_id)
    
    applicant = Applicant.new(options)
    if options[:action] == USE_AS_COVER_LETTER # use as cover letter
      applicant.cover_letter = content    
      applicant.cover_letter_content_type = content_type
      applicant.resume = ""
    else
      applicant.resume = content   
      applicant.resume_content_type = content_type
      applicant.cover_letter = ""
    end

    applicant.account_id = account_id
    copy_attachments_to_applicant(applicant)

    begin
      Applicant.transaction do
        applicant.save!
        self.converted = true
        self.applicant_id = applicant.id
        self.converter_id = converter_id
        self.save!

        # copy message's attachments to applicant's attachments 
        attachments.each_with_index do |a, index|
          dest = "#{Rails.root}/public/assets/attachments/#{applicant.attachments[index].id}"
          FileUtils.mkdir_p(dest) # create if did not existed
          FileUtils.cp(a.attachment.path, dest)
        end        
      end
    rescue Exception => ex
      puts ex
      applicant = nil      
    end
    applicant
  end
  
  def copy_attachments_to_applicant(applicant)
    attachments.each do |a|
      new_atm = applicant.attachments.build
      new_atm.attachment_file_name = a.attachment_file_name
      new_atm.attachment_file_size = a.attachment_file_size
      new_atm.attachment_content_type = a.attachment_content_type
      new_atm.attachment_updated_at = a.attachment_updated_at
    end
  end
end
