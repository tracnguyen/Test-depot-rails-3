class ConversationReceiver < ActionMailer::Base
  include EmailParser
  
  def receive(email)
    # make sure we don't receive a message more than once
    # due to server configuration may change
    if RAILS_ENV.to_s != "development"
      existed_uid = Message.select(:uid).map{ |m| m.uid }
      if existed_uid.include?(email.message_id)
        puts "** This message has been received and cannot process again."
      end
    end
    
    puts "Fetching conversation to the database..."
    begin
      msg = extract_message(email, nil)
      
      setting = EmailSetting.find_by_username(email.to.to_s)      
      if setting.nil?
        puts "** WARNING: The email #{email.to.to_s} was not configured. Abort!"
        return
      end
      
      job = Job.find(setting.configurable_id)
      if job.nil?
        puts "** WARNING: Could not found any jobs match the given setting. Abort!"
        return
      end
      
      applicant = Applicant.where(:email => email.from.to_s, :job_id => job.id)
      if applicant.nil?
        puts "** WARNING: Could not found any applicant match with the job '#{job.title}'. Abort!"
        return
      end
      applicant = applicant.first
      
      conversation = Conversation.new(:content_type => msg.content_type,
                                      :message => msg.body,
                                      :outcome => false,
                                      :applicant_id => applicant.id)
      
      # if this conversation contains any attachments, these attachments
      # will be moved to the applicant's attachments
      if email.has_attachments?
        email.attachments.each do |attachment|
          new_attachment = applicant.attachments.build
          tempfile = Paperclip::Tempfile.new(attachment.original_filename)
          tempfile.write attachment.read
          new_attachment.attachment = tempfile
        end        
      end
      
      Conversation.transaction do
        conversation.save!
        applicant.save!
      end
      
    rescue Exception => ex
      puts "Error occurred while process the conversation from #{email.from.to_s}, subject: '#{email.subject}'"
      puts ex
      puts ex.backtrace
    end
    puts "Conversation has been saved. Fetch completed."
  end
end
