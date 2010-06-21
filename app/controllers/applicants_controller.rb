class ApplicantsController < BaseAccountController
  # GET /applicants
  # GET /applicants.xml
  def index
    @job = params[:job_title]
    @status = params[:apt_status]
    conditions = (@job.to_s.empty? ? {} : {:job_id => @job}).merge!((@status.to_s.empty? ? {} : {:status => @status}))
    @applicants = current_account.applicants.where(conditions)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @applicants }
    end
  end

  # GET /applicants/1
  # GET /applicants/1.xml
  def show
    @applicant = Applicant.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @applicant }
    end
  end

  # GET /applicants/1/edit
  def edit
    @applicant = Applicant.find(params[:id])
  end

  def new
    @applicant = Applicant.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @applicant }
    end
  end

  # POST /applicants
  # POST /applicants.xml
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

  # DELETE /applicants/1
  # DELETE /applicants/1.xml
  def destroy
    @applicant = Applicant.find(params[:id])
    @applicant.destroy

    respond_to do |format|
      format.html { redirect_to(applicants_url) }
      format.xml  { head :ok }
    end
  end

end

