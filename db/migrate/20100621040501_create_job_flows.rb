class CreateJobFlows < ActiveRecord::Migration
  def self.up
    create_table :job_flows do |t|
      t.integer :account_id
      t.integer :job_state_id

      t.timestamps
    end
  end

  def self.down
    drop_table :job_flows
  end
end
