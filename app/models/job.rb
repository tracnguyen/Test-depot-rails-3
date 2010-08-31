# == Schema Information
#
# Table name: jobs
#
#  id               :integer         not null, primary key
#  account_id       :integer
#  title            :string(255)
#  description      :text
#  status           :string(255)
#  creation_date    :date
#  expiry_date      :date
#  applicants_count :integer
#

class Job < ActiveRecord::Base
  belongs_to :account
  has_many :applicants
  
  validates_presence_of :account, :title, :description, :expiry_date
#  validates :email, :length => {:minimum => 3, :maximum => 254},
#                    :uniqueness => true,
#                    :format => {:with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i}
  validates_acceptance_of :expiry_date, :if => Proc.new {|job| job.expiry_date && job.expiry_date <= Date.today}, :message => "must be in the future!"

  has_one :email_setting, :as => :configurable
  accepts_nested_attributes_for :email_setting
  
  after_create lambda {
    self.creation_date = Date.today
    self.save
  }
  
  STATUSES = ['draft', 'open', 'close']
  
  scope :open, where(:status => "open")
  
  state_machine :status, :initial => :draft do
    event :change_status do
      transition :draft => :open
      transition [:open, :close] => :close
    end
  end
  
  def has_email_setting?
    !self.email_setting.nil?
  end
  
end

