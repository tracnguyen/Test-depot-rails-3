class DashboardController < BaseAccountController
  before_filter :authenticate_user!
  
  def index
  end
end