class ApplicantsController < BaseAccountController
  before_filter :authenticate_user!, :set_current_tab!
  
  def set_current_tab!
    @current_tab = ".tabs .left li:contains(Applications)"
  end
  
  def index
    @job = params[:job_title]
    @status = params[:apt_status]
    # This will result in only a single SQL query, thanks to ActiveRelation
    @applicants = current_account.applicants.order('created_at DESC').includes(:job_stage)
    @applicants = @applicants.where({:job_id => @job}) unless @job.nil? || @job.empty?
    @applicants = @applicants.where({:job_stage_id => @status}) unless @job.nil? || @status.empty?

    @read_status = current_user.read_status(@applicants)
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @applicants }
    end
  end

  def show
    @applicant = Applicant.find(params[:id])
    current_user.mark_as_read(@applicant)
    
    @activities = @applicant.activities
    @activity = @applicant.activities.build
    @statuses = current_account.job_stages.map { |s| s.name }

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @applicant }
    end
  end

  def edit
    @applicant = Applicant.find(params[:id])
  end

  def new
    @applicant = Applicant.new(:job_stage_id => current_account.job_stages.first.id)

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @applicant }
    end
  end

  def create
    @applicant = Applicant.new(params[:applicant])
    @applicant.account_id = current_account.id

    respond_to do |format|
      if @applicant.save
        format.html { redirect_to(applicants_url, :notice => 'Applicant was successfully created.') }
        format.xml  { render :xml => @applicant, :status => :created, :location => @applicant }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @applicant.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /applicants/1
  # PUT /applicants/1.xml
  def update
    @applicant = Applicant.find(params[:id])
    remove_attachment = params[:remove_attachment] == "true"
    @applicant.attachment = nil if remove_attachment

    respond_to do |format|
      if @applicant.update_attributes(params[:applicant])
        if remove_attachment
          format.html { redirect_to(edit_applicant_url(@applicant), :notice => 'The attachment has been removed.') }
        else
          format.html { redirect_to(@applicant, :notice => 'Applicant was successfully updated.') }
        end
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @applicant.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @applicant = Applicant.find(params[:id])
    @applicant.destroy

    respond_to do |format|
      format.html { redirect_to(applicants_url) }
      format.xml  { head :ok }
    end
  end
  
  def mark_as_unread
    @applicant = Applicant.find(params[:id])
    current_user.mark_as_unread(@applicant)
    respond_to do |format|
      format.xml  { head :ok }
      format.html { redirect_to(applicants_path) }
    end
  end
end

