class Activity < ActiveRecord::Base
  belongs_to :applicant
  belongs_to :job
  belongs_to :account
  
  belongs_to :actor, :class_name => "User"
  
  belongs_to :subject, :polymorphic => true
  belongs_to :subject2, :polymorphic => true
  
  has_one :prev_stage, :class_name => "JobStage"
  has_one :next_stage, :class_name => "JobStage"
end
