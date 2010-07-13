class MessageReading < ActiveRecord::Base
  belongs_to :user
  belongs_to :message
  scope :unread, where(:is_read => false)
  
  def self.mark_as_read(user, message)
    reading = MessageReading.where(:user_id => user.id, :message_id => message.id).first
    reading.is_read = true
    reading.save!
  end
  
  def self.mark_as_unread(user, message)
    reading = MessageReading.where(:user_id => user.id, :message_id => message.id).first
    reading.is_read = false
    reading.save!
  end
end
