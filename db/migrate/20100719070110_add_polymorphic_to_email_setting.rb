class AddPolymorphicToEmailSetting < ActiveRecord::Migration
  def self.up
    change_table :email_settings do |t|  
      t.references :configurable, :polymorphic => true 
      t.remove :account_id
    end
  end

  def self.down
    remove_column :email_settings, :configurable_id  
    remove_column :email_settings, :configurable_type
    add_column :email_settings, :account_id, :integer
  end
end
