class UsersController < ApplicationController
  before_filter :authenticate_user!
  
  def index
    @users = User.unconfirmed
  end
  
  def confirm
    @user = User.find(params[:id])
    if @user.unlock_access!
      flash[:notice] = "Administrative rights has been granted to #{@user.email}."
      redirect_to users_path
    else
      render "index"
    end
  end
end