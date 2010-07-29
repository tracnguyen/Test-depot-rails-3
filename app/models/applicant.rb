# == Schema Information
#
# Table name: applicants
#
#  id                        :integer         not null, primary key
#  first_name                :string(255)
#  last_name                 :string(255)
#  email                     :string(255)
#  phone                     :string(255)
#  cover_letter              :text
#  job_id                    :integer
#  account_id                :integer
#  job_stage_id              :integer
#  is_archived               :boolean         default(FALSE)
#  is_starred                :boolean         default(FALSE)
#  created_at                :datetime
#  updated_at                :datetime
#  attachment_file_name      :string(255)
#  attachment_content_type   :string(255)
#  attachment_file_size      :integer
#  attachment_updated_at     :datetime
#  resume                    :text
#  cover_letter_content_type :string(255)     default("text")
#  resume_content_type       :string(255)
#

class Applicant < ActiveRecord::Base
  belongs_to :job, :counter_cache => true
  belongs_to :account
  belongs_to :job_stage
  
  has_many :activities
  has_many :conversations

  has_attached_file :attachment,
  	:path => ":rails_root/public/assets/resumes/:id/:basename.:extension",
  	:url => "/assets/resumes/:id/:basename.:extension"

  has_many :attachments, :as => :attachable, :dependent => :destroy
  attr_accessor :action, :message_id
  
  validates_presence_of :first_name, :last_name, :email, :phone, :job, :account
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
    first_name.capitalize + " " + last_name.capitalize
  end
  
end


