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
    @applicant.first_name = @message.sender_first_name
    @applicant.last_name = @message.sender_last_name
    @applicant.email = @message.sender_email
    @applicant.message_id = @message.id
    MessageReading.mark_as_read(current_user, @message)    
  end 
  
  def create
    @applicant = Applicant.new(params[:applicant])
    @applicant.account_id = current_account.id
    @message = Message.find(@applicant.message_id)
    if @applicant.action == "1" # use as cover letter
      @applicant.cover_letter = @message.content    
      @applicant.cover_letter_content_type = @message.content_type
      @applicant.resume = ""
    else # use as resume
      @applicant.resume = @message.content   
      @applicant.resume_content_type = @message.content_type
      @applicant.cover_letter = ""
    end
    
    @message.attachments.each do |a|
      new_atm = @applicant.attachments.build
      new_atm.attachment_file_name = a.attachment_file_name
      new_atm.attachment_file_size = a.attachment_file_size
      new_atm.attachment_content_type = a.attachment_content_type
      new_atm.attachment_updated_at = a.attachment_updated_at
    end

    success = false
    begin
      Applicant.transaction do
        @applicant.save!
        @message.converted = true
        @message.applicant_id = @applicant.id
        @message.converter_id = current_user.id
        @message.save!

        # copy message's attachments to applicant's attachments 
        @message.attachments.each_with_index do |a, index|
          dest = "#{Rails.root}/public/assets/attachments/#{@applicant.attachments[index].id}"
          FileUtils.mkdir_p(dest) # create if did not existed
          FileUtils.cp(a.attachment.path, dest)
        end        
        
        success = true
      end
    rescue Exception => ex
      logger.error ex
      success = false
    end
    respond_to do |format|
      if success
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
    is_read = params[:commit] == "Read"
    ids = params[:selection]
    MessageReading.update_all({:is_read => is_read}, ['user_id = ? AND message_id IN (?)', current_user.id, ids])

    url = messages_url
    url << "?" if !params[:page].blank? || !params[:per_page].blank?
    url << "page=#{params[:page]}" if !params[:page].blank?
    url << "per_page=#{params[:per_page]}" if !params[:per_page].blank?
    
    redirect_to url
  end
end
