class Pub::ApplicantsController < BaseAccountController
  layout 'public'

  def new
    @applicant = Applicant.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @applicant }
    end
  end

  def create
    params[:applicant][:job_id] = params[:job_id]
    params[:applicant][:job_stage_id] = current_account.job_stages.first.id
    @applicant = current_account.applicants.build(params[:applicant])

    respond_to do |format|
      if @applicant.save
        format.html { redirect_to(pub_jobs_path, :notice => 'Thank you for applying!') }
        format.xml  { render :xml => @applicant, :status => :created, :location => @applicant }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @applicant.errors, :status => :unprocessable_entity }
      end
    end
  end
end
