# == Schema Information
#
# Table name: conversations
#
#  id           :integer         not null, primary key
#  content_type :string(255)
#  message      :text
#  outcome      :boolean
#  applicant_id :integer
#  created_at   :datetime
#  updated_at   :datetime
#

require 'spec_helper'

describe Conversation do
  pending "add some examples to (or delete) #{__FILE__}"
end

