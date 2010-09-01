class AddSubjectToConversations < ActiveRecord::Migration
  def self.up
    add_column :conversations, :subject, :string
  end

  def self.down
    remove_column :conversations, :subject, :string
  end
end
