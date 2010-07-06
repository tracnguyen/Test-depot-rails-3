class CreateJobStages < ActiveRecord::Migration
  def self.up
    create_table :job_stages do |t|
      t.integer :account_id
      t.string :name
      t.integer :position
      t.string :color
      t.boolean :is_deleted, :default => false
      
      t.timestamps
    end
  end

  def self.down
    drop_table :job_stages
  end
end
