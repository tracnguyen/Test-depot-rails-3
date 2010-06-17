class BaseAccountController < ApplicationController
  before_filter :require_account
  helper_method :require_owner

protected

  def require_account
    if !current_account
      flash[:alert] = "The subdomain #{current_subdomain} is not associated with any account."
      render "main/welcome/index"
    end
  end
  
  def require_owner
    if current_user && (current_user != current_account.owner)
      flash[:alert] = "Account owner privilige is required to access the requested page."
      redirect_to dashboard_path
    end
  end
end
