class JobFlowsController < ApplicationController
  # GET /job_flows
  # GET /job_flows.xml
  def index
    @job_flows = JobFlow.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @job_flows }
    end
  end

  # GET /job_flows/1
  # GET /job_flows/1.xml
  def show
    @job_flow = JobFlow.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @job_flow }
    end
  end

  # GET /job_flows/new
  # GET /job_flows/new.xml
  def new
    @job_flow = JobFlow.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @job_flow }
    end
  end

  # GET /job_flows/1/edit
  def edit
    @job_flow = JobFlow.find(params[:id])
  end

  # POST /job_flows
  # POST /job_flows.xml
  def create
    @job_flow = JobFlow.new(params[:job_flow])

    respond_to do |format|
      if @job_flow.save
        format.html { redirect_to(@job_flow, :notice => 'Job flow was successfully created.') }
        format.xml  { render :xml => @job_flow, :status => :created, :location => @job_flow }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @job_flow.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /job_flows/1
  # PUT /job_flows/1.xml
  def update
    @job_flow = JobFlow.find(params[:id])

    respond_to do |format|
      if @job_flow.update_attributes(params[:job_flow])
        format.html { redirect_to(@job_flow, :notice => 'Job flow was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @job_flow.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /job_flows/1
  # DELETE /job_flows/1.xml
  def destroy
    @job_flow = JobFlow.find(params[:id])
    @job_flow.destroy

    respond_to do |format|
      format.html { redirect_to(job_flows_url) }
      format.xml  { head :ok }
    end
  end
end
