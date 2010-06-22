class Config::AdminsController < BaseAccountController
  before_filter :require_owner
  layout 'config'
  
  def show
  end
end