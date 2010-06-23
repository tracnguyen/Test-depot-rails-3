class CreateInvitations < ActiveRecord::Migration
  def self.up
    create_table :invitations do |t|
      t.string :email
      t.string :token
      t.integer :inviter_id
    end
    
    add_index :invitations, :token, :unique => true
  end

  def self.down
    drop_table :invitations
  end
end
