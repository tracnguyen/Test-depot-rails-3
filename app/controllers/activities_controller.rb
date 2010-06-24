class ActivitiesController < BaseAccountController
  before_filter :authenticate_user!
  
  def create
    @applicant = Applicant.find(params[:applicant_id])
    next_stage = JobStage.find(params[:activity][:next_stage])
    state_changed = (next_stage != @applicant.job_stage)
    @activity = @applicant.activities.build \
    	:actor => current_user,
    	:prev_stage => state_changed ? @applicant.job_stage : nil,
    	:next_stage => state_changed ? next_stage : nil,
    	:comment => params[:activity][:comment],
    	:job_id => @applicant.job_id,
    	:account_id => @applicant.account_id
    success = @activity.save
    if state_changed
      success &= @applicant.update_attribute(:job_stage, next_stage)
    end
    respond_to { |fmt|
      if success
        fmt.html {
          redirect_to @applicant, :notice => "Activity stream updated."
        }
      else
        fmt.xml {
          render :xml => @activity.errors, :status => :unprocessable_entity
        }
      end
    }
  end
end