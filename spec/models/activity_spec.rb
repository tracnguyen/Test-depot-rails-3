# == Schema Information
#
# Table name: activities
#
#  id            :integer         not null, primary key
#  account_id    :integer
#  applicant_id  :integer
#  job_id        :integer
#  actor_id      :integer
#  action        :string(255)
#  subject_id    :integer
#  subject_type  :string(255)
#  subject2_id   :integer
#  subject2_type :string(255)
#  prev_stage_id :integer
#  next_stage_id :integer
#  comment       :text
#  created_at    :datetime
#  updated_at    :datetime
#

require 'spec_helper'

describe Activity do
  pending "add some examples to (or delete) #{__FILE__}"
end

