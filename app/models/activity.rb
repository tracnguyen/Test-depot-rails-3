class Activity < ActiveRecord::Base
  belongs_to :applicant
  belongs_to :job
  belongs_to :account
  
  belongs_to :actor, :class_name => "User"
  
  belongs_to :subject, :polymorphic => true
  belongs_to :subject2, :polymorphic => true
  
  belongs_to :prev_stage, :class_name => "JobStage"
  belongs_to :next_stage, :class_name => "JobStage"
  
  default_scope order("created_at ASC")
end
