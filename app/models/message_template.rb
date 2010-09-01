class MessageTemplate < ActiveRecord::Base
  belongs_to :account
  validates_presence_of :subject, :body
end

# == Schema Information
#
# Table name: message_templates
#
#  id         :integer         not null, primary key
#  subject    :string(255)
#  body       :text
#  account_id :integer
#  created_at :datetime
#  updated_at :datetime
#

