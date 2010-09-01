class UserMailer < ActionMailer::Base
  default :from => "no-reply@hiring.com"
  
  def welcome_email(invitation)
    @invitation = invitation
    @url = new_user_url :token => @invitation.token,
    	:host => "hiring.com",
    	:subdomain => @invitation.inviter.account.subdomain
    mail :to => invitation.email,
    	:subject => "You are invited to join #{@invitation.inviter.account.name} on HiringApp"
  end
  
  def conversation_email(applicant, conversation)
    @message = conversation.message
    if conversation.attachment
      attachments["#{conversation.attachment.original_filename}"] = File.read(conversation.attachment.path)
    end
    mail :from => applicant.job.email_setting.username,
          :to => applicant.email,
          :subject => "#{applicant.job.account.name} has sent you a message"          
  end
end
