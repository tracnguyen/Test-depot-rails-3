class Main::AccountsController < ApplicationController
  before_filter
  layout 'main'
  
  def index
    @current_tab = ".tabs .left li:contains(Accounts management)"
    @accounts = Account.all
  end
  
  def show
    @account = Account.find(params[:id])
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @applicant }
    end
  end

  def new
    @current_tab = ".tabs .left li:contains(Create an account)"
    @account = Account.new
    @account.build_owner
  end

  def create
    @account = Account.new(params[:account])
    
    if !simple_captcha_valid?
      flash[:notice] = "CAPTCHA confirmation failed!"
      render :action => 'new'
    else
      success = false
      begin
        Account.transaction do
          @account.save
          owner = @account.owner
          owner.account_id = @account.id
          owner.save
          success = true
        end
      rescue
        success = false
      end
      if success
        redirect_to main_account_path(@account), :notice => 'Account was successfully created.'
      else
        render :action => "new"
      end
    end
  end
  
  def edit
    @current_tab = ".tabs .left li:contains(Accounts management)"
    @account = Account.find(params[:id])
  end

  def update
    @current_tab = ".tabs .left li:contains(Accounts management)"
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
