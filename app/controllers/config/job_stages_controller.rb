class Config::JobStagesController < BaseAccountController
  before_filter :require_owner, :set_current_tab!
  layout 'config'
  
  def set_current_tab!
    @current_tab = ".tabs .right li:contains(Configuration)"
  end
  
  def index
    @job_stages = current_account.job_stages
    @first_stage = @job_stages.first
    @job_stages.slice!(0)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @job_stages }
    end
  end

  def show
    @job_stage = JobStage.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @job_stage }
    end
  end

  def new
    @job_stage = JobStage.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @job_stage }
    end
  end

  def edit
    @job_stage = JobStage.find(params[:id])
  end

  def create
    params[:job_stage][:position] = current_account.job_stages.size
    params[:job_stage][:color] = "#000000"
    @job_stage = current_account.job_stages.build(params[:job_stage])

    respond_to do |format|
      if @job_stage.save
        format.html { redirect_to(config_job_stages_path, :notice => 'Job stage was successfully created.') }
        format.xml  { render :xml => @job_stage, :status => :created, :location => @job_stage }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @job_stage.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @job_stage = JobStage.find(params[:id])

    respond_to do |format|
      if @job_stage.update_attributes(params[:job_stage])
        format.js {
        }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @job_stage.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @job_stage = JobStage.find(params[:id])
    @job_stage.destroy

    respond_to do |format|
      format.html { redirect_to(config_job_stages_url) }
      format.xml  { head :ok }
    end
  end
  
  def order
    orders = params[:order]  
    current_account.job_stages.each {|stage| stage.update_attributes(:position => orders.index(stage.id.to_s) + 1)}
    
    render :text => "hello"
  end
end
