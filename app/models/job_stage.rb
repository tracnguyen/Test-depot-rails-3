# == Schema Information
#
# Table name: job_stages
#
#  id         :integer         not null, primary key
#  account_id :integer
#  name       :string(255)
#  position   :integer
#  color      :string(255)
#  is_deleted :boolean         default(FALSE)
#  created_at :datetime
#  updated_at :datetime
#

class JobStage < ActiveRecord::Base
  belongs_to :account
  
  validates_uniqueness_of :name, :case_sensitive => false
  
  default_scope :order => 'position'
  scope :undeleted, where(:is_deleted => false)  
  
  def before_validation
    self.name.strip!
  end
end

