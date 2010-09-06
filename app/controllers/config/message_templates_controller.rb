class Config::MessageTemplatesController < BaseAccountController
  before_filter :require_owner, :set_current_tab!
  layout 'config'
  
  def set_current_tab!
    @current_tab = ".tabs .right li:contains(Configuration)"
  end
  
  def index
    @templates = current_account.message_templates.all
    @template = current_account.message_templates.build
  end
  
  def create
    @template = current_account.message_templates.build(params[:message_template])
    if @template.save
      flash[:notice] = "Message template successfully created."
      redirect_to config_message_templates_path
    else
      flash.now[:alert] = "Message template could not be saved."
      render :index, :status => :unprocessable_entity
    end
  end
  
  def edit
    @templates = current_account.message_templates.all
    @template = MessageTemplate.find(params[:id])
  end
  
  def update
    @template = MessageTemplate.find(params[:id])
    if @template.update_attributes(params[:message_template])
      flash[:notice] = "Message template successfully updated."
      redirect_to config_message_templates_path
    else
      flash.now[:alert] = "Message template could not be saved."
      render :edit, :status => :unprocessable_entity
    end
  end
  
  def destroy
    @template = MessageTemplate.find(params[:id])
    if @template.destroy
      flash[:notice] = "Message template successfully deleted."
    else
      flash[:alert] = "Could not delete message template. Please report this error."
    end
    redirect_to config_message_templates_path
  end
end