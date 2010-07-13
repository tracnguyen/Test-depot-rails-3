class CreateMessageReadings < ActiveRecord::Migration
  def self.up
    create_table :message_readings do |t|
      t.integer :user_id
      t.integer :message_id
      t.boolean :is_read, :default => false

      t.timestamps
    end
  end

  def self.down
    drop_table :message_readings
  end
end
