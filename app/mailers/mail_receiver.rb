class MailReceiver < ActionMailer::Base
  def receive(email)
    debugger
    puts "Fetching email to the database..."
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
                          :account_id => account.id)
    
    if email.has_attachments?
      email.attachments.each do |attachment|
        new_attachment = message.attachments.build
        tempfile = Paperclip::Tempfile.new(attachment.original_filename)
        tempfile.write attachment.read
        new_attachment.attachment = tempfile
      end
    end
    if message.save
      puts "Message has been saved."
  else
      puts "Failed to save message."
    end
    
    puts "Fetch completed."
  end
  
  #
  # Extract email content and return a struct with body and content type
  #
  def extract_message(email, delimiter)
    struct = Struct.new('Message', :body, :content_type)
    message = struct.new
    if email.parts.size > 0
      if email.multipart?
        message.body = email.html_part.body.decoded
        message.content_type = "html"
      else
        email.parts.each do |part|
          if part.content_type.include?("multipart/alternative")
            if !part.html_part.body.nil?
              message.body = part.html_part.body.raw_source
              message.content_type = "html"
            else
              message.body = part.text_part.body.raw_source
              message.content_type = "text"
            end
          else
            if part.content_type.include?("text/html")
              message.body = part.body.raw_source
              message.content_type = "html"
            elsif part.content_type.include?("text/plain")
              message.body = part.body.raw_source
              message.content_type = "text"
            end
          end
        end
      end
    else
      message.body = email.body.raw_source
      message.content_type = "text"
    end

    if delimiter
      regex = Regexp.new(delimiter)
      message.body = message.body.split(regex).first if message.body.include?(delimiter)
    end
    message
  end
  
  #
  # Handle apply email
  # FIXME: add more error handles
  #
  def handle_apply(email)    
    sender = sender_name(email)
    job_email = email.to.to_s
    job = Job.find_by_job_email(job_email)
    if job
      account = job.account
      applicant = Applicant.new(:first_name => sender.first_name,
                          :last_name => sender.last_name,
                          :email => email.from.to_s,
                          :job_id => job.id,
                          :account_id => account.id,
                          :job_stage_id => account.job_stages.first.id)

      # if the email has attachments, these attachments will be saved to
      # applicant's attachment list and the email content use as cover letter;
      # otherwise, the email content will be used as cv content
      message = extract_message(email, nil)
      if email.has_attachments?
        email.attachments.each do |attachment|
          new_attachment = applicant.attachments.build
          new_attachment.attachment_file_name = attachment.original_filename
          new_attachment.attachment_content_type = attachment.content_type
          new_attachment.attachment_file_size = 1024 # FIXME: dynamic size
          new_attachment.attachment_updated_at = Time.now.to_datetime
          new_attachment.attachment = attachment.body
        end
        applicant.cover_letter = message.body
        applicant.cover_letter_content_type = message.content_type
      else
        applicant.cv = message.body
        applicant.cv_content_type = message.content_type
      end
      applicant.save!
    else
      puts "Job email #{job_email} not found!"
    end
  end
  
  
  #
  # Extract sender name from the email
  #
  def sender_name(email)
    struct = Struct.new('Sender', :first_name, :last_name)
    sender = struct.new

    full_name = email.header[:from].to_s.split(/</).first.strip
    names = (full_name).split(/\s/)
    if names.length > 1
      sender.first_name = names[0]
      sender.last_name = names[1]
    elsif names.length = 1
      sender.first_name = names[0]
      sender.last_name = ""
    end
    sender
  end
end
