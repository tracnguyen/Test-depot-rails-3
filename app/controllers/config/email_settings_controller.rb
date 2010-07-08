class Config::EmailSettingsController < BaseAccountController
  before_filter :require_owner, :set_current_tab!
  layout 'config'
  
  def set_current_tab!
    @current_tab = ".tabs .right li:contains(Configuration)"
  end
  
  def index
    if current_account.email_setting.blank?
      @setting = current_account.build_email_setting
    else
      @setting = current_account.email_setting
    end
  end
  
  def create
    @setting = EmailSetting.new(params[:email_setting])
    @setting.account = current_account
    
    if @setting.save
      redirect_to(config_email_settings_url, :notice => 'Settings was successfully updated.')
    else
      redirect_to(config_email_settings_url)
    end
  end
  
  def update
    @setting = EmailSetting.find(params[:id])
    if @setting.update_attributes(params[:email_setting])
      redirect_to(config_email_settings_url, :notice => 'Settings was successfully updated.')
    else
      redirect_to(config_email_settings_url)      
    end
  end
end
