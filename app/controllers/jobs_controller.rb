class JobsController < BaseAccountController
  before_filter :authenticate_user!, :set_current_tab!
  
  def set_current_tab!
    @current_tab = ".tabs .left li:contains(Jobs)"
  end
  
  def index
    @jobs = current_account.jobs.order("id DESC")

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @jobs }
    end
  end

  def new
    @job = Job.new
    setting = @job.build_email_setting
    unless current_account.email_setting.nil?
      setting.server = current_account.email_setting.server
      setting.port = current_account.email_setting.port
      setting.ssl = current_account.email_setting.ssl
      setting.protocol = current_account.email_setting.protocol
    end

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @job }
    end
  end

  def edit
    @job = Job.find(params[:id])
    if @job.has_email_setting?
      @setting = @job.email_setting
    else
      @setting = @job.build_email_setting
      @setting.server = current_account.email_setting.server
      @setting.port = current_account.email_setting.port
      @setting.ssl = current_account.email_setting.ssl
      @setting.protocol = current_account.email_setting.protocol
    end
  end

  def create
    params[:job][:status] = (params[:commit] == "Publish" ? "open" : "draft")
    @job = current_account.jobs.build(params[:job])
    respond_to do |format|
      if @job.save
        format.html { redirect_to(jobs_url, :notice => 'Job was successfully created.') }
        format.xml  { render :xml => @job, :status => :created, :location => @job }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @job.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @job = Job.find(params[:id])
    params[:job][:status] = "open" if params[:commit] == "Publish"
    params[:job][:status] = "close" if params[:commit] == "Close this job"

    respond_to do |format|
      if @job.update_attributes(params[:job])
        format.html { redirect_to(jobs_url, :notice => 'Job was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @job.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @job = Job.find(params[:id])
    @job.destroy

    respond_to do |format|
      format.html { redirect_to(jobs_url) }
      format.xml  { head :ok }
    end
  end
end
