class UsersController < BaseAccountController
  def new
    @invitation = Invitation.find_by_token(params[:token])
    if @invitation.nil?
      head :forbidden
      return
    end
    @user = User.new(:email => @invitation.email)
  end
  
  def create
    @invitation = Invitation.find_by_token(params[:token])
    if @invitation.nil?
      head :forbidden
      return
    end
    @user = current_account.users.build(params[:user])
    if @user.save && @invitation.delete
      flash[:notice] = "Your registration is complete."
      redirect_to dashboard_path
    else
      flash[:alert] = "There was an error signing you up."
      render "new"
    end
  end
  
  def edit
  end
end
