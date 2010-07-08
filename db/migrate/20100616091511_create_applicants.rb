class CreateApplicants < ActiveRecord::Migration
  def self.up
    create_table :applicants do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :phone
      t.text :cv
      t.integer :job_id
      t.integer :account_id
      t.integer :job_stage_id
      t.boolean :is_archived, :default => false
      t.boolean :is_starred, :default => false
      
      t.timestamps
    end
  end

  def self.down
    drop_table :applicants
  end
end
