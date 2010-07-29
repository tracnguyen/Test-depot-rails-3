# == Schema Information
#
# Table name: activities
#
#  id            :integer         not null, primary key
#  account_id    :integer
#  applicant_id  :integer
#  job_id        :integer
#  actor_id      :integer
#  action        :string(255)
#  subject_id    :integer
#  subject_type  :string(255)
#  subject2_id   :integer
#  subject2_type :string(255)
#  prev_stage_id :integer
#  next_stage_id :integer
#  comment       :text
#  created_at    :datetime
#  updated_at    :datetime
#

class Activity < ActiveRecord::Base
  belongs_to :applicant
  belongs_to :job
  belongs_to :account
  
  belongs_to :actor, :class_name => "User"
  
  belongs_to :subject, :polymorphic => true  
  belongs_to :subject2, :polymorphic => true  
  
  belongs_to :prev_stage, :class_name => "JobStage"
  belongs_to :next_stage, :class_name => "JobStage"
end

