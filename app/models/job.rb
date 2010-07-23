class Job < ActiveRecord::Base
  belongs_to :account
  has_many :applicants
  
  validates_presence_of :account, :title, :description
#  validates :email, :length => {:minimum => 3, :maximum => 254},
#                    :uniqueness => true,
#                    :format => {:with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i}
  has_one :email_setting, :as => :configurable
  accepts_nested_attributes_for :email_setting
  
  after_create lambda {
    self.creation_date = Date.today
    self.save
  }
  
  STATUSES = ['draft', 'open', 'closed']
  
  scope :open, where(:status => "open")
  
  state_machine :status, :initial => :draft do
    event :change_status do
      transition :draft => :open
      transition [:open, :closed] => :closed
    end
  end
  
  def has_email_setting?
    !self.email_setting.blank? && !self.email_setting.username.blank?
  end
  
end
