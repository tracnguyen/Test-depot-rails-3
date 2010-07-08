class CreateEmailSettings < ActiveRecord::Migration
  def self.up
    create_table :email_settings do |t|
      t.references :account
      t.string :server
      t.string :port
      t.string :username
      t.string :password
      t.boolean :ssl, :default => true
      t.string :protocol

      t.timestamps
    end
  end

  def self.down
    drop_table :email_settings
  end
end
