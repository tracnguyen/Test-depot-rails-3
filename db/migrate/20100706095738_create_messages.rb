class CreateMessages < ActiveRecord::Migration
  def self.up
    create_table :messages do |t|
      t.references :account
      t.string :uid
      t.string :from
      t.string :subject
      t.text :content      
      t.string :content_type

      t.timestamps
    end
  end

  def self.down
    drop_table :messages
  end
end
