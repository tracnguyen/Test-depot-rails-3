class Config::JobStagesController < BaseAccountController
  before_filter :require_owner, :set_current_tab!
  layout 'config'
  
  def set_current_tab!
    @current_tab = ".tabs .right li:contains(Configuration)"
  end
  
  def index
    @job_stages = current_account.job_stages.undeleted
    @first_stage = @job_stages.first
    @job_stages.slice!(0)
    @job_stage = JobStage.new

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @job_stages }
    end
  end

  def create
    params[:job_stage][:position] = current_account.job_stages.size
    params[:job_stage][:color] = "#000000"
    @job_stage = current_account.job_stages.build(params[:job_stage])

    respond_to do |format|
      @saved = @job_stage.save
      @job_stages = current_account.job_stages.undeleted
      @first_stage = @job_stages.first
      @job_stages.slice!(0)

      if @saved
        format.js
        format.html { redirect_to(config_job_stages_path, :notice => 'Job stage was successfully created.') }
        format.xml  { render :xml => @job_stage, :status => :created, :location => @job_stage }
      else
        format.js
        format.html { render :action => "index" }
        format.xml  { render :xml => @job_stage.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @job_stage = JobStage.find(params[:id])
    @params = params
    
    respond_to do |format|
      case 
        when params[:order]
          orders = params[:order] 
          stages = current_account.job_stages
          stages.slice!(0) 
          stages.each {|stage| stage.update_attributes(:position => orders.index(stage.id.to_s) + 1)}
          render :nothing => true
        when params[:job_stage][:name]
          @updated = @job_stage.update_attributes(params[:job_stage])
          format.js
        when params[:job_stage][:color]
          if @job_stage.update_attributes(params[:job_stage])
            render :nothing => true
          else
            render :js => "alert('update failed!');"
          end
          
      end
    end
  end

  def destroy
    @job_stage = JobStage.find(params[:id])

    respond_to do |format|
      message = @job_stage.update_attributes({:is_deleted => true, :name => @job_stage.name + ' (deleted)'}) ? 'Job stage was successfully deleted.' : 'Job stage deletion failed.'
        
      format.html { redirect_to(config_job_stages_url, :alert => message) }
      format.xml  { head :ok }
    end
  end
end
