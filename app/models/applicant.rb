class Applicant < ActiveRecord::Base
  belongs_to :job, :counter_cache => true
  belongs_to :account
  belongs_to :job_stage
  
  has_many :activities

  has_attached_file :attachment,
  	:path => ":rails_root/public/assets/attachments/:basename.:extension",
  	:url => "/assets/attachments/:basename.:extension"

  has_many :attachments, :as => :attachable
  
  validates_presence_of :first_name, :last_name, :email, :phone, :job, :job_stage
  validates_associated :job

  after_validation lambda {
    job_error = errors.on(:job)
    errors.add(:job_id, job_error) if job_error
  }
  
  def display_name
    first_name + " " + last_name
  end
end

