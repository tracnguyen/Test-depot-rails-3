class Job < ActiveRecord::Base
  belongs_to :account
  has_many :applicants
  
  def after_create
    self.creation_date = Date.today
    self.save
  end
  
  scope :open, where(:status => "open")

  state_machine :status, :initial => :draft do
    event :change_status do
      transition :draft => :open
      transition [:open, :close] => :close
    end
  end
end
