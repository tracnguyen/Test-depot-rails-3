class BaseAccountController < ApplicationController
  before_filter :require_account, :set_n_unread
  helper_method :require_owner

protected

  def require_account
    if !current_account
      flash[:alert] = "The subdomain '#{current_subdomain}' is not associated with any account."
      render "main/welcome/index", :layout => 'error'
    end
  end
  
  def require_owner
    if current_user && (current_user != current_account.owner)
      flash[:alert] = "You do not have sufficient privilige."
      redirect_to dashboard_path
    end
  end
  
  def set_n_unread
    if current_user
      @n_unread_applications = current_account.applicants.count - current_user.viewed_applications.count
    else
      @n_unread_applications = 0
    end
  end
end
