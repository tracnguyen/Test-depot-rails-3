class ApplicationController < ActionController::Base
  include SimpleCaptcha::ControllerHelpers
  protect_from_forgery
  helper_method :current_account
  
protected

  def current_account
    @current_account ||= Account.find_by_subdomain(current_subdomain)
  end
end
