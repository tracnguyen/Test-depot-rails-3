class JobFlow < ActiveRecord::Base
  belongs_to :account
  belongs_to :job_state
end
