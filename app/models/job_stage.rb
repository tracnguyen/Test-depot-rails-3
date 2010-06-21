class JobStage < ActiveRecord::Base
  belongs_to :account
  
  DEFAULT_STAGES = ["New", "Interview", "Test"]
end
