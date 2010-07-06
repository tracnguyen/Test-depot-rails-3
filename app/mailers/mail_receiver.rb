class MailReceiver < ActionMailer::Base
  def receive(email)
    puts "Fetching email to the database..."
    debugger
    puts extract_message(email, nil)
    puts "Fetch completed."
  end
  
  #
  # Extract email content and return a struct with body and content type
  #
  def extract_message(email, delimiter)
    struct = Struct.new('Message', :body, :content_type)
    message = struct.new
    if email.parts.size > 0
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
end