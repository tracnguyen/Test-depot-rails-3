class DashboardController < BaseAccountController
  before_filter :authenticate_user!, :set_current_tab!
  
  def set_current_tab!
    @current_tab = ".tabs .left li:contains(Dashboard)"
  end

  def index
    @n_jobs_open = current_account.jobs.open.count
    @n_applications = current_account.applicants.count
    @n_applications_unread = @n_applications - current_user.viewed_applications.count
  end
end
