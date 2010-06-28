class DashboardController < BaseAccountController
  before_filter :authenticate_user!, :set_current_tab!
  
  def set_current_tab!
    @current_tab = ".tabs .left li:contains(Dashboard)"
  end

  def index
    @activities = current_account.activities.order("created_at DESC").limit(25).includes(:actor, :applicant, :next_stage)
  end
end
