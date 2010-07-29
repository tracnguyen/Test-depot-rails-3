# == Schema Information
#
# Table name: attachments
#
#  id                      :integer         not null, primary key
#  caption                 :string(255)
#  attachable_id           :integer
#  attachable_type         :string(255)
#  attachment_file_name    :string(255)
#  attachment_content_type :string(255)
#  attachment_file_size    :integer
#  attachment_updated_at   :datetime
#  created_at              :datetime
#  updated_at              :datetime
#

require 'spec_helper'

describe Attachment do
  pending "add some examples to (or delete) #{__FILE__}"
end

