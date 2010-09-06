class Main::AccountsController < ApplicationController
  before_filter :authenticate_admin!, :except => [:new, :create]
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
      flash[:alert] = "CAPTCHA confirmation failed!"
      render :action => 'new'
    else
      begin
        Account.transaction do
          @account.save!
          @owner = @account.owner
          @owner.account_id = @account.id
          @owner.save!
        end
        flash.now[:notice] = 'Account was successfully created.'
        render :show, :status => :created
      rescue StandardError => err
        render :action => :new, :status => :unprocessable_entity
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
