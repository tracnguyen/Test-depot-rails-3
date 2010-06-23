class Job < ActiveRecord::Base
  belongs_to :account
  has_many :applicants
  
  after_create lambda {
    self.creation_date = Date.today
    self.save
  }
  
  scope :open, where(:status => "open")

  state_machine :status, :initial => :draft do
    event :change_status do
      transition :draft => :open
      transition [:open, :close] => :close
    end
  end
end
