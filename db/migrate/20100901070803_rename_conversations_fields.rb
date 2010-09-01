class RenameConversationsFields < ActiveRecord::Migration
  def self.up
    rename_column :conversations, :outcome, :outgoing
    rename_column :conversations, :message, :body
  end

  def self.down
    rename_column :conversations, :outgoing, :outcome
    rename_column :conversations, :body, :message
  end
end
