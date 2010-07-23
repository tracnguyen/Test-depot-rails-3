module EmailParser
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
