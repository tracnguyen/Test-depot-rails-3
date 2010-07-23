class MailReceiver < ActionMailer::Base
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
    
    puts "Fetching email to the database..."
    begin
      msg = extract_message(email, nil)
      setting = EmailSetting.find_by_username(email.to.to_s)      
      if setting.nil?
        puts "** WARNING: The email #{email.to.to_s} was not configured. Abort!"
        return
      end
      account = Account.find(setting.configurable_id)
      if account.nil?
        puts "** WARNING: Could not found any accounts match the given setting. Abort!"
        return
      end
      
      sender = sender_name(email)        
      message = Message.new(:sender_email => email.from.to_s,
                            :sender_first_name => sender.first_name,
                            :sender_last_name => sender.last_name,
                            :sender_phone => extract_phone(email, msg),
                            :uid => email.message_id,
                            :subject => email.subject,
                            :content => msg.body,
                            :content_type => msg.content_type,
                            :account_id => account.id,
                            :has_attachments => email.has_attachments?)
      
      if email.has_attachments?
        email.attachments.each do |attachment|
          new_attachment = message.attachments.build
          tempfile = Paperclip::Tempfile.new(attachment.original_filename)
          tempfile.write attachment.read
          new_attachment.attachment = tempfile
        end        
      end
      message.readers = account.users
      message.save!
      
      # auto create applicant if this message come from Vietnamworks
      # TODO: this fragment should be refactoring to more generalize instead of 
      #       Vietnamworks specific
      if from_vietnamworks?(email)
        puts "Converting message to applicant..."
        failed_msg = "** WARNING: This message has failed to auto convert to applicant due to: "
        position = extract_position(email, msg)
        if !position.empty?
          puts "Found position: #{position}"
          job = Job.find_by_title(position)
          if !job.nil?
            options = {
              :action => Message::USE_AS_RESUME,
              :account_id => account.id,
              :job_id => job.id,
              :first_name => message.sender_first_name,
              :last_name => message.sender_last_name,
              :email => message.sender_email,
              :phone => message.sender_phone
            }
            applicant = message.to_applicant(options)
            if applicant.nil?
              puts failed_msg << "Error occur while converting message to applicant."
            else
              puts "** This message has been auto converted to applicant."
            end
          else
            puts failed_msg << "Cannot find the position #{position} in the database." 
          end
        else
          puts failed_msg << "Cannot extract the apply position from this message."
        end
      end

    rescue Exception => ex
      puts "Error occurred while process the email from #{email.from.to_s}, subject: '#{email.subject}'"
      puts ex
      puts ex.backtrace
    end
    puts "Message has been saved. Fetch completed."
  end
end
