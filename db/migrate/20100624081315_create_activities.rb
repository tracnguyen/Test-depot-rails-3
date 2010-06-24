class CreateActivities < ActiveRecord::Migration
  def self.up
    create_table :activities do |t|
      t.integer :account_id
      t.integer :applicant_id
      t.integer :job_id
      t.integer :actor_id
      t.string :action
      t.integer :subject_id
      t.string :subject_type
      t.integer :subject2_id
      t.string :subject2_type
      t.integer :prev_stage_id
      t.integer :next_stage_id
      t.text :comment

      t.timestamps
    end
  end

  def self.down
    drop_table :activities
  end
end
