class JobStatesController < ApplicationController
  before_filter :authenticate_user!

  def index
    @job_states = JobState.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @job_states }
    end
  end

  def show
    @job_state = JobState.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @job_state }
    end
  end

  def new
    @job_state = JobState.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @job_state }
    end
  end

  def edit
    @job_state = JobState.find(params[:id])
  end

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

  def destroy
    @job_state = JobState.find(params[:id])
    @job_state.destroy

    respond_to do |format|
      format.html { redirect_to(job_states_url) }
      format.xml  { head :ok }
    end
  end
end
