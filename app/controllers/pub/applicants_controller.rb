class Pub::ApplicantsController < BaseAccountController
  layout 'public'

  def new
    @applicant = Applicant.new(:job_id =>params[:job_id])

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @applicant }
    end
  end

  def create
    params[:applicant][:job_id] = params[:job_id]
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
