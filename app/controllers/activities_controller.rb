class ActivitiesController < BaseAccountController
  before_filter :authenticate_user!
  
  def create
    @applicant = Applicant.find(params[:applicant_id])
    next_stage = params[:activity][:next_stage].nil? ? nil : JobStage.find(params[:activity][:next_stage])
    state_changed = (!next_stage.nil? && (next_stage != @applicant.job_stage))
    
    unless params[:activity][:comment].empty? && !state_changed
      @activity = @applicant.activities.build \
      	:actor => current_user,
      	:prev_stage => state_changed ? @applicant.job_stage : nil,
      	:next_stage => state_changed ? next_stage : nil,
      	:comment => params[:activity][:comment],
      	:job_id => @applicant.job_id,
      	:account_id => @applicant.account_id

      success = @activity.save 
      success &= @applicant.update_attribute(:job_stage, next_stage) if state_changed

      respond_to do |format|
        format.html { redirect_to @applicant, :notice => (success ? "Activity stream updated." : "Updating failed!") }
      end
    else
      respond_to do |format|
        format.html { redirect_to @applicant, :notice => "You haven't done anything!" }
      end
    end
  end
end
