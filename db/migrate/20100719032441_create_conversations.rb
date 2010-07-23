class CreateConversations < ActiveRecord::Migration
  def self.up
    create_table :conversations do |t|
      t.string :content_type
      t.text :message
      t.boolean :outcome
      t.integer :applicant_id

      t.timestamps
    end
  end

  def self.down
    drop_table :conversations
  end
end
