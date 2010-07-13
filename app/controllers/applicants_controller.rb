class ApplicantsController < BaseAccountController
  before_filter :authenticate_user!, :set_current_tab!
  
  def set_current_tab!
    @current_tab = ".tabs .left li:contains(Applications)"
  end
  
  def index
    @job = params[:job_title]
    @status = params[:apt_status]
    # This will result in only a single SQL query, thanks to ActiveRelation
    if @job.nil? || @job.empty?
      @applicants = current_account.applicants
    else
      @applicants = Applicant.where({:job_id => @job})
    end
    @applicants = @applicants.where({:job_stage_id => @status}) unless @job.nil? || @status.empty?
    @applicants = @applicants.order('created_at DESC').includes(:job, :job_stage)

    @read_status = current_user.read_status(@applicants)
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @applicants }
    end
  end

  def show
    @applicant = Applicant.where(:id => params[:id]).includes(:job).first
    UserView.mark_as_read(current_user, @applicant)
    
    @activities = @applicant.activities.order("created_at ASC").includes(:actor, :prev_stage, :next_stage).all
    @activity = @applicant.activities.build

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @applicant }
    end
  end

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
    remove_attachment = (params[:remove_attachment] == "true")
    @applicant.attachment = nil if remove_attachment

    case
      when params[:starring]
        if @applicant.update_attribute(:is_starred, !@applicant.is_starred)
          render :js => "$('##{@applicant.id}').children('.star').children('.star-icon').toggle(); $('##{@applicant.id}').toggleClass('unstarred'); $('##{@applicant.id}').toggleClass('starred');"
        else 
          render :nothing => true 
        end
      else
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

  def destroy
    @applicant = Applicant.find(params[:id])
    @applicant.destroy

    respond_to do |format|
      format.html { redirect_to(applicants_url) }
      format.xml  { head :ok }
    end
  end
  
  def mark_as_unread
    @applicant = Applicant.find(params[:id])
    UserView.mark_as_unread(current_user, @applicant)
    respond_to do |format|
      format.xml  { head :ok }
      format.html { redirect_to(applicants_path) }
    end
  end
  
  def batch_process
    case
      when params[:commit] == "Archive" && params[:selection]
        params[:selection].each do |t|
          Applicant.find(t).update_attribute(:is_archived, true)
        end
        
      when params[:commit] == "Delete" && params[:selection]
        params[:selection].each do |t|
          Applicant.find(t).destroy
        end
    end 
    redirect_to(applicants_url)
  end
  
  def cover_letter
    applicant = Applicant.find(params[:id])
    render :partial => "shared/viewer", :locals => {:content_type => applicant.cover_letter_content_type,
                                                    :content => applicant.cover_letter}
  end
  
  def resume
    applicant = Applicant.find(params[:id])
    render :partial => "shared/viewer", :locals => {:content_type => applicant.resume_content_type,
                                                    :content => applicant.resume}
  end
end

