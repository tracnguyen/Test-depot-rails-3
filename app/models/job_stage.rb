class JobStage < ActiveRecord::Base
  belongs_to :account
  
  default_scope :order => 'position'
  scope :undeleted, where(:is_deleted => false)  
end
