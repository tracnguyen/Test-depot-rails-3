class BaseAccountController < ApplicationController
  before_filter :require_account

protected

  def require_account
    if !current_account
      flash[:alert] = "The subdomain #{current_subdomain} is not associated with any account."
      render "main/welcome/index"
    end
  end
end
