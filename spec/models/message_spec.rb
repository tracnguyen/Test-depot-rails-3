# == Schema Information
#
# Table name: messages
#
#  id                :integer         not null, primary key
#  account_id        :integer
#  uid               :string(255)
#  sender_first_name :string(255)
#  sender_last_name  :string(255)
#  sender_email      :string(255)
#  subject           :string(255)
#  content           :text
#  content_type      :string(255)
#  converted         :boolean         default(FALSE)
#  applicant_id      :integer
#  created_at        :datetime
#  updated_at        :datetime
#  has_attachments   :boolean
#  converter_id      :integer
#  sender_phone      :string(255)
#

require 'spec_helper'

describe Message do
  pending "add some examples to (or delete) #{__FILE__}"
end

