class Applicant < ActiveRecord::Base
  belongs_to :job
  belongs_to :account

  has_attached_file :attachment,
                    :path => ":rails_root/public/assets/attachments/:basename.:extension",
                    :url => "/assets/attachments/:basename.:extension"

  validates_presence_of :first_name, :last_name, :email, :phone, :job
  validates_associated :job

  state_machine :status, :initial => :new do
    event :change_status do
      transition :new => :screened
      transition :screened => :interviewed
      transition :interviewed => :offered
      transition :offered => :hired
      transition :hired => :hired
      transition :rejected => :rejected
    end

    event :rejecting do
      transition [:new, :screened, :interviewed, :offered] => :rejected
      transition :hired => :hired
      transition :rejected => :rejected
    end
  end

  def after_validation
    job_error = errors.on(:job)
    errors.add(:job_id, job_error) if job_error
  end

end

