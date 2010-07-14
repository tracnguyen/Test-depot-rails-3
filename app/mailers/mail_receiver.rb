class MailReceiver < ActionMailer::Base
  def receive(email)
    # make sure we don't receive a message more than once
    # due to server configuration may change
    existed_uid = Message.select(:uid).map{ |m| m.uid }
    if existed_uid.include?(email.message_id)
      puts "** This message has been received and cannot process again."
    end
    
    puts "Fetching email to the database..."
    begin
      msg = extract_message(email, nil)    
      account = Account.find_by_owner_email(email.to.to_s)
                  
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
  
  #
  # Extract email content and return a struct with body and content type
  #
  def extract_message(email, delimiter)
    email_content = EmailContent.new
    if email.multipart?
      if !email.html_part.nil?
        email_content.body = email.html_part.body.decoded
        email_content.content_type = "html"
      else
        email_content.body = email.text_part.body.decoded
        email_content.content_type = "text"
      end
    else
      email_content.body = email.body.decoded
      email_content.content_type = "text"
    end

    if delimiter
      regex = Regexp.new(delimiter)
      email_content.body = email_content.body.split(regex).first if email_content.body.include?(delimiter)
    end
    email_content
  end
  
  #
  # Extract sender name from the email
  #
  def sender_name(email)
    sender = Sender.new

    full_name = email.header[:from].to_s.split(/</).first.strip
    names = (full_name).split(/\s/)
    if names.length > 1
      sender.first_name = names[0]
      sender.last_name = names[1]
    elsif names.length == 1
      sender.first_name = names[0]
      sender.last_name = ""
    end
    sender
  end
  
  def extract_phone(email, msg)
    phone = ""
    if (msg.content_type == "html")
      if from_vietnamworks?(email)
        phone = EmailExtractor::VietnamWorks.extract_phone(msg.body)
      end
    end
    phone
  end
  
  def extract_position(email, msg)
    position = ""
    if (msg.content_type == "html")
      if from_vietnamworks?(email)
        position = EmailExtractor::VietnamWorks.extract_position(msg.body)
      end
    end
    position
  end
  
  def from_vietnamworks?(email)
    email.header['References'].to_s.include?(EmailExtractor::VietnamWorks::MAIL_SERVER)
  end
  
  EmailContent = Struct.new(:body, :content_type)
  Sender = Struct.new(:first_name, :last_name)
end
