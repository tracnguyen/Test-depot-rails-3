# == Schema Information
#
# Table name: accounts
#
#  id          :integer         not null, primary key
#  name        :string(255)
#  description :string(255)
#  subdomain   :string(255)
#  owner_id    :integer
#  created_at  :datetime
#  updated_at  :datetime
#

require 'spec_helper'

describe Account do
  pending "add some examples to (or delete) #{__FILE__}"
end

