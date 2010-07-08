class CreateMessages < ActiveRecord::Migration
  def self.up
    create_table :messages do |t|
      t.references :account
      t.string :uid
      t.string :sender_first_name
      t.string :sender_last_name
      t.string :sender_email
      t.string :subject
      t.text :content      
      t.string :content_type
      t.boolean :converted, :default => false
      t.integer :applicant_id

      t.timestamps
    end
  end

  def self.down
    drop_table :messages
  end
end
