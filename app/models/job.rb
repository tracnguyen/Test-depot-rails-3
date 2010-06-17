class Job < ActiveRecord::Base
  has_many :applicants
  
  scope :open, where(:status => "open")

  state_machine :status, :initial => :draft do

    event :change_status do
      transition :draft => :open
      transition [:open, :close] => :close
    end
  end
end
