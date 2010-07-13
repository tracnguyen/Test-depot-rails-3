class MailReceiver < ActionMailer::Base
  def receive(email)
    puts "Fetching email to the database..."
    begin
      msg = extract_message(email, nil)    
      account = Account.find_by_owner_email(email.to.to_s)
      # TODO: raise add exception here and catch it in the fetcher
      
      sender = sender_name(email)        
      message = Message.new(:sender_email => email.from.to_s,
                            :sender_first_name => sender.first_name,
                            :sender_last_name => sender.last_name,
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
#      puts "#{account.users.size} Users"
#      account.users.each do |user|
#        message.message_readings.build({:reader_id => user.id})
#      end
      message.save!

    rescue Exception => ex
      logger.error "Error occurred while process the email from #{email.from.to_s}, subject: '#{email.subject}'"
      logger.error ex
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
  
  EmailContent = Struct.new(:body, :content_type)
  Sender = Struct.new(:first_name, :last_name)
end
