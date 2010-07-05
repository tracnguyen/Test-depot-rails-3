class JobStage < ActiveRecord::Base
  belongs_to :account
  
  default_scope :order => 'position'
  scope :unarchived, where(:is_archived => false)  
end
