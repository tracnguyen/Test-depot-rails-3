class AddHasAttachmentToMessage < ActiveRecord::Migration
  def self.up
    add_column :messages, :has_attachments, :boolean
  end

  def self.down
    remove_column :messages, :has_attachments
  end
end
