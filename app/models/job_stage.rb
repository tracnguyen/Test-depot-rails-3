class JobStage < ActiveRecord::Base
  belongs_to :account
  
  default_scope :order => 'position'  
end
