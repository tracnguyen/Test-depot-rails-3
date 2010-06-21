class CreateDefaultJobStates < ActiveRecord::Migration
  def self.up
    create_table :default_job_states do |t|
      t.integer :job_state_id

      t.timestamps
    end
    JobState.all.each {|job_state| DefaultJobState.create :job_state_id => job_state.id}
  end

  def self.down
    drop_table :default_job_states
  end
end
