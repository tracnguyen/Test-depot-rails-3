class InvitationMailer < ActionMailer::Base
  default :from => "no-reply@hiring.com"
  
  def welcome_email(invitation)
    @invitation = invitation
    @url = new_user_url :token => @invitation.token,
    	:host => "hiring.com",
    	:subdomain => @invitation.inviter.account.subdomain
    mail :to => invitation.email,
    	:subject => "You are invited to join #{@invitation.inviter.account.name} on HiringApp"
  end
end
