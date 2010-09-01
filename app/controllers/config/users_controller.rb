class Config::UsersController < BaseAccountController
  before_filter :require_owner, :set_current_tab!
  layout 'config'
  
  def set_current_tab!
    @current_tab = ".tabs .right li:contains(Configuration)"
  end
  
  def index
    @users = current_account.users
    @user = User.new
  end
  
  def create
    @invitation = current_user.invitations.build(params[:user])

    if @invitation.save 
      if UserMailer.welcome_email(@invitation).deliver
        flash[:notice] = "The Invitation has been sent."
        redirect_to config_users_path
      else 
        flash[:notice] = "The Invitation sending failed."
        redirect_to config_users_path
      end
    else
      flash[:alert] = @invitation.errors.full_messages.first
      redirect_to config_users_path
    end 
  end
end
