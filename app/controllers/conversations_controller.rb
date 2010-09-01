class ConversationsController < BaseAccountController
  before_filter :authenticate_user!
  
  def create
    file = params[:attachment]
    conversation = Conversation.new(params[:conversation])
    conversation.content_type = "text"
    conversation.outgoing = true
    if conversation.save
      applicant = Applicant.find(conversation.applicant_id)
      UserMailer.conversation_email(applicant, conversation).deliver
      render :partial => 'conversation', :locals => { :conversation => conversation,
                                                      :applicant => applicant }
    else
      render :text => 'Error occur while sending the message.', :status => :unprocessable_entity
    end
  end
end
