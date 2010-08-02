class Subdomain::SessionsController < Devise::SessionsController
  def create    
    resource = warden.authenticate!(:scope => resource_name, :recall => "new")
    set_flash_message :notice, :signed_in
    if current_user == current_account.owner && current_account.email_setting.nil?
      flash[:warning] = "You have to configure the email setting to receive messages. "    
      flash[:warning] << "<a href='#{config_email_settings_path}'>Click here</a> to configure email messaging."
    end
    sign_in_and_redirect(resource_name, resource)
  end
end
