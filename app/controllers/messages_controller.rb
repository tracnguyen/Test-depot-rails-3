class MessagesController < BaseAccountController
  before_filter :authenticate_user!, :set_current_tab!
  
  def set_current_tab!
    @current_tab = ".tabs .left li:contains(Emails)"
  end
  
  def index
    @messages = current_account.messages
  end
  
  def show
    @message = Message.find(params[:id])
    @applicant = Applicant.new
  end
end
