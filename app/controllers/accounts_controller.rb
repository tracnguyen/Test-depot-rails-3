class AccountsController < ApplicationController
  def index
    @accounts = Account.all
  end

  def show
    @account = Account.find(params[:id])
  end

  def new
    @account = Account.new
  end

  def create
    @account = Account.new(params[:account])
    @account.build_owner(params[:owner])
    if @account.save && @account.owner.unlock_access!
      redirect_to @account, :notice => 'Account was successfully created.'
    else
      render :action => "new"
    end
  end

  def update
    @account = Account.find(params[:id])
    if @account.update_attributes(params[:account])
      redirect_to(@account, :notice => 'Account was successfully updated.')
    else
      render :action => "edit"
    end
  end

  def destroy
    @account = Account.find(params[:id])
    @account.destroy
    redirect_to(accounts_url)
  end
end
