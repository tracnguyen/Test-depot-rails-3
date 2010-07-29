# == Schema Information
#
# Table name: email_settings
#
#  id                :integer         not null, primary key
#  server            :string(255)
#  port              :string(255)
#  username          :string(255)
#  password          :string(255)
#  ssl               :boolean         default(TRUE)
#  protocol          :string(255)
#  created_at        :datetime
#  updated_at        :datetime
#  configurable_id   :integer
#  configurable_type :string(255)
#

require 'spec_helper'

describe EmailSetting do
  pending "add some examples to (or delete) #{__FILE__}"
end

