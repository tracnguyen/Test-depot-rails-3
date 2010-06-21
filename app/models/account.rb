class Account < ActiveRecord::Base
  has_many :users
  has_many :jobs
  has_many :job_flows
  has_many :job_states, :through => :job_flows
  has_many :applicants
  
  has_one :owner, :class_name => "User"
  accepts_nested_attributes_for :owner
  
  after_create lambda{ 
        DefaultJobState.all.each do |job_state| 
          JobFlow.create :account_id => self.id, :job_state_id => job_state.id
        end 
      }
end

