class Pub::JobsController < BaseAccountController
  layout 'public'
  
  def index
    @jobs = current_account.jobs.open

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @jobs }
    end
  end

  def show
    @job = Job.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @job }
    end
  end
end
