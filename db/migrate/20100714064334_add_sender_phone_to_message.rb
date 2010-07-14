class AddSenderPhoneToMessage < ActiveRecord::Migration
  def self.up
    add_column :messages, :sender_phone, :string
  end

  def self.down
    remove_column :messages, :sender_phone
  end
end
