class AddConverterToMessage < ActiveRecord::Migration
  def self.up
    add_column :messages, :converter_id, :integer
  end

  def self.down
    remove_column :messages, :converter_id
  end
end
