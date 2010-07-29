# == Schema Information
#
# Table name: applicants
#
#  id                        :integer         not null, primary key
#  first_name                :string(255)
#  last_name                 :string(255)
#  email                     :string(255)
#  phone                     :string(255)
#  cover_letter              :text
#  job_id                    :integer
#  account_id                :integer
#  job_stage_id              :integer
#  is_archived               :boolean         default(FALSE)
#  is_starred                :boolean         default(FALSE)
#  created_at                :datetime
#  updated_at                :datetime
#  attachment_file_name      :string(255)
#  attachment_content_type   :string(255)
#  attachment_file_size      :integer
#  attachment_updated_at     :datetime
#  resume                    :text
#  cover_letter_content_type :string(255)     default("text")
#  resume_content_type       :string(255)
#

require 'spec_helper'

describe Applicant do
  pending "add some examples to (or delete) #{__FILE__}"
end

