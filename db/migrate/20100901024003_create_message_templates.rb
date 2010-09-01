class CreateMessageTemplates < ActiveRecord::Migration
  def self.up
    create_table :message_templates do |t|
      t.string :subject
      t.text :body
      t.integer :account_id
      
      t.timestamps
    end
  end

  def self.down
    drop_table :message_templates
  end
end
