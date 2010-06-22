class Applicant < ActiveRecord::Base
  belongs_to :job
  belongs_to :account
  belongs_to :job_stage

  has_attached_file :attachment,
                    :path => ":rails_root/public/assets/attachments/:basename.:extension",
                    :url => "/assets/attachments/:basename.:extension"

  validates_presence_of :first_name, :last_name, :email, :phone, :job, :job_stage
  validates_associated :job


  def after_validation
    job_error = errors.on(:job)
    errors.add(:job_id, job_error) if job_error
  end
end

