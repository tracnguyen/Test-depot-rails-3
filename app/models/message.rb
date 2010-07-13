class Message < ActiveRecord::Base
  belongs_to :account
  has_many :attachments, :as => :attachable
  has_one :converter, :class_name => 'User', :foreign_key => 'converter_id'
  has_many :message_readings
  has_many :readers, :through => :message_readings, :source => :user
  
  attr_accessor :is_read
  
  def unread?
    is_read.nil? || !is_read
  end
end
