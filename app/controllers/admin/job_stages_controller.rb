class Admin::JobStagesController < BaseAccountController
  # GET /job_stages
  # GET /job_stages.xml
  def index
    @job_stages = JobStage.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @job_stages }
    end
  end

  # GET /job_stages/1
  # GET /job_stages/1.xml
  def show
    @job_stage = JobStage.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @job_stage }
    end
  end

  # GET /job_stages/new
  # GET /job_stages/new.xml
  def new
    @job_stage = JobStage.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @job_stage }
    end
  end

  # GET /job_stages/1/edit
  def edit
    @job_stage = JobStage.find(params[:id])
  end

  # POST /job_stages
  # POST /job_stages.xml
  def create
    @job_stage = current_account.job_stages.build(params[:job_stage])

    respond_to do |format|
      if @job_stage.save
        format.html { redirect_to(@job_stage, :notice => 'Job stage was successfully created.') }
        format.xml  { render :xml => @job_stage, :status => :created, :location => @job_stage }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @job_stage.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /job_stages/1
  # PUT /job_stages/1.xml
  def update
    @job_stage = JobStage.find(params[:id])

    respond_to do |format|
      if @job_stage.update_attributes(params[:job_stage])
        format.html { redirect_to(@job_stage, :notice => 'Job stage was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @job_stage.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /job_stages/1
  # DELETE /job_stages/1.xml
  def destroy
    @job_stage = JobStage.find(params[:id])
    @job_stage.destroy

    respond_to do |format|
      format.html { redirect_to(job_stages_url) }
      format.xml  { head :ok }
    end
  end
end
