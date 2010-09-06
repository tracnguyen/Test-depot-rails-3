class CreateDefaultMessageTemplates < ActiveRecord::Migration
  def self.up
    create_table :default_message_templates do |t|
      t.string :subject
      t.text :body
      
      t.timestamps
    end
  end

  def self.down
    drop_table :default_message_templates
  end
end
