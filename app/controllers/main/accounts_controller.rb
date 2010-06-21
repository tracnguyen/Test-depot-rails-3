class Main::AccountsController < ApplicationController
  layout 'main'
  
  def index
    @accounts = Account.all
  end

  def new
    @account = Account.new
    @account.build_owner
  end

  def create
    @account = Account.new(params[:account])
    # @account.build_owner(params[:owner])

    if !simple_captcha_valid?
      flash[:notice] = "CAPTCHA confirmation failed!"
      render :action => 'new'
    else
      if @account.save && @account.owner.unlock_access!
        redirect_to pub_jobs_url(:subdomain => @account.subdomain), :notice => 'Account was successfully created.'
      else
        render :action => "new"
      end
    end
  end
  
  def edit
    @account = Account.find(params[:id])
  end

  def update
    @account = Account.find(params[:id])
    if @account.update_attributes(params[:account])
      redirect_to main_accounts_path, :notice => 'Account was successfully updated.'
    else
      render :action => "edit"
    end
  end

  def destroy
    @account = Account.find(params[:id])
    @account.destroy
    redirect_to(main_accounts_path)
  end
end
