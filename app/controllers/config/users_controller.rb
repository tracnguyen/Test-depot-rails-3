class Config::UsersController < BaseAccountController
  before_filter :require_owner
  layout 'config'
  
  def index
    @users = current_account.users
    @user = User.new
  end
  
  def create
    @user = current_account.user.build(params[:user])
    respond_to { |format|
      format.html {
        if @user.save && @user.ensure_authentication_token!
         flash[:notice] = "Invitation has been sent."
         redirect_to config_users_path
       else
         flash[:alert] = "There as an error creating the invitation."
         render "index"
       end
     }
   }
  end
end