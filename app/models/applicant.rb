class Applicant < ActiveRecord::Base
  belongs_to :job, :counter_cache => true
  belongs_to :account
  belongs_to :job_stage
  
  has_many :activities

  has_attached_file :attachment,
  	:path => ":rails_root/public/assets/resumes/:id/:basename.:extension",
  	:url => "/assets/resumes/:id/:basename.:extension"

  has_many :attachments, :as => :attachable
  attr_accessor :action, :message_id
  
  validates_presence_of :first_name, :last_name, :email, :phone, :job, :account, :action, :message_id
  validates_associated :job
#  validate do |applicant| 
#    if (applicant.resume.blank? && applicant.attachment_file_name.nil?)
#      applicant.errors.add :resume, "either (1) or (2) is required"
#      applicant.errors.add :attachment, "either (1) or (2) is required"
#    end
#  end

  before_create lambda { self.job_stage_id = self.account.job_stages.first.id }
  
  after_validation lambda {
    job_error = errors.on(:job)
    errors.add(:job_id, job_error) if job_error
  }
  
  def display_name
    first_name + " " + last_name
  end
  
end

