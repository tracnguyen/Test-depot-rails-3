# == Schema Information
#
# Table name: default_job_stages
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  color      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class DefaultJobStage < ActiveRecord::Base
end

