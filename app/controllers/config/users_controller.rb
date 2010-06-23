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
    if @invitation.save && InvitationMailer.welcome_email(@invitation).deliver
     flash[:notice] = "The Invitation has been sent."
     redirect_to config_users_path
   else
     flash[:alert] = "There as an error creating the invitation."
     render "index"
   end
  end
end