class JobStatesController < ApplicationController
  # GET /job_states
  # GET /job_states.xml
  def index
    @job_states = JobState.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @job_states }
    end
  end

  # GET /job_states/1
  # GET /job_states/1.xml
  def show
    @job_state = JobState.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @job_state }
    end
  end

  # GET /job_states/new
  # GET /job_states/new.xml
  def new
    @job_state = JobState.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @job_state }
    end
  end

  # GET /job_states/1/edit
  def edit
    @job_state = JobState.find(params[:id])
  end

  # POST /job_states
  # POST /job_states.xml
  def create
    @job_state = JobState.new(params[:job_state])

    respond_to do |format|
      if @job_state.save
        format.html { redirect_to(@job_state, :notice => 'Job state was successfully created.') }
        format.xml  { render :xml => @job_state, :status => :created, :location => @job_state }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @job_state.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /job_states/1
  # PUT /job_states/1.xml
  def update
    @job_state = JobState.find(params[:id])

    respond_to do |format|
      if @job_state.update_attributes(params[:job_state])
        format.html { redirect_to(@job_state, :notice => 'Job state was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @job_state.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /job_states/1
  # DELETE /job_states/1.xml
  def destroy
    @job_state = JobState.find(params[:id])
    @job_state.destroy

    respond_to do |format|
      format.html { redirect_to(job_states_url) }
      format.xml  { head :ok }
    end
  end
end
