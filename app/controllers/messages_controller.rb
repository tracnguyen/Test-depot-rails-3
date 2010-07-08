class MessagesController < BaseAccountController
  before_filter :authenticate_user!, :set_current_tab!
  
  def set_current_tab!
    @current_tab = ".tabs .left li:contains(Message Center)"
  end
  
  def index
    @messages = current_account.messages
  end
  
  def show
    @message = Message.find(params[:id])
    @applicant = Applicant.new
    @applicant.first_name = @message.sender_first_name
    @applicant.last_name = @message.sender_last_name
    @applicant.email = @message.sender_email
    @applicant.message_id = @message.id
  end 
  
  def create
    @applicant = Applicant.new(params[:applicant])
    @applicant.account_id = current_account.id
    @message = Message.find(@applicant.message_id)
    if @applicant.action == "1" # use as cover letter
      @applicant.cover_letter = @message.content    
      @applicant.resume = ""
    else # use as resume
      @applicant.resume = @message.content   
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
    logger.info "Success : #{success}"
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
end
