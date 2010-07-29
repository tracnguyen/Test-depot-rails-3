# == Schema Information
#
# Table name: job_stages
#
#  id         :integer         not null, primary key
#  account_id :integer
#  name       :string(255)
#  position   :integer
#  color      :string(255)
#  is_deleted :boolean         default(FALSE)
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe JobStage do
  pending "add some examples to (or delete) #{__FILE__}"
end

