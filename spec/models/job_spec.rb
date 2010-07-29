# == Schema Information
#
# Table name: jobs
#
#  id               :integer         not null, primary key
#  account_id       :integer
#  title            :string(255)
#  description      :text
#  status           :string(255)
#  creation_date    :date
#  expiry_date      :date
#  applicants_count :integer
#

require 'spec_helper'

describe Job do
  pending "add some examples to (or delete) #{__FILE__}"
end

