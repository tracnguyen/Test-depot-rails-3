class MessagesController < BaseAccountController
  before_filter :authenticate_user!, :set_current_tab!
  
  def set_current_tab!
    @current_tab = ".tabs .left li:contains(Message Center)"
  end
  
  def index
    page = params[:page] || 1
    per_page = params[:per_page] || 10
    @messages = current_user.all_messages(page, per_page)
  end
  
  def show
    @message = Message.includes(:attachments).find(params[:id])
    @applicant = Applicant.new
    auto_fill_applicant_info(@message, @applicant)
    MessageReading.mark_as_read(current_user, @message)    
  end 
  
  def create
    @message = Message.find(params[:applicant][:message_id])
    options = params[:applicant]
    options[:account_id] = current_account.id
    options[:converter_id] = current_user.id
    applicant = @message.to_applicant(options)
    
    respond_to do |format|
      if !applicant.nil?
        format.html { redirect_to(@message, :notice => 'Applicant was successfully created.') }
        format.xml  { render :xml => @message, :status => :created, :location => @message }
      else
        format.html { render :action => "show" }
        format.xml  { render :xml => @message.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def content
    @message = Message.find(params[:id])
    render :partial => "shared/viewer", :locals => {:content_type => @message.content_type,
                                                    :content => @message.content}
  end
  
  def batch_process
    url = messages_url
    case
      when params[:commit] == "Read" || params[:commit] == "Unread"
        is_read = params[:commit] == "Read"
        ids = params[:selection]
        MessageReading.update_all({:is_read => is_read}, ['user_id = ? AND message_id IN (?)', current_user.id, ids])
        
        url << "?" if !params[:page].blank? || !params[:per_page].blank?
        url << "page=#{params[:page]}" if !params[:page].blank?
        url << "per_page=#{params[:per_page]}" if !params[:per_page].blank?
      when params[:commit] == "Delete"
        Message.delete(params[:selection].map{ |s| s.to_i })
    end    
    redirect_to url
  end
  
  private
  def auto_fill_applicant_info(message, applicant)
    applicant.first_name = message.sender_first_name
    applicant.last_name = message.sender_last_name
    applicant.email = message.sender_email
    applicant.phone = message.sender_phone
    applicant.message_id = message.id
  end
end
